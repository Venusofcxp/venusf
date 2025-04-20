#!/bin/bash

# Caminhos base
BASE_DIR="/etc/venuspro"
FUNCOES="$BASE_DIR/funcoes.sh"
MOD_USUARIOS="$BASE_DIR/modules/usuarios.sh"
MOD_CONEXOES="$BASE_DIR/modules/conexoes.sh"
MOD_FERRAMENTAS="$BASE_DIR/modules/ferramentas.sh"
DB_USUARIOS="$BASE_DIR/db/usuarios.db"

# Carrega funções reutilizáveis
source $FUNCOES

while true; do
  clear
  ONLINE=$(usuarios_online)
  VENCIDOS=$(usuarios_expirados)
  TOTAL_USUARIOS=$(total_usuarios)
  RAM_TOTAL=$(memoria_total)
  RAM_USO=$(memoria_usada)
  CPU_NUCLEOS=$(nproc)
  CPU_USO=$(cpu_usada)
  OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
  VERSAO=$(awk -F= '/^VERSION_ID/{print $2}' /etc/os-release | tr -d '"')

  echo -e "\n================ \033[1;33mRustyManager\033[0m ================ "
  echo -e "------------------------------------------------"
  printf "| Os: %-16s | Usuarios Criados: %-4s |\n" "$OS" "$TOTAL_USUARIOS"
  printf "| Versão: %-12s | Usuarios Online: %-4s  |\n" "$VERSAO" "$ONLINE"
  echo    "-----------------------|------------------------"
  printf "| CPU:                 | Ram:                  |\n"
  printf "|  - Núcleos: %-7s     |  - Total: %-10s |\n" "$CPU_NUCLEOS" "$RAM_TOTAL"
  printf "|  - Em uso: %-7s%%     |  - Em uso: %-10s |\n" "$CPU_USO" "$RAM_USO"
  echo -e "------------------------------------------------"
  echo -e "| \033[1;37m[01]\033[0m - Gerenciar Usuarios                      |"
  echo -e "| \033[1;37m[02]\033[0m - Gerenciar Conexões                      |"
  echo -e "| \033[1;37m[03]\033[0m - Ferramentas                             |"
  echo -e "| \033[1;37m[00]\033[0m - Sair                                    |"
  echo -e "------------------------------------------------"
  echo -ne " --> Selecione uma opção: "; read opcao

  case $opcao in
    1 | 01) bash $MOD_USUARIOS ;;
    2 | 02) bash $MOD_CONEXOES ;;
    3 | 03) bash $MOD_FERRAMENTAS ;;
    0 | 00) exit 0 ;;
    *) echo -e "\n\033[1;31m[!] Opção inválida!\033[0m"; sleep 2 ;;
  esac
done>