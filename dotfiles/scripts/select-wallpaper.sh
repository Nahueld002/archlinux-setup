#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Selector de wallpaper + tema (Waybar, Hyprland, Rofi) vía JSON
# Tree actual soportado (styles/, themes/, looks/).
# ============================================================

# --- Registro de temas ---
REG="$HOME/proyectos/dotfiles/registry.json"

# --- Fuentes de wallpapers ---
ASSETS="$HOME/.config/waybar/assets"

# --- Destinos activos en ~/.config (lectores reales) ---
DEST_WAYBAR_CFG="$HOME/.config/waybar/config"
DEST_WAYBAR_CSS="$HOME/.config/waybar/style.css"
DEST_HYPR_LOOK="$HOME/.config/hypr/look.conf"

# --- Rofi (activos) ---
ROFI_DIR="$HOME/.config/rofi"
ROFI_THEMES_DIR="$ROFI_DIR/themes"
ROFI_IMAGES_DIR="$ROFI_DIR/images"
ROFI_THEME_LINK="$ROFI_DIR/theme.rasi"          # symlink que usa rofi
ROFI_HERO_LINK="$ROFI_IMAGES_DIR/default.jpg"   # imagen de cabecera común
ROFI_MENU_THEME="$ROFI_THEME_LINK"              # el menú usa SIEMPRE el tema activo
ROFI_THEMES_SHARED="$HOME/.config/rofi/shared"
ROFI_SHARED_COLORS="$ROFI_THEMES_SHARED/colors.rasi"
ROFI_SHARED_FONTS="$ROFI_THEMES_SHARED/fonts.rasi"

# --- Kitty (activo) ---
DEST_KITTY_DIR="$HOME/.config/kitty"
DEST_KITTY_THEME="$DEST_KITTY_DIR/current-theme.conf"

# --- Fastfetch (activo) ---
DEST_FASTFETCH_ICON_DIR="$HOME/.config/fastfetch/icon"
DEST_FASTFETCH_ICON_LINK="$DEST_FASTFETCH_ICON_DIR/current.png"


# --- Dependencias mínimas ---
for bin in swww rofi jq; do
  command -v "$bin" >/dev/null 2>&1 || { echo "ERROR: falta '$bin' en PATH"; exit 1; }
done

# --- Utilidades ---
expand_path() {  # expande ~ a $HOME
  local p="$1"
  if [[ "$p" == "~/"* ]]; then
    printf "%s" "${p/#\~/$HOME}"
  else
    printf "%s" "$p"
  fi
}

ensure_dirs() {
  mkdir -p "$(dirname "$DEST_WAYBAR_CFG")" "$(dirname "$DEST_HYPR_LOOK")"
  mkdir -p "$ROFI_THEMES_SHARED" "$ROFI_IMAGES_DIR"
  mkdir -p "$DEST_KITTY_DIR"
  mkdir -p "$DEST_FASTFETCH_ICON_DIR"
}

ensure_swww() {
  if ! pgrep -x swww-daemon >/dev/null 2>&1; then
    swww-daemon & disown
    sleep 0.3
  fi
}

# --- Lectura desde registry.json ---
get_profile_for_wall() { # $1 = basename del wallpaper
  local base="$1"
  jq -r --arg k "$base" '.wallpaperToProfile[$k] // "default"' "$REG"
}

get_field() { # $1 = profile, $2 = fieldName -> imprime valor expandido o vacío
  local prof="$1" key="$2" raw
  raw=$(jq -r --arg p "$prof" ".profiles[\$p].$key // \"\"" "$REG")
  [[ -z "$raw" || "$raw" == "null" ]] && { printf "%s" ""; return 0; }
  expand_path "$raw"
}

# --- Aplicación Waybar/Hypr desde JSON (copias a ~/.config) ---
apply_waybar_hypr_from_json() {
  local profile="$1"
  local waybar_cfg waybar_css look_conf

  waybar_cfg="$(get_field "$profile" "waybarConfig")"
  waybar_css="$(get_field "$profile" "waybarStyle")"
  look_conf="$(get_field "$profile" "lookConf")"

  [[ -n "$waybar_css" && -f "$waybar_css" ]] && cp -f "$waybar_css" "$DEST_WAYBAR_CSS"
  [[ -n "$waybar_cfg" && -f "$waybar_cfg" ]] && cp -f "$waybar_cfg" "$DEST_WAYBAR_CFG"
  [[ -n "$look_conf"  && -f "$look_conf"  ]] && cp -f "$look_conf"  "$DEST_HYPR_LOOK"
}

# --- Rofi palette (opcional por perfil) ---
apply_rofi_palette_from_json() {
  local profile="$1"
  local rc rf
  rc="$(get_field "$profile" "rofiColors")"
  rf="$(get_field "$profile" "rofiFonts")"

  mkdir -p "$ROFI_THEMES_SHARED"
  [[ -n "$rc" && -f "$rc" ]] && cp -f "$rc" "$ROFI_SHARED_COLORS"
  [[ -n "$rf" && -f "$rf" ]] && cp -f "$rf" "$ROFI_SHARED_FONTS"
}

