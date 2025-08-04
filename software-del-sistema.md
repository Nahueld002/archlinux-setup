# Software del Sistema

Esta sección cubre las herramientas y servicios esenciales para el sistema en un entorno Hyprland + Wayland, incluyendo audio, brillo, notificaciones y monitoreo.

---

## Instalación de Audio con PipeWire

Hyprland usa **PipeWire** por defecto. Para configurarlo correctamente:

```
sudo pacman -S pipewire wireplumber pipewire-audio pavucontrol
```

- `pipewire`: servidor de audio moderno
- `wireplumber`: session manager
- `pavucontrol`: interfaz gráfica para controlar volumen por aplicación

### Activar servicios de audio

```
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### Verificar funcionamiento

```
pactl info | grep Server
```

---

## Control de Brillo

En laptops, para controlar el brillo:

```
sudo pacman -S brightnessctl
```

Comandos útiles:

```
brightnessctl set 10%+   # Subir brillo
brightnessctl set 10%-   # Bajar brillo
```

Waybar puede integrarlo como módulo de brillo.

---

## Notificaciones con Mako

Instalar el notificador:

```
sudo pacman -S mako
```

Agregalo en tu autostart o en `~/.config/hypr/hyprland.conf`:

```
exec-once = mako
```

---

## Módulos de Waybar: Batería, Reloj, Red, Audio, etc.

Waybar soporta módulos para estos elementos. Asegurate de tener una configuración básica como esta:

`~/.config/waybar/config`

```json
{
  "layer": "top",
  "modules-left": ["battery", "network", "pulseaudio"],
  "modules-center": ["clock"],
  "modules-right": ["tray"]
}
```

📁 `~/.config/waybar/style.css` (estilos personalizados)

```css
* {
  font-family: "JetBrainsMono Nerd Font", monospace;
  font-size: 13px;
  color: #ffffff;
  background: #1e1e2e;
  border-radius: 6px;
  padding: 0 10px;
}
```

---

## Servicios Esenciales

Instalación de paquetes necesarios para que Waybar funcione correctamente:

```
sudo pacman -S networkmanager bluez acpi upower
```

Activación de servicios:

```
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
```

---

## Monitor de recursos con Bottom (btm)

Instalación con yay:

```
yay -S bottom
```

Uso:

```
btm
```
