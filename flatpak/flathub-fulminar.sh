#!/bin/bash
# eliminar flathub del espacio root
    flatpak remote-delete flathub --force || true
