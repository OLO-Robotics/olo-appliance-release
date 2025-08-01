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
chmod +x setup.sh
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