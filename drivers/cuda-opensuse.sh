#!/bin/bash

# istalacion de cuda
    log_step "Instalando CUDA Toolkit $cuda_version"
        zypper in -y cuda-toolkit-${cuda_version}
    handle_error "Fallo en la instalación de CUDA Toolkit"
