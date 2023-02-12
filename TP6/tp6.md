### TP 6 ###

### Module 1 : Reverse Proxy ###

```
[keidko@proxy ~]$ sudo dnf install nginx
```

```
[keidko@proxy ~]$ sudo systemctl start nginx
[keidko@proxy ~]$ sudo systemctl enable nginx 
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service. 
[keidko@proxy ~]$ sudo systemctl status nginx 
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Sat 2023-02-11 10:16:21 CET; 10s ago
    Process: 974 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 975 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 976 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 977 (nginx)
      Tasks: 2 (limit: 5878)
     Memory: 1.9M
        CPU: 15ms
     CGroup: /system.slice/nginx.service
             ├─977 "nginx: master process /usr/sbin/nginx"
             └─978 "nginx: worker process"

Feb 11 10:16:21 proxy.linux.tp6 systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 11 10:16:21 proxy.linux.tp6 nginx[975]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 11 10:16:21 proxy.linux.tp6 nginx[975]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 11 10:16:21 proxy.linux.tp6 systemd[1]: Started The nginx HTTP and reverse proxy server.
```

```
[keidko@proxy ~]$ ss -lapten | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*     ino:19747 sk:1 cgroup:/system.slice/nginx.service <->                          
LISTEN 0      511             [::]:80           [::]:*     ino:19748 sk:4 cgroup:/system.slice/nginx.service v6only:1 <->   
```

```
[keidko@proxy ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[keidko@proxy ~]$ sudo firewall-cmd --reload
success

  ```

  ```
[keidko@proxy ~]$ ps -ef | grep nginx
root         977       1  0 10:17 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx        978     977  0 10:17 ?        00:00:00 nginx: worker process
keidko       1040    787  0 10:17 pts/0    00:00:00 grep --color=auto nginx
```

```
(base) ➜  ~ git:(main) ✗ curl 192.168.64.25 | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   737k      0 --:--:-- --:--:-- --:--:-- 1488k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
```
```
[sudo] password for keidko: 
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```
```
[keidko@proxy nginx]$ sudo cat nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

   # server {
   #     listen       80;
   #     listen       [::]:80;
   #     server_name  _;
   #     root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
   #     include /etc/nginx/default.d/*.conf;

   #     error_page 404 /404.html;
   #     location = /404.html {
   #     }

   #     error_page 500 502 503 504 /50x.html;
   #     location = /50x.html {
   #     }
   # }

# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}
```
```
[keidko@proxy conf.d]$ sudo cat tp6.conf
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp6.linux;

    # Port d'écoute de NGINX
    listen 80;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://192.168.64.23:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```
