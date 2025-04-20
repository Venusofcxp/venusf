#!/bin/bash

# Caminhos
BASE_DIR="/etc/venuspro"
DB="$BASE_DIR/db/usuarios.db"

# Função: Criar usuário
criar_usuario() {
  clear
  echo "==== Criar Novo Usuário ===="
  read -p "Usuário: " nome
  read -p "Senha: " senha
  read -p "Limite de Conexões: " limite
  read -p "Dias de Validade: " dias

  validade=$(date -d "+$dias days" +"%Y-%m-%d")
  useradd -e $validade -M -s /bin/false $nome
  echo "$nome:$senha" | chpasswd

  echo "$nome:$senha:$limite:$validade" >> "$DB"
  echo "Usuário $nome criado com sucesso!"
  read -p "Aperte Enter para voltar..."
}

# Função: Remover usuário
remover_usuario() {
  clear
  echo "==== Remover Usuário ===="
  read -p "Usuário a remover: " nome
  userdel --force $nome
  sed -i "/^$nome:/d" "$DB"
  echo "Usuário $nome removido!"
  read -p "Aperte Enter para voltar..."
}

# Outras funções (iremos expandir depois)
gerar_teste() {
  echo "Função gerar teste ainda não implementada."
  read -p "Enter para voltar..."
}

# Menu de Gerenciamento de Usuários
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
    echo "| 00 - Sair                                    |"
    echo "------------------------------------------------"
    read -p " --> Selecione uma opção: " opcao

    case $opcao in
      01) criar_usuario ;;
      02) remover_usuario ;;
      03) gerar_teste ;;  # Implementar
      04) echo "Alterar limite (em breve)"; read ;;
      05) echo "Alterar validade (em breve)"; read ;;
      06) echo "Alterar senha (em breve)"; read ;;
      07) echo "Relatório de usuários (em breve)"; read ;;
      08) echo "Relatório de expirados (em breve)"; read ;;
      09) echo "Relatório de conectados (em breve)"; read ;;
      10) echo "Remover expirados (em breve)"; read ;;
      00) break ;;
      *) echo "Opção inválida"; sleep 1 ;;
    esac
  done
}