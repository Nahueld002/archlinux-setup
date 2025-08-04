# Instalación de Arch Linux con archinstall (UEFI + Dual Boot)

Este documento detalla el uso del instalador `archinstall` para configurar Arch Linux, conservando una instalación previa de Windows en dual boot.

---

## 3. Ejecutar el instalador

```
archinstall
```

## En el instalador

### Lenguaje
Seleccionar `English`

### Mirrors
Elegir una región cercana para obtener mejor velocidad de instalación.

### Locales
- Keyboard layout: `es`
- Locale language: `es_ES`
- Locale encoding: `UTF-8`

### Disk configuration

**Importante:** Si querés mantener Windows y hacer dual boot, no uses la opción automática. Seleccioná:

```
Manual Partitioning
```

Esto te permite:
- Elegir qué disco usar
- Qué particiones borrar o conservar
- Asignar manualmente `/`, `/boot`, `/home`, `swap`

### Eliminar particiones existentes

Seleccioná el disco donde querés instalar Arch y presioná `d` para eliminar particiones una por una.

Si es necesario, creá una nueva tabla GPT.

### Crear nuevas particiones

- `/boot` (FAT32, 512 MiB, flags: `boot`, `esp`)
- `/` (ext4)
- `/home` (ext4, opcional)
- `swap` (linux-swap)

### Esquema de particionado final — Arch Linux (UEFI + Dual Boot)

| Mountpoint | Dispositivo    | Tamaño legible | Sistema de archivos | Flags        | Observaciones                    |
|------------|----------------|----------------|----------------------|--------------|----------------------------------|
| `/boot`    | /dev/nvme0n1p1 | 1 GiB          | `fat32`              | `boot, esp`  | EFI system partition             |
| `[SWAP]`   | /dev/nvme0n1p2 | ~3.8 GiB       | `linux-swap`         | `swap`       | Partición de intercambio activa  |
| `/`        | /dev/nvme0n1p3 | ~93.1 GiB      | `ext4`               | —            | Sistema raíz (`/`)               |
| `/home`    | /dev/nvme0n1p4 | ~367.3 GiB     | `ext4`               | —            | Directorio personal separado     |

### Bootloader
Elegir: `GRUB`

### Hostname
Asignar un nombre de host personalizado.

### User account
- Crear un usuario
- Asignar contraseña
- Marcar como superuser: `Yes`

### Profile
- Type: `Desktop`
  - Entorno gráfico: `Hyprland`
  - Polkit: `Yes`
- Graphics driver: `All open-source`
- Greeter: `sddm`

### Audio
Seleccionar: `Pipewire`

### Kernel
Seleccionar: `linux`

### Network configuration
Seleccionar: `networkmanager`

### Timezone
Seleccionar: `America/Asuncion`

### Automatic time sync
Seleccionar: `True`

### Optional repositories
Marcar: `multilib`

## Instalar

---

**Si aparece un error con swap activa, continuar con el paso 4.  
Si no hay error, pasar directamente al paso 6.**

---

## ⚠️ 4. Error con swap activa

### Error
```
swapoff: /dev/nvme1n1p2: swap failed: Device or resource busy
archinstall.exceptions.DiskError: Could not enable swap: /dev/nvme1n1p2
```

### Solución

Salir del instalador y ejecutar:

```
swapoff /dev/nvme1n1pX
```

> Reemplazar `X` por el número de partición swap que figura en el error.

---

## 5. Volver a ejecutar el instalador

```
archinstall
```

- Reasignar los puntos de montaje: `/`, `/boot`, `/home`, `swap`
- No recrear particiones, solo montar
- Ejecutar nuevamente `Install`

---

## 6. Reiniciar el sistema

Cuando finalice, el instalador preguntará si se desea abrir un entorno `chroot`. Elegir `No` y luego:

```
reboot
```

---

## 7. Configurar BIOS/UEFI

- Ingresar a BIOS con `F2`, `DEL`, etc.
- Cambiar el orden de booteo:
  1. `UEFI OS (WD Green SN350)`
  2. `Windows Boot Manager`

---

## 8. Iniciar en Arch Linux

Seleccionar Arch Linux desde el gestor de arranque GRUB.

---

¿Terminaste de instalar Arch Linux con `archinstall`?

➡️ Continuá desde el [paso 9: conexión Wi-Fi en el sistema instalado](instalacion-archlinux.md#9-conectarse-a-wi-fi-en-sistema-ya-instalado) en el documento principal `instalacion-archlinux.md`.
