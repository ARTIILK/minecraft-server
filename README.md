# Minecraft Crossplay Server - Optimized Configuration

This repository contains the complete configuration for a production-ready Minecraft server with crossplay support (Java + Bedrock via Geyser/Floodgate).

## 🎮 Features

- **Paper Server** (1.21.4) - High-performance Minecraft server
- **Crossplay Support** - Geyser + Floodgate for Bedrock players
- **Version Compatibility** - ViaVersion, ViaBackwards, ViaRewind
- **Optimized Performance** - Custom chunk rendering optimizations
- **Essential Plugins**:
  - EssentialsX
  - LuckPerms
  - CoreProtect
  - Spark (performance profiling)

## 📊 Performance Optimizations

This server includes custom optimizations for crossplay chunk rendering:

| Setting | Value | Benefit |
|---------|-------|---------|
| simulation-distance | 8 | 2.67x more active chunks |
| sync-chunk-writes | false | Eliminated I/O bottleneck |
| chunk-send-rate | 100 | 33% faster chunk delivery |
| chunk-load-rate | 150 | 50% faster chunk loading |
| Geyser compression | 4 | Reduced CPU usage |

See `docs/crossplay-optimization-summary.md` for full details.

## 🚀 Quick Start

### Prerequisites

- Ubuntu 20.04+ (or similar Linux distribution)
- Java 21 (OpenJDK)
- 8GB+ RAM recommended
- Ports: 25565 (TCP), 19132 (UDP)

### Installation

1. **Clone this repository:**
   ```bash
   git clone git@github.com:YOUR_USERNAME/minecraft-server.git
   cd minecraft-server
   ```

2. **Run the setup script:**
   ```bash
   chmod +x setup.sh
   sudo ./setup.sh
   ```

3. **Download Paper JAR:**
   ```bash
   cd /opt/minecraft
   wget https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/232/downloads/paper-1.21.4-232.jar -O paper.jar
   ```

4. **Start the server:**
   ```bash
   sudo systemctl start minecraft
   sudo systemctl enable minecraft
   ```

## 📁 Repository Structure

```
minecraft-server/
├── config/                    # Server configuration files
│   ├── server.properties     # Main server config
│   ├── bukkit.yml           # Bukkit settings
│   ├── spigot.yml           # Spigot settings
│   ├── paper-global.yml     # Paper global config
│   └── paper-world-defaults.yml
├── plugins/                   # Plugin configurations
│   ├── Geyser-Spigot/
│   ├── Essentials/
│   ├── LuckPerms/
│   └── CoreProtect/
├── systemd/                   # Systemd service files
│   └── minecraft.service
├── scripts/                   # Utility scripts
│   ├── start.sh
│   ├── backup.sh
│   └── check-performance.sh
├── docs/                      # Documentation
│   └── crossplay-optimization-summary.md
├── setup.sh                   # Main setup script
└── README.md                  # This file
```

## 🔧 Configuration

### Server Properties

Key settings in `config/server.properties`:
- **Port**: 25565 (Java Edition)
- **Max Players**: 20
- **View Distance**: 16
- **Simulation Distance**: 8 (optimized for crossplay)
- **Gamemode**: Creative

### Geyser (Bedrock Support)

- **Port**: 19132 (UDP)
- **Auth**: Floodgate (no Microsoft account needed for Bedrock)
- **Compression**: Level 4 (optimized)

## 📝 Monitoring & Maintenance

### Check Server Status
```bash
systemctl status minecraft
```

### View Live Logs
```bash
tail -f /opt/minecraft/logs/latest.log
```

### Performance Monitoring
```bash
/opt/minecraft/scripts/check-performance.sh
```

### In-Game Commands
```
/spark tps          # Check server TPS
/spark profiler     # Start performance profiling
```

## 🔒 Security Notes

**Important**: This repository does NOT include:
- World data (too large)
- Player data (privacy)
- Banned/ops lists (security)
- Plugin databases (privacy)
- Server JAR files (licensing)

You'll need to:
1. Download the Paper JAR separately
2. Configure ops/whitelist as needed
3. Set up your own world or import existing worlds

## 🌐 Connecting to the Server

### Java Edition
```
Server Address: YOUR_SERVER_IP:25565
```

### Bedrock Edition
```
Server Address: YOUR_SERVER_IP
Port: 19132
```

## 🛠️ Troubleshooting

### Server won't start
```bash
# Check logs
journalctl -u minecraft -n 50

# Check permissions
sudo chown -R minecraft:minecraft /opt/minecraft

# Verify Java version
java -version  # Should be Java 21
```

### Port already in use
```bash
# Kill existing Java processes
sudo pkill -9 java

# Restart server
sudo systemctl restart minecraft
```

### Low TPS / Lag
```bash
# Run performance check
/opt/minecraft/scripts/check-performance.sh

# In-game profiling
/spark profiler start
```

## 📚 Additional Resources

- [Paper Documentation](https://docs.papermc.io/)
- [Geyser Wiki](https://wiki.geysermc.org/)
- [Optimization Guide](docs/crossplay-optimization-summary.md)

## 📄 License

This configuration is provided as-is for personal and educational use.

## 🤝 Contributing

Feel free to submit issues or pull requests for improvements!

---

**Last Updated**: 2026-02-14  
**Server Version**: Paper 1.21.4-232  
**Optimized For**: Crossplay (Java + Bedrock)
