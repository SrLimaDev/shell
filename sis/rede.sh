#!/usr/bin/env bash
#
# FUNÇÕES DE REDE [ GNU/LINUX ]
#
# @author Fernando Lima <fernando@ipis.dev.br>
# @data 2024-02-25 10:15 UTC-3
# @versao 0.1
# @dependencias: nmcli, net-tools
#


###########
# FUNCOES #
###########


#
# Identifica a INET ativa
#
function rede_inet() {
    local rt=`nmcli device | grep 'ether' | cut -d: -f1 | awk '{ print $1 }'`
    echo "$rt"
}

#
# Identifica os ENDEREÇOS da INET
#
function rede_inet_getEnderecos() {
    local rt=`ifconfig $(rede_inet) | grep 'inet '` # | cut -d: -f5 | awk { print $1 }`
    ##### rt=`ip -h -o -c -f inet -4 addr list $(rede_inetNome)`
    echo "$rt"
}

#
# Retorna os endereços IP's da INET
#
function rede_get_endereco() {

    local inet=$(rede_inet)
    local inet_ips=$(rede_inet_getEnderecos)

    local ip=`echo $inet_ips | cut -d: -f5 | awk '{ print $2}'`
    local mascara=`echo $inet_ips | awk '{ print $4}'`
    local enderecos=( $ip $mascara )

    local rt="$enderecos[1]" # Retorno padrão é o ip
    case "$1" in
        # IP
        ip|addr|a) rt="$enderecos[1]" ;;
        # Mascara da rede
        masc|mascara|m) rt="$enderecos[2]" ;;
        # Matriz
        arr) rt="$enderecos[@]" ;;
    esac

    echo "$rt"
}

#
# Teste de conexão com a internet
#
function rede_internet() {
	if ! ping -q -c 1 "8.8.8.8" -q &>/dev/null; then
		return 1
	else
        return 0
	fi
}
