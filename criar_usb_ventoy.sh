#!/bin/bash

# Script para criar USB bootável do Windows com Ventoy
# Autor: Assistente Claude
# Versão: 1.0

set -e  # Parar execução em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    echo -e "${2}${1}${NC}"
}

# Função para verificar se o comando existe
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_message "Erro: $1 não está instalado." $RED
        exit 1
    fi
}

# Função para listar dispositivos USB
list_usb_devices() {
    print_message "Dispositivos USB disponíveis:" $BLUE
    lsblk -d -o NAME,SIZE,MODEL | grep -E "sd[b-z]"
}

# Função para verificar se o dispositivo é válido
validate_device() {
    if [[ ! -b "/dev/$1" ]]; then
        print_message "Erro: Dispositivo /dev/$1 não encontrado." $RED
        exit 1
    fi
    
    # Verificar se é um dispositivo USB
    if ! lsblk -d -o NAME,TRAN | grep "$1" | grep -q "usb"; then
        print_message "Aviso: /dev/$1 pode não ser um dispositivo USB." $YELLOW
        read -p "Deseja continuar mesmo assim? (s/N): " confirm
        if [[ ! $confirm =~ ^[Ss]$ ]]; then
            exit 1
        fi
    fi
}

# Função para baixar o Ventoy
download_ventoy() {
    local ventoy_version="1.0.96"
    local ventoy_url="https://github.com/ventoy/Ventoy/releases/download/v${ventoy_version}/ventoy-${ventoy_version}-linux.tar.gz"
    local ventoy_dir="ventoy-${ventoy_version}"
    
    if [[ ! -d "$ventoy_dir" ]]; then
        print_message "Baixando Ventoy v${ventoy_version}..." $BLUE
        wget -q --show-progress "$ventoy_url" -O "ventoy.tar.gz"
        tar -xzf "ventoy.tar.gz"
        rm "ventoy.tar.gz"
    else
        print_message "Ventoy já existe no diretório." $GREEN
    fi
    
    echo "$ventoy_dir"
}

# Função para instalar Ventoy no USB
install_ventoy() {
    local device=$1
    local ventoy_dir=$2
    
    print_message "Instalando Ventoy no dispositivo /dev/$device..." $BLUE
    
    cd "$ventoy_dir"
    sudo ./Ventoy2Disk.sh -i "/dev/$device"
    cd ..
}

# Função para copiar ISO do Windows
copy_windows_iso() {
    local device=$1
    local iso_path=$2
    
    # Encontrar a partição de dados do Ventoy (geralmente a segunda partição)
    local ventoy_partition="/dev/${device}1"
    local mount_point="/tmp/ventoy_mount"
    
    print_message "Montando partição do Ventoy..." $BLUE
    sudo mkdir -p "$mount_point"
    sudo mount "$ventoy_partition" "$mount_point"
    
    print_message "Copiando ISO do Windows para o USB..." $BLUE
    sudo cp "$iso_path" "$mount_point/"
    
    print_message "Sincronizando dados..." $BLUE
    sudo sync
    
    print_message "Desmontando partição..." $BLUE
    sudo umount "$mount_point"
    sudo rmdir "$mount_point"
}

# Função principal
main() {
    print_message "=== Script para criar USB Windows com Ventoy ===" $GREEN
    
    # Verificar se está executando como root para algumas operações
    if [[ $EUID -eq 0 ]]; then
        print_message "Não execute este script como root. Ele pedirá sudo quando necessário." $RED
        exit 1
    fi
    
    # Verificar dependências
    check_command "wget"
    check_command "tar"
    check_command "lsblk"
    
    # Listar dispositivos USB
    list_usb_devices
    echo
    
    # Solicitar dispositivo USB
    read -p "Digite o dispositivo USB (ex: sdb): " usb_device
    validate_device "$usb_device"
    
    # Confirmar operação
    print_message "ATENÇÃO: Todos os dados em /dev/$usb_device serão APAGADOS!" $RED
    read -p "Tem certeza que deseja continuar? (s/N): " confirm
    if [[ ! $confirm =~ ^[Ss]$ ]]; then
        print_message "Operação cancelada." $YELLOW
        exit 0
    fi
    
    # Baixar Ventoy
    download_ventoy
    ventoy_dir="ventoy-1.0.96"
    
    # Instalar Ventoy
    install_ventoy "$usb_device" "$ventoy_dir"
    
    # Perguntar se deseja copiar ISO do Windows
    read -p "Deseja copiar uma ISO do Windows agora? (s/N): " copy_iso
    if [[ $copy_iso =~ ^[Ss]$ ]]; then
        read -p "Digite o caminho completo para a ISO do Windows: " iso_path
        
        if [[ ! -f "$iso_path" ]]; then
            print_message "Erro: Arquivo ISO não encontrado: $iso_path" $RED
            exit 1
        fi
        
        # Aguardar um pouco para o sistema reconhecer as novas partições
        sleep 3
        copy_windows_iso "$usb_device" "$iso_path"
    fi
    
    print_message "USB bootável criado com sucesso!" $GREEN
    print_message "Você pode adicionar mais ISOs copiando-as diretamente para o USB." $BLUE
    print_message "Para boot, certifique-se de habilitar UEFI e desabilitar Secure Boot se necessário." $YELLOW
}

# Verificar argumentos de linha de comando
case "${1:-}" in
    -h|--help)
        echo "Uso: $0 [opções]"
        echo "Opções:"
        echo "  -h, --help     Mostra esta ajuda"
        echo "  -l, --list     Lista dispositivos USB disponíveis"
        exit 0
        ;;
    -l|--list)
        list_usb_devices
        exit 0
        ;;
    "")
        main
        ;;
    *)
        print_message "Opção inválida: $1" $RED
        print_message "Use $0 --help para ver as opções disponíveis." $YELLOW
        exit 1
        ;;
esac
