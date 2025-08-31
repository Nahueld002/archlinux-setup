
# 🧩 Logitech POP Keys & POP Mouse en Arch Linux (Bluetooth)

Guía para instalar y configurar teclado y mouse **Logitech POP** en **Arch Linux** vía **Bluetooth**.

> ⚠️ **Importante**: Estos dispositivos **no usan receptor USB** (Unifying ni Bolt), por lo tanto, se conectan directamente por **Bluetooth**.  
> Sin embargo, podés instalar **Solaar** si querés acceder a opciones avanzadas de configuración de teclas y funciones.

---

## ✅ Requisitos previos

### 1. Instalar los paquetes necesarios

```bash
sudo pacman -Syu
sudo pacman -S bluez bluez-utils blueman
````

---

### 2. Activar y habilitar el servicio Bluetooth

```bash
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
systemctl status bluetooth.service
```

---

## 🟡 Modo emparejamiento

### 3. Colocar los dispositivos en modo "pairing"

#### 🔡 Teclado Logitech POP Keys

* Cambiar el interruptor inferior a `ON`.
* Mantener presionado uno de los botones **Easy-Switch** (`F1`, `F2` o `F3`) hasta que la luz comience a parpadear rápidamente.

> Solo es necesario presionar uno de los botones, no todos.

#### 🖱️ Mouse Logitech POP Mouse

* Encender el mouse con el switch inferior.
* Mantener presionado el botón **Easy-Switch** hasta que parpadee el LED.

---

## 📶 Emparejamiento manual con `bluetoothctl`

### 4. Conectar vía terminal

Abrí el cliente:

```bash
bluetoothctl
```

Dentro del cliente, ejecutá lo siguiente:

```bash
power on
agent on
default-agent
scan on
discoverable on
pairable on
```

Esperá a que aparezca el dispositivo. Ejemplo:

```
[NEW] Device D7:5A:78:0A:8F:45 POP Icon Keys
```

### 5. Emparejar el dispositivo

```bash
pair D7:5A:78:0A:8F:45
```

📌 Cuando el sistema muestre un **PIN**, escribilo directamente **en el teclado POP Keys** y presioná **Enter**.

Luego finalizá la conexión:

```bash
connect D7:5A:78:0A:8F:45
trust D7:5A:78:0A:8F:45
exit
```

---

## 🔄 Confirmar estado

### 6. Verificar si el dispositivo está conectado

```bash
bluetoothctl devices Connected
```

Deberías ver:

```
Device D7:5A:78:0A:8F:45 POP Icon Keys (connected)
```

---

## 🔋 Consultar batería (opcional)

```bash
upower -d | grep -i logitech -A 5
```

---

## 🖱️ Emparejar el mouse (repetir pasos)

### 7. Repetir con el Logitech POP Mouse

Usá el mismo flujo con su dirección MAC correspondiente (`XX:XX:XX:XX:XX:XX`).

---

## 🛠️ Opcional: Configuración avanzada con Solaar

Aunque **no es necesario para usar el POP Keys/Mouse**, podés instalar **Solaar** para acceder a opciones adicionales:

```bash
sudo pacman -Syu python-typing_extensions
yay -S solaar-git

# ⚠️ Lo siguiente es opcional y aún no probado.
# Se deja como referencia si se necesitan reglas extra para uinput:

# Ver grupos y usuario actual
# getent group input

# Agregar tu usuario al grupo input
# sudo gpasswd -a "$USER" input

# Verificar módulo uinput
# lsmod | grep uinput

# Cargar el módulo manualmente
# sudo modprobe uinput

# Cargarlo automáticamente en cada inicio
# echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf

# Regla udev para permisos en /dev/uinput
# sudo tee /etc/udev/rules.d/99-uinput.rules <<EOF
# KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
# EOF
```
---

## ✅ Resumen final

* 🔌 **Bluetoothctl**: Método recomendado para conexión estable y manual.
* 🖼️ **Blueman**: GUI opcional si preferís entorno gráfico.
* ⚙️ **Solaar**: Herramienta opcional para funciones adicionales (no requerida).
* 🚫 Funciones especiales (emoji, dictado): No disponibles en Linux.
* ✅ Funciones básicas (teclas, multimedia, DPI): Funcionan correctamente.

---

### 🧠 Tip extra

Si querés que el dispositivo se reconecte automáticamente en futuros reinicios:

```bash
trust XX:XX:XX:XX:XX:XX
```

> Esto evita que tengas que emparejarlo cada vez.

---

## 📁 Créditos y referencias

* Documentado por: \[Nahueld002]