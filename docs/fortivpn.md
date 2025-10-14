# 🔒 OpenFortiVPN + Remmina en Arch Linux

Esta guía cubre la configuración de **OpenFortiVPN** (cliente VPN para Fortinet) y **Remmina** (cliente de escritorio remoto), ideal para conexiones seguras a entornos corporativos.

---

## 1️⃣ Instalación de OpenFortiVPN

Instala el paquete desde los repositorios oficiales de Arch Linux (repositorio *extra*):

```bash
sudo pacman -S openfortivpn
```

Durante la instalación, si te pide elegir un proveedor para resolvconf, la opción más común e integrada es systemd-resolvconf (opción 1).


## 2. Archivo de Conexión

Para poder ejecutar la VPN en segundo plano, la contraseña debe estar en un archivo de configuración.

sudo nano /etc/openfortivpn/config

Agregá los siguientes parámetros (reemplazá los valores con los de tu empresa):

```bash
host = vpn.tuempresa.com
port = 10443
username = tu_usuario
password = tu_contraseña
#trusted-cert = colocar_certificado_aquí (opcional)
```

Ajusta Permisos de Seguridad: Es crucial limitar la lectura del archivo, ya que contiene tu contraseña

## 3. Seguridad

`sudo chmod 600 /etc/openfortivpn/config`

# 4. Habilitar y Configurar systemd-resolved

Si elegiste `systemd-resolvconf` durante la instalación, necesitás activar el servicio systemd-resolved.
Asegúrate de que el gestor de DNS de systemd esté activo:

```bash
sudo systemctl start systemd-resolved.service

sudo systemctl enable systemd-resolved.service
```
## 4.1. Crear el Enlace Simbólico

Necesitas crear un enlace simbólico para que el archivo de configuración de DNS estándar de Linux (/etc/resolv.conf) apunte a la gestión de systemd-resolved:

```bash
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

El comando -sf (symbolic force) reemplaza cualquier archivo resolv.conf que existiera previamente.

# 5. Uso en Segundo Plano (Conectar y Desconectar)

## 5.1. Conectar la VPN (Modo Desatendido)

Utiliza nohup y & para ejecutar la VPN en segundo plano sin bloquear tu terminal y sin que se detenga si cierras la ventana:

```bash
sudo nohup openfortivpn -c /etc/openfortivpn/config &
```
El sistema te devolverá un número: el PID (Process ID), por ejemplo: `[1] 9762`. Anótalo.
Tu terminal quedará libre inmediatamente.

## 5.2. Desconectar la VPN

Cuando termines tu trabajo y quieras cerrar la sesión de VPN, debes "matar" el proceso usando el PID.

    Encuentra el PID (si lo olvidaste):

```bash
pgrep openfortivpn
```
Mata el proceso:
```bash
sudo kill <PID>
# Ejemplo:
# sudo kill 9762
```
La conexión VPN se cerrará instantáneamente.

---
# 🖥️ Remmina – Escritorio Remoto (RDP)

Instalá Remmina y el complemento para RDP:

```bash
sudo pacman -S remmina freerdp
```

## Conexión de Escritorio Remoto (RDP)

1. Asegurate de que la VPN esté activa — usando OpenFortiVPN.
2. Abrí Remmina desde el menú de aplicaciones.
3. Creá una nueva conexión con el ícono ➕.
4. Configurá los parámetros:
5. Configura los Parámetros:
    - Protocolo: Selecciona RDP - Remote Desktop Protocol.
    - Servidor: Introduce la dirección IP interna de tu PC de oficina (la IP que tiene dentro de la red corporativa, no la IP que te asignó la VPN).
    - Nombre de usuario y Contraseña: Ingresa las credenciales de la cuenta de usuario que usas para iniciar sesión en tu PC de oficina con Windows.
    - Conectar: Haz clic en "Guardar y Conectar" para iniciar la sesión remota a través del túnel VPN activo.

---

## 📁 Créditos y referencias

* Documentado por: \[Nahueld002]