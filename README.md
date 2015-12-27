# bypassvpn
scripts to bypass region IPs from vpn link, means routing to default local gateway.

- bypass all China IPs, IPs got from http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest
 ```
 $sudo bypassvpn.sh ALL
 ```

- bypass vpn for specfic hosts
 usage:
 ```
 $sudo bypassvpn.sh douban.fm www.baidu.com
 ```
