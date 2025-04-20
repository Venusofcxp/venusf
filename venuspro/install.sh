#!/bin/bash

# ===============================
#  VÊNUS  PRO - INSTALLER
# ===============================

echo -e "\n\033[1;32m[+] Iniciando instalação do Venuspro...\033[0m"

# Diretório base do painel
PASTA_BASE="/etc/venuspro"

# Clonar repositório do GitHub
echo -e "\n\033[1;34m[*] Baixando arquivos do repositório...\033[0m"
rm -rf /tmp/venuspro
git clone https://github.com/Venusofcxp/venusf /tmp/venuspro > /dev/null 2>&1

# Verificar se clonagem foi bem-sucedida
if [ ! -d "/tmp/venuspro" ]; then
    echo -e "\033[1;31m[✖] Falha ao clonar repositório. Verifique a URL.\033[0m"
    exit 1
fi

# Criar estrutura de pastas
mkdir -p $PASTA_BASE/modules
mkdir -p $PASTA_BASE/db
mkdir -p $PASTA_BASE/logs

# Mover arquivos principais
cp /tmp/venuspro/menu.sh $PASTA_BASE/
cp /tmp/venuspro/funcoes.sh $PASTA_BASE/
cp /tmp/venuspro/modules/usuarios.sh $PASTA_BASE/modules/
cp /tmp/venuspro/modules/conexoes.sh $PASTA_BASE/modules/
cp /tmp/venuspro/modules/ferramentas.sh $PASTA_BASE/modules/

# Criar banco de dados inicial
touch $PASTA_BASE/db/usuarios.db

# Dar permissões de execução
chmod +x $PASTA_BASE/*.sh
chmod +x $PASTA_BASE/modules/*.sh

# Instalar dependências mínimas
echo -e "\n\033[1;34m[*] Instalando dependências básicas...\033[0m"
apt-get update -y > /dev/null 2>&1
apt-get install -y bc net-tools curl git > /dev/null 2>&1

# Instalar Speedtest CLI da Ookla
echo -e "\n\033[1;34m[*] Instalando Speedtest (ookla)...\033[0m"
apt-get install -y gnupg1 apt-transport-https dirmngr curl > /dev/null 2>&1
export INSTALL_KEY=379CE192D401AB61
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash > /dev/null 2>&1
apt-get install speedtest -y > /dev/null 2>&1

# Verificação do speedtest
if command -v speedtest > /dev/null; then
    echo -e "\033[1;32m[✔] Speedtest instalado com sucesso!\033[0m"
else
    echo -e "\033[1;31m[✖] Falha ao instalar o Speedtest.\033[0m"
fi

# Criar atalho global para o comando 'menu'
ln -sf $PASTA_BASE/menu.sh /usr/bin/menu
chmod +x /usr/bin/menu

# Mensagem final e execução automática do menu
echo -e "\n\033[1;32m[✔] Instalação concluída!\033[0m"
echo -e "\033[1;37mPara iniciar o painel, digite:\033[0m \033[1;33mmenu\033[0m"
echo -e "\033[1;34mIniciando painel...\033[0m"
sleep 2
menu
