#!/usr/bin/env bash
# ~/.config/sway/scripts/brightness.sh
# Accepts:
#   +4    -> increase 4%
#   -4    -> decrease 4%
#   +4%   -> increase 4%
#   4%    -> set to 4%
#   50    -> set to 50% (interpreted as percent)
#   4%-   -> decrease 4% (already brightnessctl form)
#
# Usage examples:
#   brightness.sh +4
#   brightness.sh -4
#   brightness.sh 50

set -euo pipefail

usage() {
  cat <<EOF >&2
Usage: $0 [+|-]N[%]
Examples:
  $0 +4    (increase by 4%)
  $0 -4    (decrease by 4%)
  $0 50    (set to 50%)
EOF
  exit 2
}

if [ $# -lt 1 ]; then
  usage
fi

arg="$1"

# Normalize to brightnessctl-friendly value
# We'll always prefer percent values (explicit)
if [[ "$arg" =~ ^\+([0-9]+)%?$ ]]; then
  value="+${BASH_REMATCH[1]}%"
elif [[ "$arg" =~ ^-([0-9]+)%?$ ]]; then
  # brightnessctl expects decrease as "N-%" or "N%-", use percentage-decrease "N%-"
  value="${BASH_REMATCH[1]}%-"
elif [[ "$arg" =~ ^([0-9]+)%$ ]]; then
  value="${BASH_REMATCH[1]}%"
elif [[ "$arg" =~ ^([0-9]+)$ ]]; then
  # treat a bare number as percentage
  value="${BASH_REMATCH[1]}%"
elif [[ "$arg" =~ ^([0-9]+)%-$ ]]; then
  # already in form "N%-"
  value="${BASH_REMATCH[1]}%-"
elif [[ "$arg" =~ ^\+([0-9]+)%-$ ]]; then
  # weird but accept it
  value="+${BASH_REMATCH[1]}%"
else
  echo "Unrecognized argument: $arg" >&2
  usage
fi

# Apply change via brightnessctl
if ! command -v brightnessctl >/dev/null 2>&1; then
  echo "brightnessctl not found. Install brightnessctl or use another method." >&2
  exit 1
fi

if ! brightnessctl set "$value"; then
  echo "brightnessctl failed to set brightness with value: $value" >&2
  exit 1
fi

# Read current brightness percent
cur=$(brightnessctl get 2>/dev/null || echo "")
max=$(brightnessctl max 2>/dev/null || echo "")

if [ -n "$cur" ] && [ -n "$max" ] && [ "$max" -ne 0 ]; then
  percent=$((cur * 100 / max))
else
  # fallback: try brightnessctl g (get) and parse percent if available
  percent=$(brightnessctl g 2>/dev/null || echo "")
  # If still empty, set to 0
  percent=${percent:-0}
fi

# send/update a replaceable notification (many OSDs respect replace-id)
notify-send -u low -h int:value:"$percent" -h string:x-canonical-private-synchronous:brightness "Brightness: ${percent}%"

exit 0
