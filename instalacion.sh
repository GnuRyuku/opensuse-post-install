#!/bin/bash
echo "1) instalar los drivers de nvidia + cuda"
echo "2) eliminar flathub y volver a agregarlo como repo de usuario"
echo "3) ..."
read -p "elige entre (1, 2, 3): " elegir

case $elegir in
    1)
        chmod +x ./drivers/nvidia-opensuse.sh
        ./drivers/nvidia-opensuse.sh
    ;;
    2)
        chmod +x ./flatpak/flathub-fulminar.sh ./flatpak/flathub-agregar.sh
        ./flatpak/flathub-fulminar.sh && ./flatpak/flathub-agregar.sh
    ;;
    3)
        echo "el que lo lea es gay"
    ;;
esac


# Your script here
