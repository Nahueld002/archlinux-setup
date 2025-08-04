
# Terminal Avanzado

Esta sección cubre herramientas y configuraciones para mejorar la experiencia en la terminal, incluyendo ZSH, alias personalizados, fuentes con íconos y prompts modernos.

---

# ZSH + Oh My Zsh

## Instalación de ZSH

```
sudo pacman -S zsh
```

## Hacer ZSH tu shell por defecto

```
chsh -s /bin/zsh
```

Cerrar y volver a abrir la terminal para usar ZSH.

## Instalar Oh My Zsh

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Esto generará el archivo `~/.zshrc` donde podrás personalizar alias, tema y plugins.

---

# Eza – Reemplazo moderno para ls

## Instalación

```
sudo pacman -S eza
```

### Ventajas de Eza

- Soporte para colores
- Íconos con Nerd Fonts
- Árbol de directorios
- Permisos legibles
- Agrupación por tipo

### Ejemplo de uso

```
eza -l --icons --git
```

## Alias recomendados

Agregar a `~/.zshrc` o `~/.bashrc`:

```
alias ls='eza --icons'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
```

Aplicar cambios:

```
source ~/.zshrc
```

---

# Fuentes con Íconos – Nerd Fonts

Para que los íconos de Eza y otras herramientas se muestren correctamente, instalar:

```
sudo pacman -S ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
```

Configurar la terminal (ejemplo para Kitty):

`~/.config/kitty/kitty.conf`

```
font_family      FiraCode Nerd Font
```

---

# Starship – Prompt moderno para terminal

## Instalación

```
sudo pacman -S starship
```

## Activar en ZSH

Agregar al final de `~/.zshrc`:

```
eval "$(starship init zsh)"
```

## Configuración opcional

Crear carpeta y archivo de configuración:

```
mkdir -p ~/.config
starship preset plain-text-symbols > ~/.config/starship.toml
```
