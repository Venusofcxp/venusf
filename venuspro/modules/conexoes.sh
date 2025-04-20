#!/bin/bash
BASE_DIR="/etc/venuspro"

abrir_porta() {
    clear
    echo "======= Abrir Porta Manualmente ======="
    read -p "Digite a porta que deseja abrir: " porta
    iptables -I INPUT -p tcp --dport $porta -j ACCEPT
    iptables-save > /etc/iptables.rules
    echo "Porta $porta aberta com sucesso!"
    read -p "Pressione enter para continuar..."
}

instalar_websocket() {
    clear
    echo "======= Instalando WebSocket Python ======="
    apt-get install python3 screen -y > /dev/null 2>&1
    wget -O /etc/venuspro/ws.py https://raw.githubusercontent.com/fnool/ws/main/ws.py > /dev/null 2>&1
    chmod +x /etc/venuspro/ws.py
    screen -dmS websocket python3 /etc/venuspro/ws.py 80
    echo "WebSocket iniciado na porta 80"
    read -p "Pressione enter para continuar..."
}

status_portas() {
    clear
    echo "======= Portas Ativas ======="
    ss -tunlp | grep -E '80|443|8080|22'
    read -p "Pressione enter para continuar..."
}

menu_conexoes() {
    while true; do
        clear
        echo "--------------------------------------------"
        echo "|        Gerenciar Modos de Conexão        |"
        echo "--------------------------------------------"
        echo "| 01 - Abrir porta manualmente             |"
        echo "| 02 - Instalar modo WebSocket             |"
        echo "| 03 - Ver status de portas abertas        |"
        echo "| 00 - Voltar                              |"
        echo "--------------------------------------------"
        read -p " --> Selecione uma opção: " op

        case $op in
            01) abrir_porta ;;
            02) instalar_websocket ;;
            03) status_portas ;;
            00) break ;;
            *) echo "Opção inválida!"; sleep 1 ;;
        esac
    done
}
