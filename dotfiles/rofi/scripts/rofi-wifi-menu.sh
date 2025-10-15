#!/usr/bin/env bash
# Menú Wi-Fi para rofi (Hyprland/Arch) usando NetworkManager.
# - Reescanear / Desconectar sin apagar la radio
# - Dedupe por SSID (no por línea) + iconos (candado/abierto)
# - SIN pedir contraseña en rofi: delega en nm-applet/polkit (GUI del sistema)
# - Conexiones guardadas
# - 🗑  Olvidar red… (elimina perfil para volver a pedir clave)
# - Tema: $HOME/.config/rofi/themes/wifi-menu.rasi

set -Eeuo pipefail

# ===== Rofi (tu tema) =====
THEME="$HOME/.config/rofi//menu/wifi-menu.rasi"
if [[ -f "$THEME" ]]; then
  ROFI_CMD=(rofi -no-config -dmenu -i -theme "$THEME")
else
  ROFI_CMD=(rofi -dmenu -i)
fi

# ===== Utilidades =====
have_nm_applet() { pgrep -x nm-applet >/dev/null 2>&1; }

# Quita icono/prefijos y espacios
extract_ssid() {
  sed -e 's/^[^ ]\+ *//' -e 's/^Desconectar: *//' <<< "$1" | xargs
}

wifi_if() {
  LANG=C nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi"{print $1; exit}'
}

# Lista principal (dedupe por SSID, omite activa y ssid vacío)
build_menu() {
  nmcli device wifi rescan >/dev/null 2>&1 || true

  # Estado del dispositivo Wi-Fi y SSID realmente asociado
  local wifi_dev active_ssid
  wifi_dev="$(LANG=C nmcli -t -f DEVICE,TYPE,STATE device | awk -F: '$2=="wifi" && $3=="connected"{print $1; exit}')"
  # SSID activo solo si hay asociación a un AP (ACTIVE=yes). Si el AP se apaga, no aparece.
  active_ssid="$(LANG=C nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2; exit}')"

  # Acciones
  printf '🔃  Reescanear\n'
  if [[ -n "$wifi_dev" && -n "$active_ssid" ]]; then
    printf '⏏  Desconectar: %s\n' "$active_ssid"
  fi
  printf '💾  Conexiones guardadas\n'
  printf '🗑  Olvidar red…\n'

  # Redes visibles (dedupe por SSID; omite activa y SSID vacío/oculto)
  LANG=C nmcli -t -f IN-USE,SSID,SECURITY device wifi list \
  | awk -F: '
      {
        inuse=$1; ssid=$2; sec=$3;
        if (ssid=="" || ssid=="--") next;
        if (inuse=="*") next;
        if (seen[ssid]++) next;
        icon = (sec ~ /WPA|WEP|SAE/ ? "" : "");
        print icon " " ssid;
      }
    '
}


# Para un SSID dado, muestra APs concretos (BSSID) y devuelve la línea elegida
list_bssids_for_ssid() {
  local target_ssid="$1"
  LANG=C nmcli -t -f BSSID,SSID,SECURITY,SIGNAL,FREQ,CHAN device wifi list \
  | awk -F: -v ssid="$target_ssid" '
      $2==ssid && $1!="" {
        icon = ($3 ~ /WPA|WEP|SAE/ ? "" : "");
        freq = ($5>=5000 ? "5" : "2.4");
        printf "%s  %s  ·  %s GHz  ·  ch %s  ·  %s%%  ·  %s  [%s]\n",
               icon, $2, freq, $6, $4, ($3==""?"OPEN":$3), $1
      }
    ' | sort -t'%' -k2,2nr
}

