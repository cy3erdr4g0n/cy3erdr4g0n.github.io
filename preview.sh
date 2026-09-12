#!/usr/bin/env bash
# Quick helper to run Jekyll Chirpy locally with Docker

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="chirpy-blog"

case "$1" in
  stop)
    echo "[+] Stopping preview container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
    echo "[+] Stopped."
    ;;
  logs)
    docker logs -f "$CONTAINER_NAME"
    ;;
  *)
    # Check if already running
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
      echo "[+] Blog preview is already running at http://localhost:4000"
      exit 0
    fi

    # Remove stopped container if exists
    docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

    echo "[+] Starting local preview server on http://localhost:4000 ..."
    docker run -d \
      --name "$CONTAINER_NAME" \
      -p 4000:4000 \
      -v "$DIR:/srv/jekyll" \
      chirpy-preview

    echo "[+] Live preview running!"
    echo "    URL:  http://localhost:4000"
    echo "    Logs: ./preview.sh logs"
    echo "    Stop: ./preview.sh stop"
    ;;
esac
