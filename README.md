# Pi Health Check
Get a health check of your Raspberry Pi with this Bash script. It displays hardware model, temperature, throttling status, uptime, load averages, memory usage, disk usage, failed services, and last boot time.

Run manually and/or every time you log in.

## Quick Install

```bash
curl -o ~/picheck.sh https://raw.githubusercontent.com/tagawa/pi-health-check/main/picheck.sh && chmod +x ~/picheck.sh
```

To also run it automatically on login (optional):
```bash
echo -e "\n# Run health check on login\n~/picheck.sh" >> ~/.bashrc
```

## Detailed Install & Usage

1. Copy or download the [`picheck.sh`](https://github.com/tagawa/pi-health-check/blob/main/picheck.sh) script to your Pi's home directory.
3. Make it executable: `chmod +x ~/picheck.sh`
4. Run it manually: `~/picheck.sh`

To make it run every time you log in, add the following lines to your `~/.bashrc` file:

```bash
# Run health check on login
~/picheck.sh
echo "Run health check manually with ~/picheck.sh"
```

## Sample Output

```
=== Pi Health Check ===

Model:          Raspberry Pi 4 Model B Rev 1.5
Temperature:    33.6'C
Throttling:     None
Uptime:         up 18 hours, 31 minutes
Load avg:       0.75 0.67 0.65 (1min, 5min, 15min)
Memory:         333Mi / 7.6Gi
Swap:           0B / 2.0Gi
Disk:           4.8G / 59G (9%)
Failed:         None
Last reboot:    2026-01-15 17:28
```
