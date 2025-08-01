#!/bin/bash
# Setup script for the OLO Appliance
# Usage: 
#   ./setup.sh [--defaults] [--dist] [reconfigure|reconfigure-port] [environment]
#   --defaults: Use default configuration options without prompting
#   --dist: Run the obfuscated version from dist folder instead of npm start
#   reconfigure: Update username/password credentials
#   reconfigure-port: Update appliance port

# Exit on error
set -e

# Check for --defaults and --dist flags
USE_DEFAULTS=false
USE_DIST=false
if [ "$1" == "--defaults" ]; then
    USE_DEFAULTS=true
    shift  # Remove --defaults from arguments
elif [ "$1" == "--dist" ]; then
    USE_DIST=true
    shift  # Remove --dist from arguments
fi

if [ "$1" == "reconfigure" ]; then
    echo "Reconfiguring credentials..."
    read -p "Enter username: " USERNAME
    read -s -p "Enter password: " PASSWORD
    echo
    echo "APP_USERNAME=$USERNAME" > .env
    echo "APP_PASSWORD=$PASSWORD" >> .env
    echo ".env file updated with new credentials."
    exit 0
fi

if [ "$1" == "reconfigure-port" ]; then
    echo "Reconfiguring appliance port..."
    read -p "Enter port number: " PORT
    # Append or update PORT in .env
    grep -v '^PORT=' .env 2>/dev/null > .env.tmp || true
    echo "PORT=$PORT" >> .env.tmp
    mv .env.tmp .env
    echo ".env file updated with new port."
    exit 0
fi

# Trap to clean up rosbridge processes on exit
cleanup() {
    echo "Cleaning up any rosbridge_server or ros2 launch processes..."
    ps aux | grep '[r]osbridge_websocket' | awk '{print $2}' | xargs -r kill -9
    ps aux | grep '[r]osbridge_websocket_launch.xml' | awk '{print $2}' | xargs -r kill -9
}
trap cleanup EXIT

echo "Setting up Node.js Appliance in WSL..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    # Add NodeSource repository
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    # Install Node.js
    sudo apt-get install -y nodejs
fi

# Install dependencies
echo "Installing dependencies..."
npm install

echo "Setup completed successfully!"

# ROSbridge setup for ROS2
echo "ROSbridge configuration..."
if [ "$USE_DEFAULTS" = true ]; then
    use_local="y"
    echo "Using local ROSbridge instance (default)"
else
    read -p "Do you want to use a local ROSbridge instance? (Y/n): " use_local
    # Default to "y" if user just presses Enter
    use_local=${use_local:-y}
fi

if [ "$use_local" = "y" ] || [ "$use_local" = "Y" ]; then
    # First, check if rosbridge_server is installed
    if ! ros2 pkg list | grep -q rosbridge_server; then
        echo "ROSbridge is not installed."
        read -p "Would you like to install ROSbridge now? (Y/n): " install_rosbridge
        # Default to "y" if user just presses Enter
        install_rosbridge=${install_rosbridge:-y}
        
        if [ "$install_rosbridge" = "y" ] || [ "$install_rosbridge" = "Y" ]; then
            sudo apt install ros-humble-rosbridge-server
        else
            echo "Cannot proceed without ROSbridge."
            exit 1
        fi
    else
        echo "ROSbridge is already installed."
    fi

    # Update or create .appliance.json with local config
    if [ -f .appliance.json ] && jq empty .appliance.json 2>/dev/null; then
        jq '.rosbridgeHost = "localhost" | .rosbridgePort = 9090' .appliance.json > tmp.$$.json
    else
        echo '{"rosbridgeHost":"localhost","rosbridgePort":9090}' > tmp.$$.json
    fi
    mv tmp.$$.json .appliance.json

    # Now check if ROSbridge is running
    echo "DEBUG: Checking if anything is listening on localhost:9090"
    if nc -zv localhost 9090; then
        echo "ROSbridge is already running on localhost:9090."
    else
        echo "ROSbridge is NOT running on localhost:9090."
        echo "DEBUG: nc exit code: $?"
        if [ "$USE_DEFAULTS" = true ]; then
            start_rosbridge="y"
            echo "Starting ROSbridge (default)"
        else
            read -p "ROSbridge is not running. Start now? (Y/n): " start_rosbridge
            # Default to "y" if user just presses Enter
            start_rosbridge=${start_rosbridge:-y}
        fi
        
        if [ "$start_rosbridge" = "y" ] || [ "$start_rosbridge" = "Y" ]; then
            echo "Killing any existing rosbridge_server or ros2 launch processes..."
            ps aux | grep '[r]osbridge_websocket' | awk '{print $2}' | xargs -r kill -9
            ps aux | grep '[r]osbridge_websocket_launch.xml' | awk '{print $2}' | xargs -r kill -9
            sleep 2
            echo "Attempting to start ROSbridge..."
            source /opt/ros/humble/setup.bash
            ros2 launch rosbridge_server rosbridge_websocket_launch.xml > rosbridge.log 2>&1 &
            sleep 5
            echo "ROSbridge launch attempted. Check rosbridge.log for details if it does not work."
            echo "Checking for running rosbridge processes:"
            ps aux | grep rosbridge | grep -v grep
        fi
    fi
else
    # Remote ROSbridge configuration
    read -p "Enter the hostname or IP of your ROSbridge instance: " host
    read -p "Enter the port of your ROSbridge instance: " port
    if [ -f .appliance.json ] && jq empty .appliance.json 2>/dev/null; then
        jq --arg host "$host" --argjson port "$port" '.rosbridgeHost = $host | .rosbridgePort = $port' .appliance.json > tmp.$$.json
    else
        echo "{\"rosbridgeHost\":\"$host\",\"rosbridgePort\":$port}" > tmp.$$.json
    fi
    mv tmp.$$.json .appliance.json
fi

# Set environment based on argument or default to development
# If --dist is used, always use production environment
if [ "$USE_DIST" = true ]; then
    ENV="production"
    echo "Starting release application from dist folder in production mode..."
    export NODE_ENV=$ENV
    node dist/index.js
else
    ENV=${1:-development}
    echo "Starting application in $ENV mode..."
    export NODE_ENV=$ENV
    npm start
fi 