#!/bin/bash
# HexStrike AI Server Startup Script
# High-stability production mode with Gunicorn + Gevent

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values (can override with environment variables)
PORT=${HEXSTRIKE_PORT:-8888}
HOST=${HEXSTRIKE_HOST:-0.0.0.0}
WORKERS=${HEXSTRIKE_WORKERS:-4}
TIMEOUT=${HEXSTRIKE_TIMEOUT:-300}

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║        HexStrike AI Server - Gunicorn + Gevent               ║"
echo "║              High Stability Production Mode                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Display help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0"
    echo ""
    echo "Environment Variables:"
    echo "  HEXSTRIKE_PORT     - Server port (default: 8888)"
    echo "  HEXSTRIKE_HOST     - Bind host (default: 0.0.0.0)"
    echo "  HEXSTRIKE_WORKERS  - Worker processes (default: 4)"
    echo "  HEXSTRIKE_TIMEOUT  - Request timeout in seconds (default: 300)"
    echo ""
    echo "Examples:"
    echo "  ./start_server.sh                      # Default settings"
    echo "  HEXSTRIKE_WORKERS=8 ./start_server.sh  # 8 workers"
    echo "  HEXSTRIKE_PORT=9000 ./start_server.sh  # Different port"
    echo ""
    exit 0
fi

echo -e "${GREEN}[+] Server Configuration:${NC}"
echo -e "    Host: ${HOST}"
echo -e "    Port: ${PORT}"
echo -e "    Workers: ${WORKERS}"
echo -e "    Timeout: ${TIMEOUT}s"
echo -e "    Worker Class: gevent (async)"
echo -e "    Max Connections: ~1000+"
echo ""
echo -e "${YELLOW}[*] Starting Gunicorn + Gevent...${NC}"
echo ""

# Run Gunicorn directly with gevent worker
exec gunicorn \
    --bind "${HOST}:${PORT}" \
    --workers "${WORKERS}" \
    --worker-class gevent \
    --timeout "${TIMEOUT}" \
    --keepalive 5 \
    --max-requests 1000 \
    --max-requests-jitter 50 \
    --graceful-timeout 30 \
    --access-logfile - \
    --error-logfile - \
    --log-level info \
    hexstrike_server:app
