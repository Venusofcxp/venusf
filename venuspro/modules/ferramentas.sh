#!/bin/bash
BASE_DIR="/etc/venuspro"

# Função para realizar o SpeedTest
speedtest() {
    clear
    echo "======= Realizando SpeedTest ======="
    apt-get install speedtest-cli -y > /dev/null 2>&1
    speedtest-cli --simple
    read -p "Pressione enter para continuar..."
}

# Função para atualizar o script
atualizar_script() {
    clear
    echo "======= Atualizando VENUS PRO ======="
    cd /etc/venuspro || exit
    git pull origin main > /dev/null 2>&1
    echo "Script VENUS PRO atualizado com sucesso!"
    read -p "Pressione enter para continuar..."
}

# Função para reiniciar o servidor
reiniciar_vps() {
    clear
    echo "======= Reiniciando o servidor ======="
    read -p "Tem certeza de que deseja reiniciar? (s/n): " resposta
    if [[ "$resposta" == "s" ]]; then
        reboot
    else
        echo "Reinício cancelado!"
    fi
}

# Função para mostrar informações do sistema
informacoes_sistema() {
    clear
    echo "======= Informações do Sistema ======="
    echo "Sistema Operacional: $(uname -o)"
    echo "Distribuição: $(lsb_release -d | awk -F: '{print $2}')"
    echo "CPU: $(lscpu | grep 'Model name' | awk -F: '{print $2}')"
    echo "Memória RAM: $(free -h | grep Mem | awk '{print $3 " de " $2}')"
    echo "Armazenamento: $(df -h / | grep / | awk '{print $3 " de " $2}')"
    read -p "Pressione enter para continuar..."
}

# Menu de ferramentas
menu_ferramentas() {
    while true; do
        clear
        echo "---------------------------------------------"
        echo "|             Ferramentas do Sistema         |"
        echo "---------------------------------------------"
        echo "| 01 - Realizar SpeedTest                   |"
        echo "| 02 - Atualizar o VENUS PRO                |"
        echo "| 03 - Reiniciar VPS                        |"
        echo "| 04 - Mostrar informações do sistema       |"
        echo "| 00 - Voltar                               |"
        echo "---------------------------------------------"
        read -p " --> Selecione uma opção: " op

        case $op in
            01) speedtest ;;
            02) atualizar_script ;;
            03) reiniciar_vps ;;
            04) informacoes_sistema ;;
            00) break ;;
            *) echo "Opção inválida!"; sleep 1 ;;
        esac
    done
}