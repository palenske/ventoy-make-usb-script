# Script para Criação de USB Bootável com Ventoy

Este script automatiza o processo de criação de um USB bootável usando o Ventoy, permitindo ter múltiplas ISOs (Windows, Linux, etc.) em um único dispositivo USB.

## 📋 Índice

- [Características](#características)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso](#uso)
- [Opções Disponíveis](#opções-disponíveis)
- [Passo a Passo Completo](#passo-a-passo-completo)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Contribuindo](#contribuindo)

## ✨ Características

- 🚀 **Instalação automática** do Ventoy mais recente
- 🔍 **Detecção automática** de dispositivos USB
- 🛡️ **Verificações de segurança** antes de modificar o USB
- 🎨 **Interface colorida** e amigável
- 📁 **Suporte a múltiplas ISOs** no mesmo USB
- ⚡ **Cópia automática** de ISOs (opcional)
- 🔧 **Tratamento robusto de erros**

## 📦 Pré-requisitos

### Sistema Operacional
- Linux (testado no Ubuntu 20.04+, Debian 10+, Fedora 35+)
- Acesso sudo

### Dependências
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install wget tar util-linux

# Fedora/CentOS/RHEL
sudo dnf install wget tar util-linux

# Arch Linux
sudo pacman -S wget tar util-linux
```

### Hardware
- USB drive com **pelo menos 8GB** (recomendado 16GB+)
- ISO do Windows ou outras ISOs que deseja usar

## 🚀 Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/seu-usuario/ventoy-usb-script.git
cd ventoy-usb-script
```

2. **Torne o script executável:**
```bash
chmod +x criar_usb_ventoy.sh
```

## 💻 Uso

### Uso Básico
```bash
./criar_usb_ventoy.sh
```

### Listar Dispositivos USB
```bash
./criar_usb_ventoy.sh --list
```

### Mostrar Ajuda
```bash
./criar_usb_ventoy.sh --help
```

## 🔧 Opções Disponíveis

| Opção | Descrição |
|-------|-----------|
| `--help` `-h` | Mostra informações de ajuda |
| `--list` `-l` | Lista todos os dispositivos USB disponíveis |

## 📖 Passo a Passo Completo

### 1. Preparação

1. **Conecte seu USB** ao computador
2. **Faça backup** de todos os dados importantes do USB (serão apagados!)
3. **Baixe a ISO do Windows** que deseja usar

### 2. Executando o Script

1. **Inicie o script:**
```bash
./criar_usb_ventoy.sh
```

2. **Identifique seu USB:**
O script mostrará algo como:
```
Dispositivos USB disponíveis:
sdb     14,6G SanDisk USB
sdc     32,0G Kingston DataTraveler
```

3. **Digite o dispositivo:**
```
Digite o dispositivo USB (ex: sdb): sdb
```

4. **Confirme a operação:**
```
ATENÇÃO: Todos os dados em /dev/sdb serão APAGADOS!
Tem certeza que deseja continuar? (s/N): s
```

### 3. Processo Automático

O script irá:
- ✅ Baixar o Ventoy automaticamente
- ✅ Instalar o Ventoy no USB
- ✅ Criar as partições necessárias

### 4. Adicionando ISOs

Após a instalação, você tem duas opções:

#### Opção A: Pelo Script
O script perguntará:
```
Deseja copiar uma ISO do Windows agora? (s/N): s
Digite o caminho completo para a ISO do Windows: /home/usuario/Downloads/Windows11.iso
```

#### Opção B: Manualmente
1. Uma nova unidade "Ventoy" aparecerá no sistema
2. Abra o gerenciador de arquivos
3. Copie suas ISOs diretamente para a unidade Ventoy

### 5. Fazendo Boot

1. **Reinicie o computador** com o USB conectado
2. **Acesse o menu de boot** (geralmente F12, F2, ESC ou Del)
3. **Selecione o USB** da lista
4. **Escolha a ISO** no menu do Ventoy
5. **Prossiga com a instalação** normalmente

## 🔧 Troubleshooting

### Problema: "Dispositivo não encontrado"
```bash
# Listar todos os dispositivos
lsblk

# Verificar dispositivos USB especificamente
./criar_usb_ventoy.sh --list
```

### Problema: "Permissão negada"
```bash
# Verificar se o script tem permissão de execução
ls -la criar_usb_ventoy.sh

# Adicionar permissão se necessário
chmod +x criar_usb_ventoy.sh
```

### Problema: "Ventoy não inicializa"
- Verifique se o **Secure Boot** está desabilitado no BIOS/UEFI
- Certifique-se de que o **UEFI** está habilitado (para Windows 11)
- Tente usar uma **porta USB diferente**

### Problema: "ISO não aparece no menu"
- Verifique se a ISO está na **raiz da unidade Ventoy**
- Certifique-se de que a ISO **não está corrompida**
- Reinicie e tente novamente
