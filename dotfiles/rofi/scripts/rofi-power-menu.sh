#!/usr/bin/env bash
set -Eeuo pipefail

# Tema dedicado
THEME="$HOME/.config/rofi/menu/power-menu.rasi"
CONFIRM_THEME="$HOME/.config/rofi/menu/confirm.rasi"

# Opciones (icono + etiqueta)
OPT_LOCK="󰌾  Bloquear"
OPT_SUSPEND="󰒲  Suspender"
OPT_LOGOUT="󰍃  Cerrar sesión"
OPT_REBOOT="  Reiniciar"
OPT_SHUTDOWN="  Apagar"

YES="  Sí"
NO="  No"

# Lanza rofi con el tema
rofi_menu() {
  rofi -dmenu -i -no-custom -theme "$THEME"
}

# Confirmación (pequeña, 2 columnas)
confirm_menu() {
  rofi -dmenu -i -no-custom -p '¿Confirmar?' -theme "$CONFIRM_THEME"
}

confirm() {
  printf '%s\n%s\n' "$YES" "$NO" | confirm_menu
}

# Ejecuta acción con confirmación (excepto bloquear)
run_action() {
  local action="$1"

  case "$action" in
    "$OPT_LOCK")
      # Usa hyprlock si existe; si no, intenta swaylock
      if command -v hyprlock >/dev/null 2>&1; then
        hyprlock
      elif command -v swaylock >/dev/null 2>&1; then
        swaylock
      fi
      ;;
    "$OPT_SUSPEND")
      sel="$(confirm)"; [[ "$sel" == "$YES" ]] || exit 0

      # Pausar multimedia de forma genérica (MPRIS)
      command -v playerctl >/dev/null 2>&1 && playerctl --all-players pause || true

      # Silenciar por PipeWire (usa primero pactl, si no wpctl)
      if command -v pactl >/dev/null 2>&1; then
        pactl set-sink-mute @DEFAULT_SINK@ 1 >/dev/null 2>&1 || true
      elif command -v wpctl >/dev/null 2>&1; then
        # Mutea el default sink
        SINK_ID="$(wpctl status | awk '/Sinks:/{flag=1;next}/Sources:/{flag=0}flag && /\*/{print $2; exit}')" || true
        [ -n "${SINK_ID:-}" ] && wpctl set-mute "$SINK_ID" 1 >/dev/null 2>&1 || true
      fi

      # Suspensión a RAM y, tras un tiempo, hibernación automática (configurable en /etc/systemd/sleep.conf con HibernateDelaySec=)
      systemctl suspend-then-hibernate
      # Alternativa: suspensión híbrida.
      # Recomendación: para systemctl hybrid-sleep, asegúrate de que el swap tenga al menos la misma capacidad que la RAM.
      ;;
    "$OPT_LOGOUT")
      sel="$(confirm)"; [[ "$sel" == "$YES" ]] || exit 0
      if command -v hyprctl >/dev/null 2>&1; then
        hyprctl dispatch exit
      else
        # Respaldo genérico si faltara hyprctl
        loginctl terminate-user "$USER"
      fi
      ;;
    "$OPT_REBOOT")
      sel="$(confirm)"; [[ "$sel" == "$YES" ]] || exit 0
      systemctl reboot
      ;;
    "$OPT_SHUTDOWN")
      sel="$(confirm)"; [[ "$sel" == "$YES" ]] || exit 0
      systemctl poweroff
      ;;
  esac
}

main() {
  selection="$(printf '%s\n' \
    "$OPT_LOCK" "$OPT_SUSPEND" "$OPT_LOGOUT" "$OPT_REBOOT" "$OPT_SHUTDOWN" \
    | rofi_menu || true)"

  [[ -z "${selection:-}" ]] && exit 0
  run_action "$selection"
}
main