```
[keidko@proxy etc]$ sudo systemctl restart nginx
[keidko@proxy etc]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Sat 2023-02-11 10:22:48 CET; 15s ago
    Process: 1100 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1101 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1102 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1103 (nginx)
      Tasks: 2 (limit: 5878)
     Memory: 1.9M
        CPU: 17ms
     CGroup: /system.slice/nginx.service
             ├─1103 "nginx: master process /usr/sbin/nginx"
             └─1104 "nginx: worker process"

Feb 11 10:22:48 proxy.linux.tp6 systemd[1]: nginx.service: Deactivated successfully.
Feb 11 10:22:48 proxy.linux.tp6 systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Feb 11 10:22:48 proxy.linux.tp6 systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 11 10:22:48 proxy.linux.tp6 nginx[1101]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 11 10:22:48 proxy.linux.tp6 nginx[1101]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 11 10:22:48 proxy.linux.tp6 systemd[1]: Started The nginx HTTP and reverse proxy server.
```
```
[keidko@web config]$ sudo cat config.php 
<?php
$CONFIG = array (
  'instanceid' => 'ocsuqiy4oixg',
  'passwordsalt' => '+FhHkvQQDnQFeFLQKyfcU6DkMnAn5f',
  'secret' => '48NBAgfHVP+4dFin7s/YDXS7RWxPhxgbBbQCSD5PGqwvsjVT',
  'trusted_domains' => 
  array (
	  0 => 'web.tp6.linux',
  ),
  'datadirectory' => '/var/www/tp5_nextcloud/data',
  'dbtype' => 'mysql',
  'version' => '25.0.0.15',
  'overwrite.cli.url' => 'http://web.tp5.linux',
  'dbname' => 'nextcloud',
  'dbhost' => '192.168.64.24:3306',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'nextcloud',
  'dbpassword' => 'pewpewpew',
  'installed' => true,
);
```
```
(base) ➜  ~ git:(main) ✗ sudo cat /etc/hosts | grep tp6
192.168.64.25 web.tp6.linux
```
```
[keidko@web config]$ sudo firewall-cmd --set-default-zone=drop
success
[keidko@web config]$ sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.64.25" port port="80" protocol="tcp" accept'
success
[keidko@web config]$ sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.64.1" port port="22" protocol="tcp" accept'
[sudo] password for keidko: 
success
[keidko@web config]$ sudo firewall-cmd --reload
success
```
```
(base) ➜  ~ git:(main) ✗ ping 192.168.64.25
PING 192.168.64.25 (192.168.64.25): 56 data bytes
64 bytes from 192.168.64.25: icmp_seq=0 ttl=64 time=1.429 ms
64 bytes from 192.168.64.25: icmp_seq=1 ttl=64 time=0.960 ms
64 bytes from 192.168.64.25: icmp_seq=2 ttl=64 time=1.239 ms
^C
--- 192.168.64.25 ping statistics ---
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.960/1.209/1.429/0.193 ms
(base) ➜  ~ git:(main) ✗ ping 192.168.64.23
PING 192.168.64.23 (192.168.64.23): 56 data bytes
Request timeout for icmp_seq 0
Request timeout for icmp_seq 1
Request timeout for icmp_seq 2
^C
```
```
[keidko@proxy nginx]$ sudo mkdir certs
[sudo] password for keidko: 
```
```
[keidko@proxy certs]$ sudo openssl genrsa -out ssl_certificate.key 2048
[keidko@proxy certs]$ sudo openssl req -new -x509 -key ssl_certificate.key -out ssl_certificate.crt -days 365
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:FR
State or Province Name (full name) []:.
Locality Name (eg, city) [Default City]:.
Organization Name (eg, company) [Default Company Ltd]:.
Organizational Unit Name (eg, section) []:.
Common Name (eg, your name or your server's hostname) []:proxy.linux.tp6
Email Address []:.
[keidko@proxy certs]$ ls
ssl_certificate.crt  ssl_certificate.key
```
```
[keidko@proxy conf.d]$ sudo cat tp6.conf 
[sudo] password for keidko: 
server {
    listen 80;
    server_name web.tp6.linux;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name web.tp6.linux;
    ssl_certificate /etc/nginx/certs/ssl_certificate.crt;
    ssl_certificate_key /etc/nginx/certs/ssl_certificate.key;
    
	location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying
        proxy_pass http://192.168.64.23:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```
```
[keidko@proxy conf.d]$ sudo systemctl restart nginx
[keidko@proxy conf.d]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2023-01-16 10:30:43 CET; 11s ago
    Process: 1282 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1283 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1284 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1285 (nginx)
      Tasks: 2 (limit: 5878)
     Memory: 2.6M
        CPU: 26ms
     CGroup: /system.slice/nginx.service
             ├─1285 "nginx: master process /usr/sbin/nginx"
             └─1286 "nginx: worker process"

Feb 11 10:30:43 proxy.linux.tp6 systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 11 10:30:43 proxy.linux.tp6 nginx[1283]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 11 10:30:43 proxy.linux.tp6 nginx[1283]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 11 10:30:43 proxy.linux.tp6 systemd[1]: Started The nginx HTTP and reverse proxy server.
```
```
[keidko@proxy conf.d]$ sudo firewall-cmd --add-port=443/tcp --permanent 
success
[keidko@proxy conf.d]$ sudo firewall-cmd --reload
success
```
### Module 2 : Sauvegarde du système de fichiers ###
```
[keidko@web srv]$ sudo dnf install rsync
[keidko@web srv]$ sudo dnf install zip
```
```
[keidko@web srv]$ sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.64.24" port port="3306" protocol="tcp" accept'
success
[keidko@web srv]$ sudo firewall-cmd --reload
success
```
```
[keidko@web srv]$ sudo mkdir backup
```

