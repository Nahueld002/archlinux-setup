#!/usr/bin/env bash

set -u

# === Tema de Rofi (tu ruta solicitada) ===
THEME="$HOME/.config/rofi/menu/bluetooth-menu.rasi"

# === Constantes de UI ===
divider="---------"
goback="Back"

# --- Funciones de estado del controlador ---
power_on() {
    bluetoothctl show | grep -q "Powered: yes"
}

toggle_power() {
    if power_on; then
        bluetoothctl power off
        show_menu
    else
        if rfkill list bluetooth | grep -q 'blocked: yes'; then
            rfkill unblock bluetooth && sleep 3
        fi
        bluetoothctl power on
        show_menu
    fi
}

scan_on() {
    if bluetoothctl show | grep -q "Discovering: yes"; then
        echo "Scan: on"; return 0
    else
        echo "Scan: off"; return 1
    fi
}

toggle_scan() {
    if scan_on; then
        pkill -f "bluetoothctl scan on" 2>/dev/null || true
        bluetoothctl scan off
        show_menu
    else
        bluetoothctl scan on & disown
        echo "Scanning..."
        sleep 5
        show_menu
    fi
}

pairable_on() {
    if bluetoothctl show | grep -q "Pairable: yes"; then
        echo "Pairable: on"; return 0
    else
        echo "Pairable: off"; return 1
    fi
}

toggle_pairable() {
    if pairable_on; then
        bluetoothctl pairable off
    else
        bluetoothctl pairable on
    fi
    show_menu
}

discoverable_on() {
    if bluetoothctl show | grep -q "Discoverable: yes"; then
        echo "Discoverable: on"; return 0
    else
        echo "Discoverable: off"; return 1
    fi
}

toggle_discoverable() {
    if discoverable_on; then
        bluetoothctl discoverable off
    else
        bluetoothctl discoverable on
    fi
    show_menu
}

# --- Funciones por dispositivo ---
device_connected() {
    bluetoothctl info "$1" | grep -q "Connected: yes"
}

toggle_connection() {
    if device_connected "$1"; then
        bluetoothctl disconnect "$1"
    else
        bluetoothctl connect "$1"
    fi
    device_menu "$device"
}

device_paired() {
    if bluetoothctl info "$1" | grep -q "Paired: yes"; then
        echo "Paired: yes"; return 0
    else
        echo "Paired: no"; return 1
    fi
}

toggle_paired() {
    if device_paired "$1"; then
        bluetoothctl remove "$1"
    else
        bluetoothctl pair "$1"
    fi
    device_menu "$device"
}

device_trusted() {
    if bluetoothctl info "$1" | grep -q "Trusted: yes"; then
        echo "Trusted: yes"; return 0
    else
        echo "Trusted: no"; return 1
    fi
}

toggle_trust() {
    if device_trusted "$1"; then
        bluetoothctl untrust "$1"
    else
        bluetoothctl trust "$1"
    fi
    device_menu "$device"
}

# --- Salida breve para barras (polybar/waybar custom) ---
print_status() {
    if power_on; then
        printf ''
        paired_cmd="devices Paired"
        if (( $(echo "$(bluetoothctl version | cut -d ' ' -f 2) < 5.65" | bc -l) )); then
            paired_cmd="paired-devices"
        fi
        mapfile -t paired_devices < <(bluetoothctl $paired_cmd | grep Device | cut -d ' ' -f 2)
        counter=0
        for dev in "${paired_devices[@]}"; do
            if device_connected "$dev"; then
                alias=$(bluetoothctl info "$dev" | grep "Alias" | cut -d ' ' -f 2-)
                if [ $counter -gt 0 ]; then
                    printf ", %s" "$alias"
                else
                    printf " %s" "$alias"
                fi
                ((counter++))
            fi
        done
        printf "\n"
    else
        echo ""
    fi
}

# --- Submenú de dispositivo ---
device_menu() {
    device=$1
    device_name=$(echo "$device" | cut -d ' ' -f 3-)
    mac=$(echo "$device" | cut -d ' ' -f 2)

    if device_connected "$mac"; then connected="Connected: yes"; else connected="Connected: no"; fi
    paired=$(device_paired "$mac")
    trusted=$(device_trusted "$mac")

    options="$connected\n$paired\n$trusted\n$divider\n$goback\nExit"
    chosen="$(echo -e "$options" | rofi -dmenu "$@" -theme "$THEME" -p "$device_name")"

    case "$chosen" in
        "" | "$divider") ;;
        "$connected")    toggle_connection "$mac" ;;
        "$paired")       toggle_paired "$mac"     ;;
        "$trusted")      toggle_trust "$mac"      ;;
        "$goback")       show_menu                ;;
    esac
}

# --- Menú principal ---
show_menu() {
    if power_on; then
        power="Power: on"
        devices=$(bluetoothctl devices | grep Device | cut -d ' ' -f 3-)
        scan=$(scan_on)
        pairable=$(pairable_on)
        discoverable=$(discoverable_on)
        options="$devices\n$divider\n$power\n$scan\n$pairable\n$discoverable\nExit"
    else
        power="Power: off"
        options="$power\nExit"
    fi

    chosen="$(echo -e "$options" | rofi -dmenu "$@" -theme "$THEME" -p "󰂯")"

    case "$chosen" in
        "" | "$divider") ;;
        "$power")        toggle_power ;;
        "$scan")         toggle_scan ;;
        "$discoverable") toggle_discoverable ;;
        "$pairable")     toggle_pairable ;;
        *)
            device=$(bluetoothctl devices | grep -F "$chosen")
            if [[ -n ${device:-} ]]; then device_menu "$device"; fi
            ;;
    esac
}

# --- Punto de entrada ---
case "${1:-}" in
    --status) print_status ;;
    *)        show_menu "$@" ;;
esac
