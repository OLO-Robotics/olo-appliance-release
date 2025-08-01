# OLO Appliance - Quick Install

This is the obfuscated release of the OLO Appliance. Follow these simple steps to install and run it.

## Prerequisites

- **Linux/WSL** (Ubuntu 20.04+ recommended)
- **Node.js** (version 18+)
- **Git**

## Quick Install

Copy and paste this command to download and install:

```bash
curl -sSL https://raw.githubusercontent.com/OLO-Robotics/olo-appliance-release/main/install.sh | bash
```

## Manual Install

If you prefer to install manually:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/OLO-Robotics/olo-appliance-release.git
   cd olo-appliance-release
   ```

2. **Run the setup script**:
   ```bash
   chmod +x setup.sh
   ./setup.sh --defaults
   ```

3. **Start the appliance**:
   ```bash
   ./setup.sh --dist
   ```

## What the setup does

- Installs Node.js dependencies
- Configures ROSbridge connection
- Sets up environment variables
- Starts the appliance in production mode

## Troubleshooting

- **Permission denied**: Make sure `setup.sh` is executable: `chmod +x setup.sh`
- **Node.js not found**: Install Node.js: `curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs`
- **ROSbridge issues**: The setup will guide you through ROSbridge configuration

## Support

For issues or questions, please refer to the main OLO Robotics documentation. 