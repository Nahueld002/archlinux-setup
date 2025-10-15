#!/bin/zsh
# Script para montar la partición de Windows en solo lectura

# Punto de montaje
MOUNTPOINT="/mnt/windows"

# UUID de la partición de Windows
UUID="20A60670A60646AE"

# Crear el directorio si no existe
if [ ! -d "$MOUNTPOINT" ]; then
    sudo mkdir -p "$MOUNTPOINT"
fi

# Intentar montar con ntfs3 (recomendado, driver del kernel)
echo "🔒 Montando Windows (solo lectura) en $MOUNTPOINT..."
sudo mount -t ntfs3 -o ro UUID=$UUID $MOUNTPOINT

# Verificar si montó correctamente
if mount | grep -q "$MOUNTPOINT"; then
    echo "✅ Windows montado en $MOUNTPOINT (modo solo lectura)"
else
    echo "❌ Error al montar la partición de Windows"
fi
