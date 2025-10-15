#!/usr/bin/env bash
set -Eeuo pipefail

ICON_CONNECTED="󰂱"    # BT conectado (auriculares)
ICON_ON_NO_CONN=""   # BT encendido sin conexión
ICON_OFF="󰂲"          # BT apagado

json_escape() {
  local s="${1:-}"
  s=${s//\\/\\\\}
  s=${s//\"/\\\"}
  s=${s//$'\n'/ }
  echo -n "$s"
}

# ¿bluetoothctl disponible?
if ! command -v bluetoothctl >/dev/null 2>&1; then
  echo '{"text":"󰂲","tooltip":"bluetoothctl no disponible","class":"error"}'
  exit 0
fi

powered="$(bluetoothctl show 2>/dev/null | awk -F': ' '/Powered:/ {print $2}' || true)"

# 1) Apagado
if [[ "${powered}" != "yes" ]]; then
  echo "{\"text\":\"$ICON_OFF\",\"tooltip\":\"Bluetooth apagado\",\"class\":\"off\"}"
  exit 0
fi

# 2) Encendido: ¿conexión?
CONNECTED_NAMES="$(bluetoothctl devices Connected 2>/dev/null | cut -d ' ' -f3- | paste -sd ', ' - || true)"

if [[ -z "${CONNECTED_NAMES}" ]]; then
  echo "{\"text\":\"$ICON_ON_NO_CONN\",\"tooltip\":\"Bluetooth activo, sin conexión\",\"class\":\"disconnected\"}"
  exit 0
fi

# 3) Conectado
tooltip="Conectado a: ${CONNECTED_NAMES}"
tooltip_esc="$(json_escape "$tooltip")"
echo "{\"text\":\"$ICON_CONNECTED\",\"tooltip\":\"$tooltip_esc\",\"class\":\"connected\"}"
