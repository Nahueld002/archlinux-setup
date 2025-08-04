# Configuración de Waybar

Waybar es una barra de estado personalizable para entornos Wayland como Hyprland. A continuación se detalla la configuración básica, estilo y cómo mantenerlo persistente.

**Esta es simplemente una configuración básica de Waybar, ya que solo incluye íconos y colores para que la barra de estado funcione correctamente.**
---

# Archivo de Configuración

## Crear archivo

Abrir el archivo de configuración:

```
nano ~/.config/waybar/config
```

### Contenido recomendado

```
{
  "layer": "top",
  "position": "top",
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["pulseaudio", "battery", "network", "tray"],

  "clock": {
    "format": "%a %d %b %H:%M"
  },
  "battery": {
    "format": "{capacity}% {icon}",
    "format-icons": ["", "", "", "", ""]
  },
  "pulseaudio": {
    "format": "{volume}% {icon}",
    "format-muted": "",
    "format-icons": ["", "", ""]
  },
  "network": {
    "format-wifi": " {essid} ({signalStrength}%)",
    "format-ethernet": " {ipaddr}",
    "format-disconnected": "⚠ Sin red"
  }
}
```

Guardar con `Ctrl + O`, luego `Enter`, y salir con `Ctrl + X`.

---

# Archivo de Estilos (CSS)

## Crear archivo

```
nano ~/.config/waybar/style.css
```

### Contenido de ejemplo

```
* {
  font-family: "JetBrainsMono Nerd Font", monospace;
  font-size: 13px;
  color: #ffffff;
  background: #1e1e2e;
  border-radius: 6px;
  padding: 0 10px;
}

#clock, #battery, #pulseaudio, #network, #tray {
  margin: 0 6px;
}
```

---

# Ejecución de Waybar

Ejecutar en segundo plano:

```
waybar &
```

Si no aparecen errores, la barra debería estar visible en la parte superior del escritorio.

---

# Autostart en Hyprland

Agregar a tu archivo de autostart:

`~/.config/hypr/autostart.conf`

```
waybar &
mako &
```

En `hyprland.conf` asegurarse de incluir:

```
exec-once = source ~/.config/hypr/autostart.conf
```

---

# Recargar Hyprland

Después de modificar los archivos:

```
hyprctl reload
```
