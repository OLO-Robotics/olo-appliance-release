# OLO Appliance - Quick Install

This is the release version of the OLO Appliance. Follow these simple steps to install and run it.

## Prerequisites

- **Linux/WSL** (Ubuntu 22.04+)
- **ROS2 and its dependencies**
- **Node.js** (version 18+)
- **Git**

## Quick Install

Copy and paste this command in your Ubuntu terminal (or WSL terminal) to download and install:

```bash
curl -sSL https://raw.githubusercontent.com/OLO-Robotics/olo-appliance-release/main/install.sh | bash
```

The installer will:
- Create a clean directory at `~/olo-appliance`
- Download and install all dependencies
- Provide instructions to start the appliance

## To run the Appliance

Copy and paste this command to navigate to the correct directory and start the appliance app:

```bash
cd ~/olo-appliance/olo-appliance-release/app
./setup.sh --defaults --dist
```

Note: You will be prompted for your OLO username and password when starting. To set up a free account visit https://olo-poc-5213c89ae086.herokuapp.com/

- Installs Node.js dependencies
- Configures ROSbridge connection (uses localhost:9090 by default)
- Sets up environment variables
- Starts the appliance in production mode
