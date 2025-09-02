# 💻 Instalación de Arch Linux (UEFI + Dual Boot con Windows)

Este documento describe el proceso paso a paso para instalar Arch Linux en una máquina con **UEFI** y **dual boot** junto a Windows.

---

## 1. 🐧 Configuración inicial desde la Live ISO

1.  **Activar el teclado en español**:
    ```bash
    loadkeys es
    ```

2.  **Inicializar las llaves de paquetes**:
    ```bash
    pacman-key --init
    ```

---

## 2. 🌐 Conexión a Wi-Fi (modo Live)

Para conectar tu equipo a Internet desde el entorno de instalación:

```bash
systemctl enable iwd --now    # Activar el gestor de red
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "TuRed"
exit
ping google.com               # Verificar la conexión
````

-----

### ➡️ Continuar con la instalación guiada

Para los pasos **3 al 8**, seguí las instrucciones en el siguiente documento:

* [Instalación con `archinstall` (pasos 3 al 8)](archinstall.md)
-----

## 9\. 🌐 Conectarse a Wi-Fi (en el sistema instalado)

1.  **Verificar la interfaz de red**:

    ```bash
    ip a
    ```

2.  **Activar el servicio de NetworkManager**:

    ```bash
    sudo systemctl enable NetworkManager --now
    ```

3.  **Conectarse a la red inalámbrica**:

    ```bash
    nmcli device wifi list
    nmcli device wifi connect "NombreDeRed" password "TuContraseña"
    ```

4.  **Probar la conexión**:

    ```bash
    ping google.com
    ```

-----

## 10\. 🖼️ Activar el dual boot con GRUB

Para que GRUB detecte e incluya Windows en el menú de inicio:

1.  **Instalar `os-prober`**:

    ```bash
    sudo pacman -S os-prober
    ```

2.  **Editar la configuración de GRUB**:
    Abrí el archivo de configuración en tu editor preferido:

    ```bash
    sudo nano /etc/default/grub
    ```

    Buscá la línea `#GRUB_DISABLE_OS_PROBER=true` y **asegurate de que esté comentada** (con `#`) o eliminala. Luego, añadí o asegurate de que la siguiente línea esté activa:

    ```
    GRUB_DISABLE_OS_PROBER=false
    ```

    Guardá y cerrá el archivo.

3.  **Detectar los sistemas operativos**:

    ```bash
    sudo os-prober
    ```

    Si todo va bien, verás un resultado similar a: `Found Windows Boot Manager on /dev/nvme0n1p1`

4.  **Regenerar el archivo de configuración de GRUB**:

    ```bash
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

-----

## 11\. 🔄 Reiniciar el sistema

Finalmente, reiniciá el sistema para ver los cambios:

```bash
reboot
```

✅ ¡Listo\! Al reiniciar, el gestor de arranque de GRUB debería mostrar tanto **Arch Linux** como **Windows Boot Manager**, permitiéndote elegir qué sistema iniciar.

---

## 📁 Créditos y referencias

* Documentado por: \[Nahueld002]