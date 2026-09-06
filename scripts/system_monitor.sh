#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$BASE_DIR/config/monitor.conf"
LOG="$BASE_DIR/logs/monitor.log"

if [ -f "$CONFIG" ]; then
    source "$CONFIG"
fi

CPU_THRESHOLD="${CPU_THRESHOLD:-80}"
MEMORY_THRESHOLD="${MEMORY_THRESHOLD:-80}"
DISK_THRESHOLD="${DISK_THRESHOLD:-80}"

mkdir -p "$BASE_DIR/logs"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

CPU=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)

MEMORY=$(free | awk '/Mem:/ {
    printf "%.0f", ($3/$2)*100
}')

DISK=$(df -P / | awk 'NR==2 {
    gsub("%","",$5);
    print $5
}')

log "===== System Monitoring ====="

log "CPU Usage: ${CPU}%"
log "Memory Usage: ${MEMORY}%"
log "Disk Usage: ${DISK}%"

if [ "${CPU:-0}" -ge "$CPU_THRESHOLD" ]; then
    log "ALERT: CPU usage is above ${CPU_THRESHOLD}%"
fi

if [ "${MEMORY:-0}" -ge "$MEMORY_THRESHOLD" ]; then
    log "ALERT: Memory usage is above ${MEMORY_THRESHOLD}%"
fi

if [ "${DISK:-0}" -ge "$DISK_THRESHOLD" ]; then
    log "ALERT: Disk usage is above ${DISK_THRESHOLD}%"
fi

log "Top Processes:"

ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6 | tee -a "$LOG"

log "============================="
