# ⚙️ Configuración básica de Waybar

Waybar es una barra de estado personalizable para entornos Wayland como Hyprland. Esta guía cubre la instalación, configuración inicial y la manera de mantenerla activa automáticamente.

---

### Instalación de Waybar y Fuentes

1.  **Instalar Waybar**:
    ```bash
    sudo pacman -S waybar
    ```

2.  **Instalar las fuentes esenciales**: Waybar requiere fuentes de íconos para mostrar correctamente los símbolos de la barra de estado.
    ```bash
    sudo pacman -S otf-font-awesome
    ```

---

### Probar la configuración original

Para ver la barra de estado por primera vez, ejecutá el siguiente comando en tu terminal. La barra aparecerá con su configuración predeterminada.

```bash
waybar
```

Para cerrar la barra, presioná `Ctrl + C`.

-----

### Autostart y recarga

Para que Waybar se inicie automáticamente cada vez que inicies Hyprland, debés agregarlo a tu archivo de autostart.

1.  **Agregar Waybar al autostart**:
    Editá tu archivo de autostart (o crealo si no existe) y añadí la siguiente línea. El `&` al final del comando es crucial, ya que permite que el proceso se ejecute en segundo plano y no bloquee la terminal.

    ```bash
    # ~/.config/hypr/autostart.conf
    exec-once = waybar &
    ```

2.  **Recargar Hyprland**:
    Después de guardar los cambios en tu archivo de configuración, usá este comando para que Hyprland aplique los cambios sin necesidad de reiniciar.

    ```bash
    hyprctl reload
    ```

-----

### Configuración personalizada

Para personalizar el aspecto y los módulos de Waybar, primero necesitas copiar los archivos de configuración originales a tu directorio de usuario. Esto te permite modificarlos sin alterar los archivos del sistema.

1.  **Crear el directorio de configuración**:

    ```bash
    mkdir -p ~/.config/waybar
    ```

2.  **Copiar archivos de configuración originales**:

    ```bash
    cp /etc/xdg/waybar/* ~/.config/waybar/
    ```

Ahora ya puedes editar los archivos `config` y `style.css` en la carpeta `~/.config/waybar/` para ajustar la barra a tu gusto.

> 💡 **Tip:** Para aplicar tus cambios de estilo sin cerrar sesión, ejecutá:
> ```bash
> pkill waybar && waybar &
> ```
> Esto reinicia Waybar con la nueva configuración.

-----

## 📁 Créditos y referencias

* Documentado por: \[Nahueld002]