pick_bssid_for_ssid() {
  local target_ssid="$1"
  local list sel
  list="$(list_bssids_for_ssid "$target_ssid")"
  [[ -z "$list" ]] && return 1
  if [[ "$(wc -l <<<"$list")" -eq 1 ]]; then
    printf '%s\n' "$list"
    return 0
  fi
  sel="$(printf '%s\n' "$list" | "${ROFI_CMD[@]}" -p "AP de «$target_ssid»:" || true)"
  [[ -z "$sel" ]] && return 1
  printf '%s\n' "$sel"
}

# Parsers
parse_bssid_from_line() { sed -n 's/.*\[\([0-9A-Fa-f:]\+\)\]$/\1/p'; }

# ===== Notificación =====
notify-send "Wi-Fi" "Obteniendo redes disponibles…"

# ===== Bucle principal =====
while true; do
  selection="$(build_menu | "${ROFI_CMD[@]}" -p 'SSID:' -selected-row 1 || true)"
  [[ -z "$selection" ]] && exit 0

  case "$selection" in
    "🔃  Reescanear")
      continue
      ;;

    "⏏  Desconectar:"*)
      wifi_dev="$(LANG=C nmcli -t -f DEVICE,TYPE,STATE device | awk -F: '$2=="wifi" && $3=="connected"{print $1; exit}')"
      if [[ -n "$wifi_dev" ]]; then
        nmcli device disconnect "$wifi_dev" && notify-send "Wi-Fi" "Desconectado."
      else
        notify-send "Wi-Fi" "No hay conexión activa."
      fi
      continue
      ;;

    "💾  Conexiones guardadas")
      saved="$(LANG=C nmcli -t -f NAME,TYPE connection \
               | awk -F: '$2=="802-11-wireless"{print $1}' \
               | "${ROFI_CMD[@]}" -p 'Perfil:' || true)"
      [[ -z "$saved" ]] && continue
      if LANG=C nmcli connection up id "$saved" | grep -qi "success"; then
        notify-send "Conexión establecida" "«$saved»"
        exit 0
      else
        notify-send "Wi-Fi" "No se pudo conectar a «$saved»."
        continue
      fi
      ;;

    "🗑  Olvidar red…")
      todel="$(LANG=C nmcli -t -f NAME,TYPE connection \
               | awk -F: '$2=="802-11-wireless"{print $1}' \
               | "${ROFI_CMD[@]}" -p 'Olvidar perfil:' || true)"
      [[ -z "$todel" ]] && continue
      if nmcli connection delete id "$todel" >/dev/null 2>&1; then
        notify-send "Wi-Fi" "Olvidada «$todel». Se volverá a pedir contraseña."
      else
        notify-send "Wi-Fi" "No se pudo eliminar «$todel»."
      fi
      continue
      ;;

    *)
      # Red seleccionada del listado
      chosen_id="$(extract_ssid "$selection")"
      [[ -z "$chosen_id" ]] && continue

      # Submenú de APs (BSSID) para ese SSID (opcional si solo hay uno)
      ap_line="$(pick_bssid_for_ssid "$chosen_id" || true)"
      bssid=""
      if [[ -n "$ap_line" ]]; then
        bssid="$(printf '%s' "$ap_line" | parse_bssid_from_line)"
      fi

      iface="$(wifi_if || true)"
      have_nm_applet && agent_note="" || agent_note=" (¿nm-applet/polkit activos?)"

      # Conectar: preferir BSSID; si no, por SSID. SIN password ni prompts en rofi.
      if [[ -n "$bssid" ]]; then
        if LANG=C nmcli --wait 30 device wifi connect "$bssid" ${iface:+ifname "$iface"} | grep -qi "success"; then
          notify-send "Conexión establecida" "«$chosen_id» ($bssid)"
          exit 0
        fi
      fi

      if LANG=C nmcli --wait 30 device wifi connect "$chosen_id" ${iface:+ifname "$iface"} | grep -qi "success"; then
        notify-send "Conexión establecida" "«$chosen_id»"
        exit 0
      else
        notify-send "Wi-Fi" "No se pudo conectar a «$chosen_id».$agent_note"
        continue
      fi
      ;;
  esac
done
