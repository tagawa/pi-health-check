#!/bin/bash
# picheck.sh - Quick health check for Raspberry Pi
# Designed for Raspbian Stretch (2017) and newer.
# https://github.com/tagawa/pi-health-check

echo "=== Pi Health Check ==="
echo

# Hardware model from device tree (null bytes stripped)
echo "Model:          $(tr -d '\0' < /proc/device-tree/model)"

# GPU/SoC temperature via VideoCore command
echo "Temperature:    $(vcgencmd measure_temp 2>/dev/null | cut -d= -f2 || echo "N/A")"

# Throttling status: 0x0 = healthy, anything else = voltage/temp issues
THROTTLE=$(vcgencmd get_throttled 2>/dev/null | cut -d= -f2)
[ "$THROTTLE" = "0x0" ] && THROTTLE="None" || THROTTLE="WARNING: $THROTTLE"
if [ "$THROTTLE" != "None" ]; then
    T=$((THROTTLE))
    [ $((T & 1)) -ne 0 ] && echo "  ⚠ Under-voltage now (low voltage from power supply)"
    [ $((T & 2)) -ne 0 ] && echo "  ⚠ Freq capped now (CPU speed reduced due to low voltage or overheating)"
    [ $((T & 4)) -ne 0 ] && echo "  ⚠ Throttled now (CPU overheating)"
    [ $((T & 0x10000)) -ne 0 ] && echo "  • Under-voltage occurred (low voltage detected since boot)"
    [ $((T & 0x20000)) -ne 0 ] && echo "  • Freq capped occurred (CPU was slowed down since boot due to low voltage or overheating)"
    [ $((T & 0x40000)) -ne 0 ] && echo "  • Throttled occurred (CPU overheated since boot)"
fi
echo "Throttling:     $THROTTLE"

# System uptime in human-readable format
echo "Uptime:         $(uptime -p)"

# Load averages: 1min, 5min, 15min
echo "Load avg:       $(awk '{print $1, $2, $3}' /proc/loadavg) (1min, 5min, 15min)"

# Memory and swap usage (used / total)
echo "Memory:         $(free -h | awk '/Mem:/ {print $3 " / " $2}')"
echo "Swap:           $(free -h | awk '/Swap:/ {print $3 " / " $2}')"

# Root filesystem usage
echo "Disk:           $(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')"

# List any failed systemd services
FAILED=$(systemctl --failed --no-pager --no-legend)
if [ -z "$FAILED" ]; then
    echo "Failed:         None"
else
    echo "Failed:"
    echo "$FAILED" | sed 's/^/  /'  # Indent failed services
fi

# Last boot time in ISO format (YYYY-MM-DD HH:MM)
echo "Last reboot:    $(uptime -s | cut -d: -f1,2)"
echo
