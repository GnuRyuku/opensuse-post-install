#!/bin/bash

# el script fue verificado y modificado por una IA (especificamente por Cloude Haiku, 
# pero con comportamiento de tsundere de secundaria) si algo no cuadra, por fovor, dimelo

# Verificar sudo
if [ "$EUID" -ne 0 ]; then
    echo "Este script requiere permisos de sudo"
    exit 1
fi

# Función de colores
color_echo() {
    local color="$1"
    local text="$2"
    case "$color" in
        "red")     echo -e "\033[0;31m$text\033[0m" ;;
        "green")   echo -e "\033[0;32m$text\033[0m" ;;
        "yellow")  echo -e "\033[1;33m$text\033[0m" ;;
        "blue")    echo -e "\033[0;34m$text\033[0m" ;;
        *)         echo "$text" ;;
    esac
}

# Manejo de errores mejorado
handle_error() {
    local exit_code=$?
    local message="$1"
    if [ $exit_code -ne 0 ]; then
        color_echo "red" "ERROR: $message (código: $exit_code)"
        exit $exit_code
    fi
}

# Log de ejecución (útil para debugging)
log_step() {
    color_echo "blue" "[$(date '+%H:%M:%S')] $1"
}

log_step "Iniciando instalación de drivers NVIDIA en openSUSE"

# Agregar repositorios
log_step "Añadiendo repositorios NVIDIA y CUDA"
zypper install -y openSUSE-repos-Tumbleweed-NVIDIA
zypper addrepo https://developer.download.nvidia.com/compute/cuda/repos/suse16/x86_64/ cuda
handle_error "Fallo al agregar repositorios"

# Instalar drivers
log_step "Instalando drivers NVIDIA"
zypper in -y --auto-agree-with-licenses \
    nvidia-open-driver-G07-signed-kmp-meta \
    nvidia-driver-G07 \
    nvidia-compute-utils-G07 \
    nvidia-video-G07 \
    nvidia-settings
handle_error "Fallo en la instalación de drivers"

# CUDA Toolkit (con validación)
read -p "¿Instalar CUDA Toolkit? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    read -p "Introduce la versión de CUDA (ej: 12.4): " cuda_version
    if [ -z "$cuda_version" ]; then
        color_echo "red" "Versión no válida"
        exit 1
    fi
    log_step "Instalando CUDA Toolkit $cuda_version"
    zypper in -y cuda-toolkit-${cuda_version}
    handle_error "Fallo en la instalación de CUDA Toolkit"
fi

# Regenerar dracut
log_step "Regenerando dracut"
dracut -f --regenerate-all
handle_error "Fallo al regenerar dracut"

# Reinicio
read -p "¿Reiniciar el sistema? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    log_step "Reiniciando sistema..."
    systemctl reboot
else
    color_echo "green" "Instalación completada. Recuerda reiniciar cuando puedas"
fi