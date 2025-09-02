# 🐧 Instalación de Arch Linux con `archinstall` (UEFI + Dual Boot)

Este documento detalla el uso del instalador `archinstall` para configurar Arch Linux, conservando una instalación previa de Windows en dual boot.

---

## 💻 3. Ejecutar el instalador

```bash
archinstall
````

### Opciones en el instalador

  - **Lenguaje**: `English`
  - **Mirrors**: Elegí una región cercana para mayor velocidad de instalación.
  - **Locales**:
      - `Keyboard layout`: `es`
      - `Locale language`: `es_ES`
      - `Locale encoding`: `UTF-8`

-----

## 💾 Configuración de discos y particiones

> **Importante**: Si querés mantener Windows y hacer dual boot, no uses la opción automática. Seleccioná: `Manual Partitioning`.

### Pasos

1.  **Seleccioná el disco** donde vas a instalar Arch.
2.  Presioná `d` para **eliminar particiones** una por una.
3.  Si es necesario, creá una nueva tabla `GPT`.
4.  **Creá las nuevas particiones**:
      - `/boot` (FAT32, 512 MiB, flags: `boot`, `esp`)
      - `/` (ext4)
      - `/home` (ext4, opcional)
      - `swap` (linux-swap)

### Ejemplo de esquema de particionado

| Mountpoint | Dispositivo    | Tamaño         | Sistema de archivos | Flags      | Observaciones                               |
|------------|----------------|----------------|---------------------|------------|---------------------------------------------|
| `/boot`    | `/dev/nvme0n1p1` | `1 GiB`        | `fat32`             | `boot, esp`| Partición del sistema EFI (la de Windows)   |
| `[SWAP]`   | `/dev/nvme0n1p2` | `~3.8 GiB`     | `linux-swap`        | `swap`     | Partición de intercambio                    |
| `/`        | `/dev/nvme0n1p3` | `~93.1 GiB`    | `ext4`              | —          | Sistema raíz (`/`)                          |
| `/home`    | `/dev/nvme0n1p4` | `~367.3 GiB`   | `ext4`              | —          | Directorio personal                         |

-----

## ⚙️ Configuración del sistema

  - **Bootloader**: `GRUB`
  - **Hostname**: Asigná un nombre de host.
  - **User account**:
      - Creá un usuario y asignale una contraseña.
      - Marcá como superusuario: `Yes`.
  - **Profile**:
      - `Type`: `Desktop`
          - Entorno gráfico: `Hyprland`
          - `Polkit`: `Yes`
  - **Graphics driver**: `All open-source`
  - **Greeter**: `sddm`
  - **Audio**: `Pipewire`
  - **Kernel**: `linux`
  - **Network configuration**: `networkmanager`
  - **Timezone**: `America/Asuncion`
  - **Automatic time sync**: `True`
  - **Optional repositories**: `multilib`

-----

## ✅ Instalar

> **Importante:** Si `archinstall` genera un error relacionado con `swap` activa, pasá al siguiente paso. Si no hay error, continuá al paso 6.

### ⚠️ 4. Solución para error con `swap`

**Error común:**

```
swapoff: /dev/nvme1n1p2: swap failed: Device or resource busy
archinstall.exceptions.DiskError: Could not enable swap: /dev/nvme1n1p2
```

**Solución**: Salí del instalador y ejecutá:

```bash
swapoff /dev/nvme1n1pX
```

> Reemplazá `X` por el número de partición de `swap` que figure en el error.

### 5\. Volver a ejecutar el instalador

```bash
archinstall
```

> En este punto, solo tenés que reasignar los puntos de montaje (`/`, `/boot`, etc.), no recrees las particiones. Luego, ejecutá nuevamente `Install`.

-----

## 🚀 Post-Instalación

### 6\. Reiniciar el sistema

Cuando finalice el proceso, el instalador preguntará si deseás abrir un entorno `chroot`. Elegí `No` y luego:

```bash
reboot
```

### 7\. Configurar la BIOS/UEFI

  - Entrá a la BIOS (usualmente con `F2` o `DEL`).
  - Cambiá el orden de arranque (`Boot Order`) para que `Arch Linux` sea la primera opción.

### 8\. Primer inicio

  - Seleccioná `Arch Linux` desde el gestor de arranque `GRUB`.
  - Iniciá sesión con el usuario y la contraseña que creaste.
  - **Actualizá el sistema**:

<!-- end list -->

```bash
sudo pacman -Syu
```

  - **Iniciá Hyprland**:

<!-- end list -->

```bash
Hyprland
```

-----

➡️ Continuá desde el [paso 9: conexión Wi-Fi en el sistema instalado](instalacion-archlinux.md#9-conectarse-a-wi-fi-en-sistema-ya-instalado) en el documento principal `instalacion-archlinux.md`.

```
```