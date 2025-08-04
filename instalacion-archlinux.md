# Instalación de Arch Linux (UEFI + Dual Boot con Windows)

Este documento describe el proceso paso a paso para instalar Arch Linux en una máquina con UEFI y dual boot junto a Windows.

---

## 🐧 1. Configuración Inicial desde la Live ISO

```
loadkeys es                   # Activar teclado español
pacman-key --init             # Inicializar llaves GPG de paquetes
```

---

## 🌐 2. Conexión a Wi-Fi (modo Live)

```
systemctl enable iwd --now    # Activar gestor de red
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "TuRed"
exit
ping google.com            # Verificar conexión
```

---

### Continuar con la instalación usando el instalador guiado

Para los pasos 3 al 8, seguí el archivo:

➡️ [Instalación con archinstall (pasos 3 al 8)](archinstall.md)


---

## 🌐 9. Conectarse a Wi-Fi (en sistema ya instalado)

1. Verificar IP:
   ```
   ip a
   ```

2. Activar servicio:
   ```
   sudo systemctl enable NetworkManager --now
   ```

3. Conectar a red:
   ```
   nmcli device wifi list
   nmcli device wifi connect "NombreDeRed" password "TuContraseña"
   ```

4. Probar conexión:
   ```
   ping google.com
   ```

---

## 10. Activar detección de Windows en GRUB

Para habilitar el arranque dual con Windows, seguí estos pasos:

### Instalar os-prober

```
sudo pacman -S os-prober
```

### Editar la configuración de GRUB

Abrí el archivo:

```
sudo nano /etc/default/grub
```

Buscá esta línea (puede estar comentada):

```
#GRUB_DISABLE_OS_PROBER=true
```

- Comentala (`#`) o eliminá esa línea.
- Luego agregá o asegurate de que exista esta línea activa:

```
GRUB_DISABLE_OS_PROBER=false
```

Guardá los cambios con:
- `Ctrl + O` (guardar)
- `Enter` (confirmar)
- `Ctrl + X` (salir)


### Detectar sistemas operativos

```
sudo os-prober
```

Deberías ver algo como:

```
Found Windows Boot Manager on /dev/nvme0n1p1
```

### Regenerar el archivo de configuración de GRUB

```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
---

## 11. Reiniciar

```
reboot
```

✅ ¡Listo! Al reiniciar, se debería ver en GRUB:

- Arch Linux
- Windows Boot Manager