```
[keidko@web srv]$ sudo useradd backup -d /srv/backup/ -s /usr/bin/nologin -u 1999
useradd: Warning: missing or non-executable shell '/usr/bin/nologin'
useradd: warning: the home directory /srv/backup/ already exists.
useradd: Not copying any file from skel directory into it.
[keidko@web srv]$ sudo chown backup /srv/backup/
[keidko@web srv]$ ls -l
total 4
drwxr-xr-x. 2 backup root  43 Feb 11 10:34 backup
-rw-r--r--. 1 root   root 579 Feb 11 10:34 tp6_backup.sh
```
```
[keidko@web srv]$ sudo cat tp6_backup.sh 
#!/bin/bash

#11/02/2023
#Mariamon William 
backup_directory=/srv/backup/nextcloud-dirbkp_`date +"%Y%m%d"`

rsync -Aavx /var/www/tp5_nextcloud/ $backup_directory/

mysqldump --skip-column-statistics --single-transaction --default-character-set=utf8mb4 -h 192.168.64.24 -u nextcloud -ppewpewpew nextcloud > $backup_directory/nextcloud-sqlbkp_`date +"%Y%m%d"`.bak

zip -r $backup_directory.zip $backup_directory

rm -rf $backup_directory
#le script sert à crée une sauvegarde de toute les données de nextcloud.
```
```
[keidko@web system]$ sudo cat backup.service 
[Unit]
Description=Backup service

[Service]
ExecStart=sh /srv/tp6_backup.sh
User=backup
Type=oneshot
```
```
[keidko@web system]$ sudo cat backup.timer 
[Unit]
Description=Run service X

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
```
```
[keidko@web system]$ sudo systemctl daemon-reload
[keidko@web system]$ sudo systemctl start backup.timer
[keidko@web system]$ sudo systemctl enable backup.timer
Created symlink /etc/systemd/system/timers.target.wants/backup.timer → /etc/systemd/system/backup.timer.
[keidko@web system]$ sudo systemctl status backup.timer
```
```
[keidko@storage ~]$ sudo mkdir /srv/nfs_shares
[sudo] password for keidko: 
[keidko@storage ~]$ sudo mkdir /srv/nfs_shares/web.tp6.linux/
```

```
[keidko@storage ~]$ sudo dnf install nfs-utils
```
```
[keidko@storage ~]$ sudo chown nobody /srv/nfs_shares/web.tp6.linux/
```

```
[keidko@storage nfs_shares]$ sudo cat /etc/exports
/srv/nfs_shares/web.tp6.linux 192.168.64.23(rw,sync,no_subtree_check,no_root_squash)
```

```
[keidko@storage nfs_shares]$ sudo firewall-cmd --permanent --add-service=nfs
success
[keidko@storage nfs_shares]$ sudo firewall-cmd --permanent --add-service=mountd
success
[keidko@storage nfs_shares]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[keidko@storage nfs_shares]$ sudo firewall-cmd --reload
success
```
```
[keidko@storage nfs_shares]$ sudo systemctl enable nfs-server
[keidko@storage nfs_shares]$ sudo systemctl start nfs-server
```

```
[keidko@web system]$ sudo dnf install nfs-utils
```
```
[keidko@web system]$ sudo mount 192.168.64.26:/srv/nfs_shares/web.tp6.linux/ /srv/backup/
[keidko@web system]$ df -h | grep tp6
192.168.64.26:/srv/nfs_shares/web.tp6.linux  5.6G  1.2G  4.5G  21% /srv/backup
```

```
[keidko@web srv]$ sudo cat /etc/fstab | grep tp6
192.168.64.26:/srv/nfs_shares/web.tp6.linux /srv/backup nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

```
[keidko@web backup]$ sudo unzip nextcloud-dirbkp_20230117.zip
```

```
[keidko@web nextcloud-dirbkp_20230117]$ sudo mv nextcloud-sqlbkp_20230117.bak /srv/backup/
[keidko@web backup]$ sudo mv nextcloud-dirbkp_20230117/ /srv/backup/
```
```
[keidko@web backup]$ sudo rsync -Aax nextcloud-dirbkp_20230117 nextcloud/
```
```
[keidko@web backup]$ mysql -h 192.168.64.24 -u nextcloud -ppewpewpew -e "DROP DATABASE nextcloud"
mysql: [Warning] Using a password on the command line interface can be insecure.
[keidko@web backup]$ mysql -h 192.168.64.24 -u nextcloud -ppewpewpew -e "CREATE DATABASE nextcloud"
mysql: [Warning] Using a password on the command line interface can be insecure.
[keidko@web backup]$ mysql -h 192.168.64.24 -u nextcloud -ppewpewpew nextcloud < nextcloud-sqlbkp_20230117.bak 
mysql: [Warning] Using a password on the command line interface can be insecure.
```
tp non terminer.