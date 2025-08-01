# OLO Appliance - Quick Install

This is the release version of the OLO Appliance. Follow these simple steps to install and run it.

## Prerequisites

- **Linux/WSL** (Ubuntu 20.04+ recommended)
- **Node.js** (version 18+)
- **Git**

## Quick Install

Copy and paste this command to download and install:

```bash
curl -sSL https://raw.githubusercontent.com/OLO-Robotics/olo-appliance-release/main/install.sh | bash
```

The installer will:
- Create a clean directory at `~/olo-appliance`
- Download and install all dependencies
- Provide instructions to start the appliance

## What the setup does

- Installs Node.js dependencies
- Configures ROSbridge connection (uses localhost:9090 by default)
- Sets up environment variables
- Starts the appliance in production mode

## Setup Options

### `--defaults` flag
- Uses default configuration without prompting
- Automatically configures ROSbridge for localhost:9090
- Skips interactive questions for faster setup

### Production mode (`--dist`)
- Runs the release version of the code
- Connects to production ROSbridge and services
- Recommended for end users

### Development mode (without `--dist`)
- Runs the source code directly
- Connects to local development services
- Only used if you have the full source code for development

## Troubleshooting

- **Permission denied**: Make sure `setup.sh` is executable: `chmod +x setup.sh`
- **Node.js not found**: Install Node.js: `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs`
- **ROSbridge issues**: The setup will guide you through ROSbridge configuration

## Support

For issues or questions, please refer to the main OLO Robotics documentation. 