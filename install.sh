#!/bin/bash
set -e

echo "Installing OLO Appliance..."

# Create a clean installation directory
INSTALL_DIR="$HOME/olo-appliance"
echo "Creating installation directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    sudo apt-get update
    sudo apt-get install -y git
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Clone the repository
echo "Downloading OLO Appliance..."
if [ -d "olo-appliance-release" ]; then
    echo "Directory already exists. Removing and re-cloning for clean install..."
    rm -rf olo-appliance-release
fi

git clone https://github.com/OLO-Robotics/olo-appliance-release.git
cd olo-appliance-release

# Just install dependencies without starting the app
echo "Installing dependencies..."
cd app

# Debug: Check current permissions
echo "Current setup.sh permissions:"
ls -la setup.sh

# Ensure setup.sh is executable with multiple attempts
echo "Setting execute permissions on setup.sh..."
chmod +x setup.sh
chmod 755 setup.sh

# Verify permissions were set
echo "After setting permissions:"
ls -la setup.sh

# Test if the file is actually executable
if [ -x setup.sh ]; then
    echo "✅ setup.sh is now executable"
else
    echo "❌ Failed to make setup.sh executable"
    echo "Manual fix required: chmod +x setup.sh"
fi

npm install
cd ..

echo ""
echo "✅ OLO Appliance installed successfully!"
echo ""
echo "To configure and start the appliance:"
echo "  cd ~/olo-appliance/olo-appliance-release/app"
echo "  ./setup.sh --defaults --dist"
echo ""
echo "Note: You will be prompted for your username and password when starting."
echo ""
echo "For more information, see the README.md file." 