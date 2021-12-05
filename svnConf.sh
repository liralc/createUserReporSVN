#!/usr/bin/env bash
#
# svnConf.sh - Configuração do SVN
#
# E-mail:     liralc@gmail.com
# Autor:      Anderson Lira
# Manutenção: Anderson Lira
#
# ************************************************************************** #
#  Este programa faz a criação de repositóriso e configuração de usuários e senhas
#  do projeto no SubversionSVN.
#
#  Exemplos:
#      $ ./svnConf.sh
#
# ************************************************************************** #
# Histórico:
#
#   v1.0 18/05/2021, Anderson Lira:
#       - Início do programa.
# ************************************************************************** #
# Testado em:
#   bash 5.0.3
#   Debian 10.9
# ************************************************************************** #

# ======== VARIAVEIS ============================================================== #
REPOSITORIOS=/srv/versionamento/svn
USUARIOS="usuarios"
# =================================================================================== #

# ======= FUNCAO ==================================================================== #
IncluirUsuarios () {
  while read -r linha
  do
    [ "$(echo $linha | cut -c1)" = "#" ] && continue
    [ ! "$linha" ] && continue

    echo "$linha" >> $PROJETO/conf/passwd
  done < "$USUARIOS"
}
# =================================================================================== #

# ======== TESTES =================================================================== #
if [ $(echo $UID) -ne 0 ]
then
    echo "
    Você deve está com privilégios de ROOT para continuar com esse programa.
    "
    exit 1
fi
# =================================================================================== #

# ======== EXECUCAO ================================================================= #
read -p "Informo o nome do projeto: " PROJETO
svnadmin create $REPOSITORIOS/$PROJETO
svn mkdir file://$REPOSITORIOS/$PROJETO/{trunk,branches,tags} -m "Estrutura inicial de diretorio $PROJETO."
sed -i -e 's/# password-db = passwd/password-db = passwd/' $PROJETO/conf/svnserve.conf
IncluirUsuarios
#==================================================================================== #