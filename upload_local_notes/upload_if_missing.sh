#!/data/data/com.termux/files/usr/bin/bash

# === Load environment variables ===
set -a
[ -f .env ] && . .env
set +a

# === Validate required vars ===
: "${NEXTCLOUD_USER:?Missing NEXTCLOUD_USER}"
: "${NEXTCLOUD_PASSWORD:?Missing NEXTCLOUD_PASSWORD}"
: "${NEXTCLOUD_URL:?Missing NEXTCLOUD_URL}"
: "${1:?Missing LOCAL_FILE}"
: "${2:?Missing REMOTE_PATH}"

LOCAL_FILE=$1
REMOTE_PATH=$2

# my Obsidian notes are based in "Notes" directory
REMOTE_URL=$(echo "${NEXTCLOUD_URL}/${NEXTCLOUD_USER}/Notes/${REMOTE_PATH}" | sed 's/ /%20/g')

echo "🔍 Checking if file exists on server... $REMOTE_URL"

HTTP_STATUS=$(curl -u "$NEXTCLOUD_USER:$NEXTCLOUD_PASSWORD" \
  -X PROPFIND \
  -s -o /dev/null -w "%{http_code}" \
  -H "Depth: 0" "$REMOTE_URL")

if [ "$HTTP_STATUS" == "404" ]; then
    echo "⬆️  File not found on server. Uploading..."
    echo "curl -u \"$NEXTCLOUD_USER:PASS_REDACTED\" -T \"$LOCAL_FILE\" \"$REMOTE_URL\""
    #curl -u "$NEXTCLOUD_USER:$NEXTCLOUD_PASSWORD" -T "$LOCAL_FILE" "$REMOTE_URL"
    if [ $? -eq 0 ]; then
        echo "✅ Upload successful."
    else
        echo "❌ Upload failed."
    fi
elif [ "$HTTP_STATUS" == "207" ]; then
    echo "📁 File already exists on server. Skipping upload."
else
    echo "⚠️  Unexpected HTTP status: $HTTP_STATUS"
fi

