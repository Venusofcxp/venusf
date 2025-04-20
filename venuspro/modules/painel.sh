#!/bin/bash
BASE_DIR="/etc/venuspro"
USER_DB="$BASE_DIR/modulos/usuarios.db"

# Funções para obter as informações do sistema

# Função para obter o número de usuários criados
usuarios_criados() {
    local count=$(cat $USER_DB | wc -l)
    echo "$count"
}

# Função para obter o número de usuários online
usuarios_online() {
    local online=$(who | wc -l)  # Contagem de usuários conectados
    echo "$online"
}

# Função para obter o uso de memória RAM
uso_memoria() {
    local total_memoria=$(free -m | grep Mem | awk '{print $2}')
    local usada_memoria=$(free -m | grep Mem | awk '{print $3}')
    local percentual_usado=$(( (usada_memoria * 100) / total_memoria ))
    echo "Total: $total_memoria MB | Usado: $usada_memoria MB | $percentual_usado% em uso"
}

# Função para obter o uso da CPU
uso_cpu() {
    local cpu_usada=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *[0-9.]*%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$cpu_usada% em uso"
}

# Função para exibir o menu do painel
exibir_menu() {
    clear
    echo "================ RustyManager ================="
    echo "------------------------------------------------"
    echo "| OS: $(lsb_release -d | cut -f2-)        | Usuarios Criados: $(usuarios_criados)   |"
    echo "| Versão: $(uname -r)                     | Usuarios Online: $(usuarios_online)    |"
    echo "------------------------------------------------"
    echo "| CPU: $(uso_cpu)                         | RAM: $(uso_memoria)                     |"
    echo "------------------------------------------------"
    echo "| 01 - Gerenciar Usuarios                      |"
    echo "| 02 - Gerenciar Conexões                      |"
    echo "| 03 - Ferramentas                             |"
    echo "| 00 - Sair                                    |"
    echo "------------------------------------------------"
    echo " --> Selecione uma opção:"
}

# Função principal para exibir o painel e permitir interação
exibir_painel() {
    while true; do
        exibir_menu
        read -p "Digite a opção: " opcao
        case $opcao in
            01) source /etc/venuspro/modulos/usuarios.sh ;;
            02) source /etc/venuspro/modulos/conexoes.sh ;;
            03) source /etc/venuspro/modulos/ferramentas.sh ;;
            00) exit 0 ;;
            *) echo "Opção inválida!" ;;
        esac
    done
}

# Iniciar o painel
exibir_painel