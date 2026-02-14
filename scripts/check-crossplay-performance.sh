#!/bin/bash
# Minecraft Server Performance Monitor
# Quick script to check if crossplay optimizations are working

echo "==================================="
echo "Minecraft Crossplay Performance Check"
echo "==================================="
echo ""

# Check if server is running
echo "1. Server Status:"
systemctl is-active minecraft && echo "   ✅ Server is RUNNING" || echo "   ❌ Server is STOPPED"
echo ""

# Check current settings
echo "2. Optimized Settings Verification:"
echo ""

# Check simulation distance
SIM_DIST=$(grep "^simulation-distance=" /opt/minecraft/server.properties | cut -d'=' -f2)
if [ "$SIM_DIST" = "8" ]; then
    echo "   ✅ simulation-distance = $SIM_DIST (Optimized)"
else
    echo "   ⚠️  simulation-distance = $SIM_DIST (Should be 8)"
fi

# Check sync chunk writes
SYNC_CHUNKS=$(grep "^sync-chunk-writes=" /opt/minecraft/server.properties | cut -d'=' -f2)
if [ "$SYNC_CHUNKS" = "false" ]; then
    echo "   ✅ sync-chunk-writes = $SYNC_CHUNKS (Optimized)"
else
    echo "   ⚠️  sync-chunk-writes = $SYNC_CHUNKS (Should be false)"
fi

# Check network compression
NET_COMP=$(grep "^network-compression-threshold=" /opt/minecraft/server.properties | cut -d'=' -f2)
if [ "$NET_COMP" = "512" ]; then
    echo "   ✅ network-compression-threshold = $NET_COMP (Optimized)"
else
    echo "   ⚠️  network-compression-threshold = $NET_COMP (Should be 512)"
fi

echo ""
echo "3. Server Resource Usage:"
echo ""

# Get memory usage
MEM_USAGE=$(ps aux | grep "[j]ava.*minecraft" | awk '{print $4}')
if [ ! -z "$MEM_USAGE" ]; then
    echo "   Memory Usage: ${MEM_USAGE}%"
else
    echo "   ⚠️  Cannot determine memory usage (server may be offline)"
fi

# Get CPU usage
CPU_USAGE=$(ps aux | grep "[j]ava.*minecraft" | awk '{print $3}')
if [ ! -z "$CPU_USAGE" ]; then
    echo "   CPU Usage: ${CPU_USAGE}%"
else
    echo "   ⚠️  Cannot determine CPU usage (server may be offline)"
fi

echo ""
echo "4. Geyser Status:"
echo ""

# Check if Geyser is loaded
if grep -q "Started Geyser on UDP port" /opt/minecraft/logs/latest.log 2>/dev/null; then
    GEYSER_PORT=$(grep "Started Geyser on UDP port" /opt/minecraft/logs/latest.log | tail -1 | grep -oP 'port \K[0-9]+')
    echo "   ✅ Geyser is running on UDP port $GEYSER_PORT"
else
    echo "   ⚠️  Geyser status unknown (check logs)"
fi

# Check Geyser compression level
GEYSER_COMP=$(grep "compression-level:" /opt/minecraft/plugins/Geyser-Spigot/config.yml | grep -v "#" | awk '{print $2}')
if [ "$GEYSER_COMP" = "4" ]; then
    echo "   ✅ Geyser compression-level = $GEYSER_COMP (Optimized)"
else
    echo "   ⚠️  Geyser compression-level = $GEYSER_COMP (Should be 4)"
fi

echo ""
echo "5. Recent Errors (last 10 lines):"
echo ""

# Check for errors in logs
ERROR_COUNT=$(grep -c "ERROR" /opt/minecraft/logs/latest.log 2>/dev/null || echo "0")
WARN_COUNT=$(grep -c "WARN" /opt/minecraft/logs/latest.log 2>/dev/null || echo "0")

echo "   Errors: $ERROR_COUNT"
echo "   Warnings: $WARN_COUNT"

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo ""
    echo "   Recent errors:"
    grep "ERROR" /opt/minecraft/logs/latest.log | tail -5 | sed 's/^/   /'
fi

echo ""
echo "==================================="
echo "Performance Monitoring Commands:"
echo "==================================="
echo ""
echo "View live logs:"
echo "  tail -f /opt/minecraft/logs/latest.log"
echo ""
echo "Check TPS (in-game or console):"
echo "  /spark tps"
echo ""
echo "View server console:"
echo "  screen -r minecraft"
echo "  (Press Ctrl+A then D to detach)"
echo ""
echo "Restart server:"
echo "  sudo systemctl restart minecraft"
echo ""
echo "==================================="
