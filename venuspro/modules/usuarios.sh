#!/bin/bash
BASE_DIR="/etc/venuspro"
DB_USUARIOS="$BASE_DIR/dados/usuarios.db"

criar_usuario() {
    clear
    echo "======== Criar Novo Usuário ========"
    read -p "Nome do usuário: " nome
    read -p "Senha: " senha
    read -p "Limite de conexões: " limite
    read -p "Dias de validade: " dias

    expiracao=$(date -d "+$dias days" +"%Y-%m-%d")
    useradd -e $expiracao -M -s /bin/false $nome
    echo "$nome:$senha" | chpasswd

    echo "$nome|$senha|$limite|$expiracao" >> $DB_USUARIOS
    echo "Usuário criado com sucesso!"
    read -p "Pressione enter para continuar..."
}

remover_usuario() {
    clear
    echo "======== Remover Usuário ========"
    read -p "Nome do usuário: " nome
    userdel -f $nome
    sed -i "/^$nome|/d" $DB_USUARIOS
    echo "Usuário removido com sucesso!"
    read -p "Pressione enter para continuar..."
}

gerar_teste() {
    nome="teste$RANDOM"
    senha="123"
    limite=1
    expiracao=$(date -d "+1 day" +"%Y-%m-%d")
    useradd -e $expiracao -M -s /bin/false $nome
    echo "$nome:$senha" | chpasswd
    echo "$nome|$senha|$limite|$expiracao" >> $DB_USUARIOS
    echo "Usuário de teste criado:"
    echo "Login: $nome | Senha: $senha | Expira: $expiracao"
    read -p "Pressione enter para continuar..."
}

alterar_limite() {
    clear
    echo "======== Alterar Limite de Conexão ========"
    read -p "Usuário: " nome
    read -p "Novo limite: " novo
    sed -i "s/^$nome|[^|]*|[^|]*|/$nome|\1|$novo|/" $DB_USUARIOS
    echo "Limite atualizado."
    read -p "Pressione enter para continuar..."
}

alterar_validade() {
    clear
    echo "======== Alterar Validade do Usuário ========"
    read -p "Usuário: " nome
    read -p "Novos dias: " dias
    nova_data=$(date -d "+$dias days" +"%Y-%m-%d")
    chage -E $nova_data $nome
    sed -i "s/^$nome|[^|]*|[^|]*|.*/$nome|\1|\2|$nova_data/" $DB_USUARIOS
    echo "Validade atualizada para $nova_data"
    read -p "Pressione enter para continuar..."
}

alterar_senha() {
    clear
    echo "======== Alterar Senha ========"
    read -p "Usuário: " nome
    read -p "Nova senha: " senha
    echo "$nome:$senha" | chpasswd
    sed -i "s/^$nome|[^|]*|/$nome|$senha|/" $DB_USUARIOS
    echo "Senha atualizada."
    read -p "Pressione enter para continuar..."
}

relatorio_usuarios() {
    clear
    echo "======== Relatório de Usuários ========"
    cat $DB_USUARIOS | column -t -s '|'
    read -p "Pressione enter para continuar..."
}

relatorio_expirados() {
    clear
    echo "======== Usuários Expirados ========"
    hoje=$(date +%Y-%m-%d)
    awk -F'|' -v data="$hoje" '$4 < data' $DB_USUARIOS | column -t -s '|'
    read -p "Pressione enter para continuar..."
}

relatorio_conectados() {
    clear
    echo "======== Usuários Conectados ========"
    who | awk '{print $1}' | sort | uniq
    read -p "Pressione enter para continuar..."
}

remover_expirados() {
    clear
    echo "======== Remover Usuários Expirados ========"
    hoje=$(date +%Y-%m-%d)
    for user in $(awk -F'|' -v data="$hoje" '$4 < data {print $1}' $DB_USUARIOS); do
        userdel -f $user
        sed -i "/^$user|/d" $DB_USUARIOS
        echo "Removido: $user"
    done
    read -p "Pressione enter para continuar..."
}

menu_usuarios() {
    while true; do
        clear
        echo "------------------------------------------------"
        echo "|              Gerenciar Usuarios              |"
        echo "------------------------------------------------"
        echo "| 01 - Criar usuario                           |"
        echo "| 02 - Remover usuario                         |"
        echo "| 03 - Gerar teste                             |"
        echo "| 04 - Alterar limite                          |"
        echo "| 05 - Alterar validade                        |"
        echo "| 06 - Alterar senha                           |"
        echo "| 07 - Relatorio de usuarios                   |"
        echo "| 08 - Relatorio de expirados                  |"
        echo "| 09 - Relatorio de conectados                 |"
        echo "| 10 - Remover expirados                       |"
        echo "| 00 - Voltar                                  |"
        echo "------------------------------------------------"
        read -p " --> Selecione uma opção: " op

        case $op in
            01) criar_usuario ;;
            02) remover_usuario ;;
            03) gerar_teste ;;
            04) alterar_limite ;;
            05) alterar_validade ;;
            06) alterar_senha ;;
            07) relatorio_usuarios ;;
            08) relatorio_expirados ;;
            09) relatorio_conectados ;;
            10) remover_expirados ;;
            00) break ;;
            *) echo "Opção inválida!"; sleep 1 ;;
        esac
    done
}