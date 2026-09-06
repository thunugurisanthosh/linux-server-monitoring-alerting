#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$BASE_DIR/config/monitor.conf"
LOG="$BASE_DIR/logs/monitor.log"

if [ -f "$CONFIG" ]; then
    source "$CONFIG"
fi

PING_TARGET="${PING_TARGET:-8.8.8.8}"

mkdir -p "$BASE_DIR/logs"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ===== Network Check =====" | tee -a "$LOG"

if ping -c 2 -W 2 "$PING_TARGET" >/dev/null 2>&1
then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] OK: Network connectivity to $PING_TARGET" | tee -a "$LOG"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERT: Network connectivity failed to $PING_TARGET" | tee -a "$LOG"
fi

echo "Listening Ports:" | tee -a "$LOG"

ss -tuln | head -10 | tee -a "$LOG"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ==========================" | tee -a "$LOG"

