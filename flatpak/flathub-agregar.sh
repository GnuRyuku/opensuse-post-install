#!/bin/bash
# agregar flathub en el espacio de usuario
    flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak repair
flatpak update
