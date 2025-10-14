# ⚙️ Software y Servicios Esenciales del Sistema

Esta sección cubre la instalación y configuración de las herramientas y servicios fundamentales para el sistema en un entorno **Hyprland + Wayland**, incluyendo audio, brillo, notificaciones y monitoreo.

---

### Requisitos previos

Para que los módulos de Waybar funcionen correctamente, es necesario instalar algunos paquetes y habilitar sus servicios.

```bash
# Instalación de paquetes necesarios
sudo pacman -S networkmanager bluez acpi upower
yay -S power-profiles-daemon

# Activación de servicios
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service
```

-----
## 1. Integración del entorno Wayland (Portales XDG)

Los portales XDG son un componente esencial del ecosistema Wayland.
Permiten que las aplicaciones (especialmente Flatpak o de sandbox) interactúen correctamente con el sistema — por ejemplo: abrir archivos, compartir pantalla, acceder al portapapeles, usar cámara o micrófono, etc.

1.  **Instalar**
    ```bash
    sudo pacman -S xdg-desktop-portal-hyprland xdg-desktop-portal xdg-desktop-portal-gtk
    ```
2. **Descripción de cada uno:**

    xdg-desktop-portal → el servicio base que ofrece las interfaces estandarizadas.

    xdg-desktop-portal-hyprland → implementación específica para Hyprland (requerida para screen sharing y capturas).

    xdg-desktop-portal-gtk → permite a las apps GTK integrarse con los portales (selector de archivos, temas, etc.).

3. **Activación automática:**
    Para garantizar que los portales se inicien correctamente después de Hyprland, se recomienda usar un script personalizado (`~/.config/scripts/portales.sh`).
    Luego, añadí el script al archivo de autostart de Hyprland.

## 🎧 2. Configuración de Audio (PipeWire)

**PipeWire** es el servidor de audio que Hyprland usa por defecto. Para asegurarte de que todo funcione correctamente, instala los siguientes paquetes.

1.  **Instalar los paquetes de audio**:

    ```bash
    sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber bluez bluez-utils pavucontrol
    ```

      * `pipewire`: El servidor de audio principal.
      * `wireplumber`: El gestor de sesiones de audio.
      * `pavucontrol`: Una interfaz gráfica para controlar el volumen.

2.  **Activar los servicios de audio**:

    ```bash
    systemctl --user enable --now pipewire pipewire-pulse wireplumber
    ```

3.  **Verificar el funcionamiento**:

    ```bash
    pactl info | grep Server
    ```

-----

## ⚡ 3. Módulos y servicios de energía

### **Control de Brillo**

Para controlar el brillo de la pantalla en laptops, instala y usa `brightnessctl`.

1.  **Instalación**:
    ```bash
    sudo pacman -S brightnessctl
    ```
2.  **Comandos útiles**:
    ```bash
    brightnessctl set 10%+   # Aumentar el brillo
    brightnessctl set 10%-   # Disminuir el brillo
    ```

### **Perfiles de energía**

Controla los perfiles de energía (rendimiento, equilibrado, ahorro) en tu laptop.

1.  **Instalación**:
    ```bash
    yay -S power-profiles-daemon
    ```
2.  **Uso**:
    ```bash
    powerprofilesctl set performance
    powerprofilesctl set power-saver
    powerprofilesctl set balanced
    ```

-----

## 🔔 4. Notificaciones y monitoreo

### **Mako - Notificaciones**

**Mako** es un gestor de notificaciones simple y ligero para Wayland.

1.  **Instalación**:
    ```bash
    sudo pacman -S mako
    ```
2.  **Autostart**:
    Para que las notificaciones funcionen, asegúrate de agregar Mako a tu archivo de autostart.
    ```bash
    # ~/.config/hypr/autostart.conf
    exec-once = mako
    ```

### **Bottom (btm) - Monitor de recursos**

**Bottom** es un monitor de sistema interactivo en la terminal, moderno y altamente visual.

1.  **Instalación**:
    ```bash
    yay -S bottom
    ```
2.  **Uso**:
    ```bash
    btm
    ```

-----

## 🖼️ 5. Estilo visual del sistema

### **Qt6ct - Temas de aplicaciones**

**Qt6ct** es una herramienta gráfica esencial para que las aplicaciones Qt6 (como VLC o VirtualBox) se integren visualmente con tu tema de Hyprland.

1.  **Instalación**:
    ```bash
    sudo pacman -S qt6ct
    ```
2.  **Ejecución**:
    Ejecuta el comando para abrir la interfaz gráfica y configurar el tema, las fuentes y los iconos.
    ```bash
    qt6ct
    ```

---

## 📁 Créditos y referencias

* Documentado por: \[Nahueld002]