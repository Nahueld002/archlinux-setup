#!/bin/bash

# Import Current Theme
RASI="$HOME/.config/rofi/menu/screenshot.rasi"

getTargetDirectory() {
	test -f "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs" &&
		. "${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"

	if [[ ! $XDG_SCREENSHOTS_DIR ]]; then
		XDG_SCREENSHOTS_DIR=$XDG_PICTURES_DIR/Screenshots
		echo "XDG_SCREENSHOTS_DIR=$XDG_SCREENSHOTS_DIR" >>$HOME/.config/user-dirs.dirs
	fi

	echo "${XDG_SCREENSHOTS_DIR:-${XDG_PICTURES_DIR:-$HOME}}"
}

# Theme Elements
prompt='Screenshot'
mesg="Directory :: $(getTargetDirectory)"

# Options
if [[ "$layout" == 'NO' ]]; then
	option_1="󰹑 Capturar Pantalla"
	option_2="󱣴 Capturar Área"
	option_3="󰔝 Capturar en 3s"
	option_4="󰔜 Capturar en 10s"
else
	option_1="󰹑"
	option_2="󱣴"
	option_3="󰔝"
	option_4="󰔜"
fi

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${RASI}
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}


# Screenshot
time=$(date +%Y-%m-%d-%H-%M-%S)

dir=$(getTargetDirectory)
echo $dir
file=${3:-$(getTargetDirectory)/Screenshot\ ${time}.png}
echo $file

# Directory
if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
	notify_cmd_shot='dunstify -t 1200 -u low -h string:x-dunst-stack-tag:obscreenshot -i /usr/share/icons/Dracula/scalable/mimetypes/image-png.svg'
	${notify_cmd_shot} "Copied to clipboard."
	#viewnior "$file" # Este se usa para abrir el visor de imágenes
	if [[ -e "$file" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
	else
		${notify_cmd_shot} "Screenshot Deleted."
	fi
}

# Copy screenshot to clipboard
copy_shot() {
  wl-copy <"$file" & disown
}


# countdown
countdown() {
	for sec in $(seq $1 -1 1); do
		dunstify -t 1000 -h string:x-dunst-stack-tag:screenshottimer -i /usr/share/icons/Dracula/scalable/apps/time.svg "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
shotnow() {
  sleep 0.1
  grim "$file"
  copy_shot
  notify_view
  refocus
}


shot3() {
	countdown '3'
	sleep 0.5 && grim "$file"
	copy_shot <"$file"
	notify_view
	refocus
}

shot10() {
	countdown '10'
	sleep 0.5 grim "$file"
	copy_shot <"$file"
	notify_view
	refocus
}

shotarea() {
  grim -t png -g "$(slurp)" "$file"
  copy_shot
  notify_view
  refocus
}

refocus() {
  hyprctl dispatch focuscurrentorlast >/dev/null 2>&1
}


# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shot3
	elif [[ "$1" == '--opt4' ]]; then
		shot10
	fi
}


if [[ $1 == "1" ]]; then
	run_cmd --opt1
	exit 0
elif [[ $1 == "2" ]]; then
	run_cmd --opt2
	exit 0
else
	# Actions
	chosen="$(run_rofi)"
	case ${chosen} in
	$option_1)
		run_cmd --opt1
		;;
	$option_2)
		run_cmd --opt2
		;;
	$option_3)
		run_cmd --opt3
		;;
	$option_4)
		run_cmd --opt4
		;;
	esac
fi
