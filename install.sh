#!/bin/bash
set -e

echo "Installing OLO Appliance..."

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
    echo "Directory already exists. Updating..."
    cd olo-appliance-release
    git pull
else
    git clone https://github.com/OLO-Robotics/olo-appliance-release.git
    cd olo-appliance-release
fi

# Make setup script executable and run it
echo "Setting up OLO Appliance..."
chmod +x setup.sh
./setup.sh --defaults

echo ""
echo "✅ OLO Appliance installed successfully!"
echo ""
echo "To start the appliance, run:"
echo "  cd olo-appliance-release"
echo "  ./setup.sh --dist"
echo ""
echo "For more information, see the README.md file." 