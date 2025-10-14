# 🐚 Terminal Avanzada en Arch Linux

Este repositorio documenta la configuración de una terminal moderna, productiva y visualmente atractiva en Arch Linux. La guía cubre la instalación de **Kitty**, **ZSH** con **Oh My Zsh** y plugins, además de herramientas complementarias como **Eza**, **Tree**, **Starship**, **Nerd Fonts** y **Fastfetch**.

---

### Requisitos previos

Antes de comenzar, es una buena práctica asegurarse de que el sistema esté actualizado.

```bash
sudo pacman -Sy
sudo pacman -Syu
```

-----

## 🖥️ 1. Emulador de terminal (Kitty)

**Kitty** es un emulador de terminal rápido y ligero, con soporte completo para íconos y ligaduras de fuentes, lo que lo hace ideal para usar con las herramientas que instalaremos a continuación.

1.  **Instalación**:

    ```bash
    sudo pacman -S kitty
    ```

2.  **Seleccionar tema**:
    Para ver y aplicar temas, usa el siguiente comando y navega con las flechas. Presiona `Enter` para aplicar y `M` para generar un archivo de configuración con el tema seleccionado.

    ```bash
    kitten themes
    ```

3.  **Configuración inicial**:
    Kitty crea un archivo de configuración enlazado al tema en `~/.config/kitty/kitty.conf`.

-----

## 🐚 2. ZSH + Oh My Zsh

**ZSH** es un shell avanzado que, junto con **Oh My Zsh** y sus plugins, permite una experiencia de uso más poderosa y personalizable.

### Instrucciones paso a paso

1.  **Instalar ZSH y Git**:

    ```bash
    sudo pacman -S zsh git
    ```

2.  **Hacer ZSH tu shell predeterminado**:

    ```bash
    chsh -s $(which zsh)
    ```

    *Después de ejecutar este comando, cierra y vuelve a abrir tu terminal para que los cambios surtan efecto.*

3.  **Instalar Oh My Zsh**:

    ```bash
    sh -c "$(curl -fsSL [https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh](https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh))"
    ```

4.  **Instalar plugins recomendados**:

    ```bash
    # Navega a tu directorio de plugins de Oh My Zsh
    cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins

    # Clonar los repositorios de los plugins
    git clone [https://github.com/zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions)
    git clone [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
    git clone [https://github.com/zsh-users/zsh-syntax-highlighting.git](https://github.com/zsh-users/zsh-syntax-highlighting.git)
    git clone [https://github.com/zdharma-continuum/fast-syntax-highlighting.git](https://github.com/zdharma-continuum/fast-syntax-highlighting.git)
    git clone --depth 1 -- [https://github.com/marlonrichert/zsh-autocomplete.git](https://github.com/marlonrichert/zsh-autocomplete.git)
    ```

5.  **Editar la configuración de ZSH**:
    Abre tu archivo `~/.zshrc` y añade los plugins que acabas de instalar.

    ```bash
    nano ~/.zshrc
    ```

    ```
    plugins=(
      git
      zsh-autosuggestions
      zsh-syntax-highlighting
      fast-syntax-highlighting
      zsh-autocomplete
    )

    # Asegúrate de que esta línea esté presente para las autocompleciones
    fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
    ```

    *Siéntete libre de añadir o quitar plugins según tus necesidades.*

6.  **Aplicar los cambios**:

    ```bash
    source ~/.zshrc
    ```

-----

## 🛠️ 3. Herramientas de productividad y personalización

### **Eza - Reemplazo de `ls`**

**Eza** es una herramienta moderna para listar directorios con soporte para colores, íconos y Git.

1.  **Instalación**:

    ```bash
    sudo pacman -S eza
    ```

2.  **Alias recomendados**:
    Agrega estos alias en tu `~/.zshrc` para usar `eza` como tu comando predeterminado para listar.

    ```
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    ```

### **Tree - Visualización jerárquica**

**Tree** es una herramienta útil para visualizar la estructura de directorios de manera jerárquica.

1.  **Instalación**:
    ```bash
    sudo pacman -S tree
    ```

### **Nerd Fonts - Fuentes con íconos**

Son necesarias para que Eza, Starship y otros programas muestren íconos correctamente.

1.  **Instalación**:
    ```bash
    sudo pacman -S ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
    ```

### **Starship - Prompt moderno**

**Starship** es un prompt de terminal minimalista y súper rápido que muestra información relevante de un vistazo.

1.  **Instalación**:

    ```bash
    sudo pacman -S starship
    ```

2.  **Activar en ZSH**:
    Agrega la siguiente línea al final de tu `~/.zshrc`.

    ```
    eval "$(starship init zsh)"
    ```

### **Fastfetch - Información del sistema**

**Fastfetch** es un script rápido para mostrar información del sistema, similar a `neofetch`.

1.  **Instalación**:

    ```bash
    sudo pacman -S fastfetch
    ```

2.  **Generar configuración**:

    ```bash
    fastfetch --gen-config
    ```

---

## 📁 Créditos y referencias

* Documentado por: \[Nahueld002]