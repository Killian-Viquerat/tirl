#!/usr/bin/env bash
set -euo pipefail

HOST="${TIRL_HOST:-http://localhost:8080}"
POLL_INTERVAL="${TIRL_POLL:-2}"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <scene_file> [output.ppm]"
    exit 1
fi

SCENE_FILE="$1"
OUTPUT="${2:-output.ppm}"

if [ ! -f "$SCENE_FILE" ]; then
    echo "Error: file '$SCENE_FILE' not found"
    exit 1
fi

echo "Submitting $SCENE_FILE to $HOST..."
RESPONSE=$(curl -s -X POST "$HOST/submit" --data-binary "@$SCENE_FILE")
JOB_ID=$(echo "$RESPONSE" | grep -oP '"id":\s*\K[0-9]+')

if [ -z "$JOB_ID" ]; then
    echo "Error: failed to submit job. Response: $RESPONSE"
    exit 1
fi

echo "Job submitted: id=$JOB_ID"

while true; do
    STATUS_RESPONSE=$(curl -s "$HOST/$JOB_ID/status")
    STATUS=$(echo "$STATUS_RESPONSE" | grep -oP '"status":\s*"\K[^"]+')
    PROGRESS=$(echo "$STATUS_RESPONSE" | grep -oP '"progress":\s*\K[0-9]+')

    case "$STATUS" in
        done)
            echo -e "\rRendering complete!              "
            break
            ;;
        failed)
            echo -e "\rRendering failed.               "
            exit 1
            ;;
        *)
            printf "\rStatus: %-10s Progress: %s%%" "$STATUS" "${PROGRESS:-0}"
            sleep "$POLL_INTERVAL"
            ;;
    esac
done

echo "Downloading result to $OUTPUT..."
curl -s "$HOST/$JOB_ID/output" -o "$OUTPUT"
echo "Done: $OUTPUT"
