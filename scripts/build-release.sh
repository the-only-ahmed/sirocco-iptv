#!/usr/bin/env bash
#
# Builds the zip you sideload before signing: same sources, but with DEBUG off so Log.info calls are
# stripped and the player stops appending raw errorStr detail to its dialogs.
#
# The manifest is edited in place and restored on exit (including on failure), so the working tree is
# never left with DEBUG off by accident.
set -euo pipefail

cd "$(dirname "$0")/.."
MANIFEST="src/manifest"
BACKUP="$(mktemp)"

cp "$MANIFEST" "$BACKUP"
trap 'cp "$BACKUP" "$MANIFEST"; rm -f "$BACKUP"' EXIT

if ! grep -q '^bs_const=DEBUG=true$' "$MANIFEST"; then
    echo "warning: bs_const=DEBUG=true not found in $MANIFEST - is DEBUG already off?" >&2
fi
sed -i '' 's/^bs_const=DEBUG=true$/bs_const=DEBUG=false/' "$MANIFEST"

# --sourceMap false: no .map files in something you sign and ship.
if [ "${1:-}" = "--deploy" ]; then
    if [ -z "${ROKU_HOST:-}" ] || [ -z "${ROKU_PASSWORD:-}" ]; then
        echo "error: ROKU_HOST / ROKU_PASSWORD not set. Run:  source .env && npm run deploy:release" >&2
        exit 1
    fi
    npx bsc --sourceMap false --deploy --host "$ROKU_HOST" --password "$ROKU_PASSWORD"
else
    npx bsc --sourceMap false
fi

echo
if [ "${1:-}" = "--deploy" ]; then
    echo "Release build sideloaded to $ROKU_HOST (DEBUG off)."
    echo "Next: package it at http://$ROKU_HOST/plugin_package"
else
    echo "Release build ready: build/sirocco-iptv.zip (DEBUG off)"
    echo "Next: sideload it with  source .env && npm run deploy:release"
fi
