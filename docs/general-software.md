# 📦 Software General y Multimedia

Esta sección cubre la instalación de herramientas esenciales para el uso diario en Arch Linux, incluyendo navegadores, editores de texto, aplicaciones multimedia y utilidades.

---

## 1. 🖥️ Multimedia y Visores

### Visores de imágenes

* **Loupe**: Visor de imágenes simple y elegante para entornos Wayland.

    ```bash
    sudo pacman -S loupe
    ```

### Reproductores de medios

* **VLC**: Reproductor de audio y video compatible con la mayoría de los formatos.
* **Upscayl**: Herramienta de escalado de imágenes por IA.

    ```bash
    sudo pacman -S vlc
    yay -S upscayl-bin
    ```

---

## 2. 📝 Edición de Texto y Documentos

* **LibreOffice**: Suite ofimática completa, compatible con documentos de Microsoft Office.
* **VS Code - OSS**: Editor de código libre y de código abierto.
* **evince**: Soporte de PDF.

    ```bash
    sudo pacman -S libreoffice-fresh code evince

    ```

---

## 3. 🌐 Navegación y Comunicación

* **Firefox**: Navegador web libre, seguro y rápido.
* **Discord**: Plataforma de comunicación para comunidades.
* **Thunderbird**: Cliente de correo y calendario.

    ```bash
    sudo pacman -S firefox thunderbird
    yay -S discord
    ```

---

## 4. ✂️ Herramientas de Captura de Pantalla

En los entornos Wayland como Hyprland, se requieren herramientas específicas para capturar la pantalla.

* **Grim** y **Slurp**: Herramientas para capturas de pantalla. Grim captura, y Slurp permite seleccionar una región.
* **Swappy**: Permite editar o recortar las capturas tomadas con Grim.
* **wl-clipboard**: Gestiona el portapapeles en Wayland.
* **wf-recorder**: Graba la pantalla de forma nativa en Wayland.

    ```bash
    sudo pacman -S grim slurp swappy wl-clipboard
    ```
    
    ```bash
    yay -S wf-recorder
    ```
---

## 5. 🛠️ Utilidades del Sistema

* **jq**: Herramienta de línea de comandos para procesar archivos JSON.
* ***gnome-disk-utility**: Gestión de discos, USB y particiones.

    ```bash
    sudo pacman -S jq gnome-disk-utility
    ```

---

## 📁 Créditos y referencias

* Documentado por: \[Nahueld002]