# Script para Criação de USB Bootável com Ventoy

Script que automatiza a criação de um USB bootável usando o Ventoy, permitindo ter múltiplas ISOs (Windows, Linux, etc.) em um único dispositivo USB.

## Pré-requisitos

### Sistema
- Linux (Ubuntu, Debian, Fedora, etc.)
- Acesso sudo
- USB com pelo menos 8GB

### Dependências
```bash
# Ubuntu/Debian
sudo apt install wget tar util-linux

# Fedora/CentOS
sudo dnf install wget tar util-linux

# Arch Linux
sudo pacman -S wget tar util-linux
```

## Instalação

1. **Baixe o script:**
```bash
wget https://raw.githubusercontent.com/seu-usuario/ventoy-usb-script/main/criar_usb_ventoy.sh
```

2. **Torne executável:**
```bash
chmod +x criar_usb_ventoy.sh
```

## Uso

### Uso básico
```bash
./criar_usb_ventoy.sh
```

### Listar dispositivos USB
```bash
./criar_usb_ventoy.sh --list
```

## Passo a Passo

1. **Execute o script:**
```bash
./criar_usb_ventoy.sh
```

2. **Selecione o dispositivo USB:**
```
Dispositivos USB disponíveis:
sdb     14,6G SanDisk USB
Digite o dispositivo USB (ex: sdb): sdb
```

3. **Confirme a operação:**
```
ATENÇÃO: Todos os dados em /dev/sdb serão APAGADOS!
Tem certeza que deseja continuar? (s/N): s
```

4. **Adicione ISOs:**
   - O script pode copiar uma ISO automaticamente, ou
   - Copie manualmente para a unidade "Ventoy" que aparecerá

5. **Para fazer boot:**
   - Reinicie com o USB conectado
   - Selecione o USB no menu de boot
   - Escolha a ISO desejada no menu do Ventoy

## Troubleshooting

- **Ventoy não inicializa**: Desabilite Secure Boot no BIOS
- **ISO não aparece**: Verifique se está na raiz da unidade Ventoy
- **Erro de permissão**: Execute `chmod +x criar_usb_ventoy.sh`

⚠️ **Importante**: Todos os dados do USB serão apagados. Faça backup antes de usar!
