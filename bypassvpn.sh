#!/bin/bash
#for OSX
set -u

usage() {
    echo Usage: bypass all China IPs got from apnic
    echo "    $0 ALL"
    echo Usage: bypass specfic hosts
    echo "    $0 douban.fm baidu.com"
    exit 1
}

if [ $# -lt 1 ];then
    usage
fi

function dnsToIPs() {
    ips=`dig +noall +answer $1 | awk '$4=="A" {print $5}'`
    echo $ips
}

gw=`netstat -rn | grep  default | grep -v utun | awk '{print $2}' 2>/dev/null`

if [ "$1" = "ALL" ];then
    ips=`curl -s http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest | awk -F '|' '$2 == "CN" && $3 == "ipv4" && $7 == "allocated" { printf "%s/%d\n",$4,32-log($5)/log(2) }'`
    for ip in $ips; do
        echo -n "set routing: $ip to $gw ..."
        if route -nv add $ip $gw >/dev/null 2>&1; then
            echo "ok"
        else
            echo "failed"
        fi
    done
else
    for dns in "$@";do
        for ip in `dnsToIPs $dns`; do
            echo -n "set routing: $dns($ip) to $gw ..."
            if route -nv add $ip $gw >/dev/null 2>&1; then
                echo "ok"
            else
                echo "failed"
            fi
        done
    done
fi
