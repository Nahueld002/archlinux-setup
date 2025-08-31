# 🧩 Logitech POP Keys & POP Mouse en Arch Linux (Bluetooth)

Guía para instalar y configurar teclado y mouse **Logitech POP** en **Arch Linux** vía **Bluetooth**.

> ⚠️ **Importante**: Estos dispositivos **no usan receptor USB** (Unifying ni Bolt), por lo tanto, **Solaar no aplica** en este caso.

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

## ✅ Resumen final

* 🔌 **Solaar**: No aplica (solo útil con receptores Bolt/Unifying).
* 🧭 **bluetoothctl**: Método recomendado para conexión estable y manual.
* 🖼️ **Blueman**: GUI opcional si preferís entorno gráfico.
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

* Tested on: Arch Linux (kernel 6.x), Logitech POP Keys / Mouse
* Documentado por: \[Nahueld002]