#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$BASE_DIR/config/monitor.conf"
LOG="$BASE_DIR/logs/monitor.log"

if [ -f "$CONFIG" ]; then
    source "$CONFIG"
fi

SERVICES="${SERVICES:-apache2 mysql ssh}"

mkdir -p "$BASE_DIR/logs"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ===== Service Check =====" | tee -a "$LOG"

for service in $SERVICES
do
    if systemctl is-active --quiet "$service"
    then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] OK: $service is running" | tee -a "$LOG"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERT: $service is NOT running" | tee -a "$LOG"
    fi
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] =========================" | tee -a "$LOG"o
