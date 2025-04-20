#!/bin/bash
BASE_DIR="/etc/venuspro"
LOG_DIR="$BASE_DIR/logs"
ACTION_LOG="$LOG_DIR/action.log"
ERROR_LOG="$LOG_DIR/error.log"
ACCESS_LOG="$LOG_DIR/access.log"

# Função para garantir que o diretório de logs exista
criar_diretorio_logs() {
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
    fi
}

# Função para registrar ações no arquivo de log
registrar_acao() {
    local acao=$1
    local usuario=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') | Ação: $acao | Usuário: $usuario" >> $ACTION_LOG
}

# Função para registrar erros no arquivo de log de erros
registrar_erro() {
    local erro=$1
    local usuario=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') | ERRO: $erro | Usuário: $usuario" >> $ERROR_LOG
}

# Função para registrar acessos no arquivo de log de acessos
registrar_acesso() {
    local usuario=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') | Acesso: $usuario" >> $ACCESS_LOG
}

# Função para exibir o log de ações
exibir_log_acoes() {
    echo "Log de Ações:"
    cat $ACTION_LOG
}

# Função para exibir o log de erros
exibir_log_erros() {
    echo "Log de Erros:"
    cat $ERROR_LOG
}

# Função para exibir o log de acessos
exibir_log_acessos() {
    echo "Log de Acessos:"
    cat $ACCESS_LOG
}
