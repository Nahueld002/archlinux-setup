
>se mueven todos los archivos del .config a la carpeta de dotfiles donde se hará el pase a github

mv ~/.config/hypr/*.conf ~/proyectos/dotfiles/hyprland

>se borra la carpeta orginial

rm -rf ~/.config/hypr

> se realiza un enlace tipo acceso directo desde donde era la carpeta orignal, asi todos los archivos colocados en la carpeta del github "estarán" en la orignal y hyprland podra leerlo

ln -s ~/proyectos/dotfiles/hyprland ~/.config/hypr

ls -l ~/.config | grep hypr


sudo pacman -Sy fastfecth
fastfecth 
>para ver la resolucioon de la pantalla, sirve para editar el width de waybar en el config. 


sudo pacman -S papirus-icon-theme


# Para manejo de archivos JSON (registry.json)
sudo pacman -S jq
