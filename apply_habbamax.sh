#!/bin/bash
# apply-habamax.sh - Automatically apply Habamax colors to GNOME Terminal

set -euo pipefail

# --- Color definitions (Hex -> RGB) ---
# Foreground and Background
FG="rgb(188,188,188)"   # #bcbcbc
BG="rgb(28,28,28)"      # #1c1c1c

# 16-color palette array (in order: color0..color15)
PALETTE=(
    "rgb(28,28,28)"     # 0 Black
    "rgb(175,95,95)"    # 1 Red
    "rgb(95,175,95)"    # 2 Green
    "rgb(175,135,95)"   # 3 Yellow
    "rgb(95,135,175)"   # 4 Blue
    "rgb(175,135,175)"  # 5 Magenta
    "rgb(95,135,135)"   # 6 Cyan
    "rgb(158,158,158)"  # 7 White
    "rgb(118,118,118)"  # 8 Bright Black
    "rgb(215,95,135)"   # 9 Bright Red
    "rgb(135,215,135)"  # 10 Bright Green
    "rgb(215,175,135)"  # 11 Bright Yellow
    "rgb(95,175,215)"   # 12 Bright Blue
    "rgb(215,135,215)"  # 13 Bright Magenta
    "rgb(135,175,175)"  # 14 Bright Cyan
    "rgb(188,188,188)"  # 15 Bright White
)

# --- Find the default profile ID ---
echo "🔍 Detecting default GNOME Terminal profile..."

# Get list of all profile UUIDs (removing trailing slash)
PROFILE_IDS=$(dconf list /org/gnome/terminal/legacy/profiles:/ | grep '^:' | sed 's|/||g')

if [ -z "$PROFILE_IDS" ]; then
    echo "❌ No GNOME Terminal profiles found!"
    exit 1
fi

# If only one profile exists, use it.
if [ "$(echo "$PROFILE_IDS" | wc -w)" -eq 1 ]; then
    PROFILE_ID=$(echo "$PROFILE_IDS" | head -n1)
    echo "✅ Found single profile: $PROFILE_ID"
else
    # Find the profile with the 'default' flag (the one that opens by default)
    DEFAULT_ID=""
    for ID in $PROFILE_IDS; do
        # The 'default' key is at: /org/gnome/terminal/legacy/profiles:/default
        # But the value points to a UUID (e.g., 'b1dcc9dd-...')
        DEFAULT_UUID=$(dconf read /org/gnome/terminal/legacy/profiles:/default 2>/dev/null | tr -d "'")
        if [ "$DEFAULT_UUID" == "${ID#:}" ]; then
            DEFAULT_ID="$ID"
            break
        fi
    done

    if [ -n "$DEFAULT_ID" ]; then
        PROFILE_ID="$DEFAULT_ID"
        echo "✅ Found default profile: $PROFILE_ID"
    else
        # Fallback: use the first one
        PROFILE_ID=$(echo "$PROFILE_IDS" | head -n1)
        echo "⚠️ Could not determine default profile; using first available: $PROFILE_ID"
    fi
fi

# --- Apply the settings ---
BASE_PATH="/org/gnome/terminal/legacy/profiles:/$PROFILE_ID/"

echo "🎨 Applying Habamax color palette..."
dconf write "${BASE_PATH}foreground-color" "'$FG'"
dconf write "${BASE_PATH}background-color" "'$BG'"
dconf write "${BASE_PATH}palette" "$(printf "['%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s']" "${PALETTE[@]}")"

echo "✅ Done! Please open a new terminal window to see the changes."