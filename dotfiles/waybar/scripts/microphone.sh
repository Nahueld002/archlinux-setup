#!/usr/bin/env bash
set -Eeuo pipefail

if command -v pamixer >/dev/null 2>&1; then
  if pamixer --default-source --get-mute | grep -q true; then
    echo '{"text": "", "class": "muted", "tooltip": "Micrófono silenciado"}'
  else
    echo '{"text": "", "class": "active", "tooltip": "Micrófono activo"}'
  fi
else
  # Fallback con wpctl (PipeWire)
  if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q MUTED; then
    echo '{"text": "", "class": "muted", "tooltip": "Micrófono silenciado (pctl)"}'
  else
    echo '{"text": "", "class": "active", "tooltip": "Micrófono activo (pctl)"}'
  fi
fi

