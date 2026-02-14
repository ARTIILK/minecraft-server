#!/bin/bash
# Minecraft Server Setup Script
# This script sets up a production-ready Minecraft server with crossplay support

set -e  # Exit on error

echo "=========================================="
echo "Minecraft Crossplay Server Setup"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

echo "📦 Installing dependencies..."
apt-get update
apt-get install -y openjdk-21-jre-headless screen wget curl git nodejs npm

echo ""
echo "👤 Creating minecraft user..."
if ! id -u minecraft > /dev/null 2>&1; then
    useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft
    echo "✅ Created minecraft user"
else
    echo "✅ Minecraft user already exists"
fi

echo ""
echo "📁 Creating directory structure..."
mkdir -p /opt/minecraft/{plugins,config,scripts,logs}
chown -R minecraft:minecraft /opt/minecraft

echo ""
echo "📋 Copying configuration files..."
cp -r config/* /opt/minecraft/
cp -r plugins/* /opt/minecraft/plugins/
cp -r scripts/* /opt/minecraft/scripts/
cp systemd/minecraft.service /etc/systemd/system/

echo ""
echo "🔧 Setting permissions..."
chmod +x /opt/minecraft/scripts/*.sh
chown -R minecraft:minecraft /opt/minecraft

echo ""
echo "📥 Downloading Paper JAR..."
cd /opt/minecraft
if [ ! -f "paper.jar" ]; then
    echo "Downloading Paper 1.21.4-232..."
    sudo -u minecraft wget -q https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/232/downloads/paper-1.21.4-232.jar -O paper.jar
    echo "✅ Downloaded Paper JAR"
else
    echo "✅ Paper JAR already exists"
fi

echo ""
echo "📝 Creating EULA acceptance..."
echo "eula=true" | sudo -u minecraft tee /opt/minecraft/eula.txt > /dev/null

echo ""
echo "🚀 Setting up MCSManager..."
if [ ! -d "/opt/mcsmanager" ]; then
    mkdir -p /opt/mcsmanager
    cd /opt/mcsmanager
    
    # Download and extract MCSManager
    wget https://github.com/MCSManager/MCSManager/releases/latest/download/mcsmanager_linux_release.tar.gz
    tar -xzf mcsmanager_linux_release.tar.gz
    rm mcsmanager_linux_release.tar.gz
    
    echo "✅ Installed MCSManager"
else
    echo "✅ MCSManager already exists"
fi

echo ""
echo "📋 Restoring MCSManager data..."
mkdir -p /opt/mcsmanager/daemon/data /opt/mcsmanager/web/data
cp -r mcsmanager/daemon/data/* /opt/mcsmanager/daemon/data/ 2>/dev/null || true
cp -r mcsmanager/web/data/* /opt/mcsmanager/web/data/ 2>/dev/null || true
cp systemd/mcsm/*.service /etc/systemd/system/
echo "✅ Restored MCSManager data"

echo ""
echo "🔄 Reloading systemd..."
systemctl daemon-reload

echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review configuration in /opt/minecraft/"
echo "2. Start the server: sudo systemctl start minecraft"
echo "3. Enable auto-start: sudo systemctl enable minecraft"
echo "4. Check status: sudo systemctl status minecraft"
echo "5. View logs: tail -f /opt/minecraft/logs/latest.log"
echo ""
echo "Server Ports:"
echo "  - Java Edition: 25565 (TCP)"
echo "  - Bedrock Edition: 19132 (UDP)"
echo ""
echo "⚠️  Don't forget to configure your firewall!"
echo "=========================================="