# --- Rofi theme + hero ---
apply_rofi_theme_from_json() {
  local profile="$1" hero_src="$2"
  local rofi_theme
  rofi_theme="$(get_field "$profile" "rofiTheme")"

  if [[ -n "$rofi_theme" && -f "$rofi_theme" ]]; then
    ln -sfn "$rofi_theme" "$ROFI_THEME_LINK"
  fi

  apply_rofi_palette_from_json "$profile"

  ln -sfn "$hero_src" "$ROFI_HERO_LINK"
  ln -sfn "$ROFI_HERO_LINK" "$ROFI_IMAGES_DIR/default.jpg" 2>/dev/null || true
}

apply_kitty_from_json() {
  local profile="$1"
  local kitty_theme
  kitty_theme="$(get_field "$profile" "kittyTheme")"

  # Si el perfil define un theme y existe, apuntamos el symlink
  if [[ -n "$kitty_theme" && -f "$kitty_theme" ]]; then
    ln -sfn "$kitty_theme" "$DEST_KITTY_THEME"

    # Recarga “en caliente” si kitty remote control está disponible
    if command -v kitty >/dev/null 2>&1 && kitty @ --help >/dev/null 2>&1; then
      # -a (all windows), -c (config file)
      kitty @ set-colors -a -c "$DEST_KITTY_THEME" >/dev/null 2>&1 || true
    fi
  fi
}

apply_fastfetch_from_json() {
  local profile="$1"
  local ff_icon
  ff_icon="$(get_field "$profile" "fastfetchIcon")"

  if [[ -n "$ff_icon" && -f "$ff_icon" ]]; then
    ln -sfn "$ff_icon" "$DEST_FASTFETCH_ICON_LINK"
  fi
}

# --- Wallpaper ---
set_wallpaper() {
  local img="$1"
  ensure_swww
  local outputs
  outputs="$(swww query 2>/dev/null | awk '/^Output/ {print $2}')"
  if [[ -n "${outputs}" ]]; then
    while read -r out; do
      [[ -n "$out" ]] || continue
      swww img -o "$out" "$img" --transition-type random --transition-fps 60 --transition-duration 0.6 --resize crop
    done <<< "${outputs}"
  else
    swww img "$img" --transition-type random --transition-fps 60 --transition-duration 0.6 --resize crop
  fi
}

# --- Recargas ---
reload_env() {
  pkill waybar 2>/dev/null || true
  nohup waybar >/dev/null 2>&1 & disown
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null 2>&1 || true
  fi
}

# --- Menú y flujo principal ---
build_menu() { for f in "${FILES[@]}"; do basename "$f"; done; }

# Lista de fondos disponibles
mapfile -t FILES < <(find "${ASSETS}" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort)
if [[ ${#FILES[@]} -eq 0 ]]; then
  command -v notify-send >/dev/null 2>&1 && notify-send "Wallpaper" "No se encontraron imágenes en ${ASSETS}"
  exit 0
fi

main() {
  ensure_dirs

  # Menú Rofi con el tema activo
  if [[ -f "$ROFI_MENU_THEME" ]]; then
    ROFI_CMD=(rofi -dmenu -i -no-custom -format i -p " Select Theme (↑/↓) " -theme "$ROFI_MENU_THEME")
  else
    ROFI_CMD=(rofi -dmenu -i -no-custom -format i -p " Select Theme (↑/↓) ")
  fi

  sel_index="$(build_menu | "${ROFI_CMD[@]}")" || sel_index=""
  if [[ -z "${sel_index:-}" || "${sel_index}" == "-1" ]]; then
    echo "Cancelado."
    exit 0
  fi
  if ! [[ "${sel_index}" =~ ^[0-9]+$ ]] || (( sel_index < 0 || sel_index >= ${#FILES[@]} )); then
    command -v notify-send >/dev/null 2>&1 && notify-send "Selector" "Selección inválida."
    exit 1
  fi

  local selected_wallpaper="${FILES[$sel_index]}"
  local base="$(basename "$selected_wallpaper")"

  # 1) Resolver perfil desde registry.json
  local profile
  profile="$(get_profile_for_wall "$base")"
  [[ -z "$profile" || "$profile" == "null" ]] && profile="default"

  # 2) Resolver imagen hero: si existe ~/.config/rofi/images/<basename>.jpg úsala; si no, usa el propio wallpaper
  local hero_candidate="$ROFI_IMAGES_DIR/${base%.*}.jpg"
  local hero_img
  if [[ -f "$hero_candidate" ]]; then
    hero_img="$hero_candidate"
  else
    hero_img="$selected_wallpaper"
  fi

  # 3) Aplicar: Waybar/Hypr (copias a ~/.config), Rofi, Kitty, Fastfetch y Wallpaper
  apply_waybar_hypr_from_json "$profile"
  apply_rofi_theme_from_json  "$profile" "$hero_img"
  apply_kitty_from_json       "$profile"
  apply_fastfetch_from_json   "$profile"
  set_wallpaper               "$selected_wallpaper"

  # 4) Guardar último fondo (opcional)
  mkdir -p "$HOME/.cache/wallpapers"
  printf '%s' "$selected_wallpaper" > "$HOME/.cache/wallpapers/current"

  # 5) Recargar y notificar
  reload_env
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Tema aplicado" "Perfil: ${profile}\nWallpaper: ${base}"
  else
    echo "Tema aplicado | Perfil: ${profile} | Wallpaper: ${base}"
  fi
}

main
