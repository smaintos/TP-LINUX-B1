# TP2 ENVIRONNEMENT LINUX.

### I.Service SSH

**1. Analyse du service**

**🌞 S'assurer que le service sshd est démarré**

```
[smaintos@LITP2 ~]$ systemctl status
● LITP2
    State: degraded
     Jobs: 0 queued
   Failed: 1 units
    Since: Mon 2022-12-05 12:38:31 CET; 58min left
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 30
           ├─system.slice
           │ ├─NetworkManager.service
           │ │ └─681 /usr/sbin/NetworkManager --no-daemon
           │ ├─auditd.service
           │ │ └─609 /sbin/auditd
           │ ├─chronyd.service
           │ │ └─658 /usr/sbin/chronyd -F 2
           │ ├─crond.service
           │ │ └─698 /usr/sbin/crond -n
           │ ├─dbus-broker.service
           │ │ ├─664 /usr/bin/dbus-broker-launch --scope system --audit
           │ │ └─668 dbus-broker --log 4 --controller 9 --machine-id 5cc712c69c2b4a09940cbf705ee072eb --max-bytes 536870912 --max-fds 4096 --max-matches 131072 --audit
           │ ├─firewalld.service
           │ │ └─643 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
           │ ├─irqbalance.service
           │ │ └─644 /usr/sbin/irqbalance --foreground
           │ ├─polkit.service
           │ │ └─755 /usr/lib/polkit-1/polkitd --no-debug
           │ ├─rsyslog.service
           │ │ └─645 /usr/sbin/rsyslogd -n
           │ ├─sshd.service
           │ │ └─691 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─system-serial\x2dgetty.slice
           │ │ └─serial-getty@ttyAMA0.service
           │ │   └─702 /sbin/agetty -o "-p -- \\u" --keep-baud 115200,57600,38400,9600 - vt220
           │ ├─systemd-journald.service
           │ │ └─559 /usr/lib/systemd/systemd-journald
           │ ├─systemd-logind.service
           │ │ └─649 /usr/lib/systemd/systemd-logind
           │ └─systemd-udevd.service
           │   └─572 /usr/lib/systemd/systemd-udevd
           └─user.slice
             └─user-1000.slice
               ├─session-1.scope
               │ ├─700 "login -- smaintos"
               │ ├─799 -bash
               │ ├─846 systemctl status
               │ └─847 less
               ├─session-3.scope
               │ ├─823 "sshd: smaintos [priv]"
               │ ├─827 "sshd: smaintos@pts/0"
               │ ├─828 -bash
               │ ├─850 systemctl status
               │ └─851 less
               └─user@1000.service
                 └─init.scope
                   ├─790 /usr/lib/systemd/systemd --user
                   └─792 "(sd-pam)"
```

**🌞 Analyser les processus liés au service SSH**

```
[smaintos@LITP2 ~]$ systemctl status | grep sshd
           │ ├─sshd.service
           │ │ └─691 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
               │ ├─823 "sshd: smaintos [priv]"
               │ ├─827 "sshd: smaintos@pts/0"
               │ └─877 grep --color=auto sshd**
```

**🌞 Déterminer le port sur lequel écoute le service SSH**
```

[smaintos@LITP2 ~]$ ss -n |grep tcp
tcp   ESTAB  0      0                    192.168.64.10:22    192.168.64.1:49671  
```

**🌞 Consulter les logs du service SSH**

```
[smaintos@LITP2 log]$ sudo tail -n 10 secure
Dec  5 11:38:24 LITP2 login[700]: pam_unix(login:session): session opened for user smaintos(uid=1000) by (uid=0)
Dec  5 11:38:24 LITP2 login[700]: LOGIN ON tty1 BY smaintos
Dec  5 11:38:57 LITP2 sshd[823]: Accepted password for smaintos from 192.168.64.1 port 49384 ssh2
Dec  5 11:38:57 LITP2 sshd[823]: pam_unix(sshd:session): session opened for user smaintos(uid=1000) by (uid=0)
Dec  5 12:24:16 LITP2 sudo[914]: smaintos : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cd sssd
Dec  5 12:24:16 LITP2 sudo[914]: pam_unix(sudo:session): session opened for user root(uid=0) by smaintos(uid=1000)
Dec  5 12:24:16 LITP2 sudo[914]: pam_unix(sudo:session): session closed for user root
Dec  5 12:25:05 LITP2 sudo[921]: smaintos : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cat secure
Dec  5 12:25:05 LITP2 sudo[921]: pam_unix(sudo:session): session opened for user root(uid=0) by smaintos(uid=1000)
Dec  5 12:25:05 LITP2 sudo[921]: pam_unix(sudo:session): session closed for user root
```

**2. Modification du service**

**🌞 Identifier le fichier de configuration du serveur SSH**

```
[smaintos@LITP2 ssh]$ ls
moduli  ssh_config  ssh_config.d  sshd_config  sshd_config.d  ssh_host_ecdsa_key  ssh_host_ecdsa_key.pub  ssh_host_ed25519_key  ssh_host_ed25519_key.pub  ssh_host_rsa_key  ssh_host_rsa_key.pub
```
'ssh_config'

**🌞 Modifier le fichier de conf**

```
[smaintos@LITP2 ssh]$ echo $RANDOM
27443
```

```
[smaintos@LITP2 ssh]$ sudo cat sshd_config | grep Port
[sudo] password for smaintos: 
Port 27443
```

**🌞 Redémarrer le service**

```
[smaintos@LITP2 ssh]$ systemctl restart sshd
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ====
Authentication is required to restart 'sshd.service'.
Authenticating as: smaintos
Password: 
==== AUTHENTICATION COMPLETE ====
[smaintos@LITP2 ssh]$ 
```

**🌞 Effectuer une connexion SSH sur le nouveau port**

```
➜  ~ git:(main) ✗ ssh smaintos@192.168.64.10 -p 27443
smaintos@192.168.64.10's password: 
Last login: Tue Dec  6 11:06:25 2022
[smaintos@LITP2 ~]$ 
```
--------
### I.Service HTTP

**1. Mise en place**

**🌞 Installer le serveur NGINX**

```
sudo dnf upgrade --refresh

sudo dnf install nginx -y
```

**🌞 Démarrer le service NGINX**

`sudo systemctl enable nginx --now`

**🌞 Déterminer sur quel port tourne NGINX**

```
sudo firewall-cmd --permanent --zone=public --add-service=https

sudo firewall-cmd --permanent --zone=public --add-port=80/tcp

[smaintos@LITP2 ssh]$ sudo firewall-cmd --list-all
[sudo] password for smaintos: 
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s1
  sources: 
  services: cockpit dhcpv6-client https ssh
  ports: 27443/tcp 80/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```
**🌞 Déterminer les processus liés à l'exécution de NGINX**

```
[smaintos@LITP2 ssh]$ ps aux | grep nginx
root       21926  0.0  0.0   9644   908 ?        Ss   11:35   0:00 nginx: master process /usr/sbin/nginx
nginx      21927  0.0  0.4  13624  4424 ?        S    11:35   0:00 nginx: worker process
nginx      21928  0.0  0.5  13624  5228 ?        S    11:35   0:00 nginx: worker process
nginx      21929  0.0  0.4  13624  4484 ?        S    11:35   0:00 nginx: worker process
nginx      21930  0.0  0.4  13624  4484 ?        S    11:35   0:00 nginx: worker process
smaintos   22033  0.0  0.1   6112  1816 pts/0    S+   12:11   0:00 grep --color=auto nginx
```

**🌞 Euh wait**

```
➜  ~ git:(main) ✗ curl http://192.168.64.10/ | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   780k      0 --:--:-- --:--:-- --:--:-- 2480k
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

**2. Analyser la conf de NGINX**

**🌞 Déterminer le path du fichier de configuration de NGINX**

```
[smaintos@LITP2 ~]$ cd /etc/nginx/
[smaintos@LITP2 nginx]$ ls
conf.d     fastcgi.conf          fastcgi_params          koi-utf  mime.types          nginx.conf          scgi_params          uwsgi_params          win-utf
default.d  fastcgi.conf.default  fastcgi_params.default  koi-win  mime.types.default  nginx.conf.default  scgi_params.default  uwsgi_params.default
```

**🌞 Trouver dans le fichier de conf**

```
[smaintos@LITP2 nginx]$ sudo cat nginx.conf | grep server -A 16
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

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
[smaintos@LITP2 nginx]$ sudo cat nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

**3. Déployer un nouveau site web**

**🌞 Créer un site web**

```
[smaintos@LITP2 var]$ ls
adm  cache  crash  db  empty  ftp  games  kerberos  lib  local  lock  log  mail  nis  opt  preserve  run  spool  tmp  www  yp

[smaintos@LITP2 www]$ ls
tp2_linux

[smaintos@LITP2 tp2_linux]$ ls
index.html
```

**🌞 Adapter la conf NGINX**

```
[smaintos@LITP2 nginx]$ cd conf.d/
[smaintos@LITP2 conf.d]$ ls
ginx.conf
[smaintos@LITP2 conf.d]$ sudo cat ginx.conf 
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 26119;

  root /var/www/tp2_linux;
}
```

**🌞 Visitez votre super site web**

```
➜  ~ git:(main) ✗ curl http://192.168.64.10:26119/
<h1>MEOW mon premier serveur web</h1>
```
### III. Your own services ###

**2. Analyse des services existants**

**🌞 Afficher le fichier de service SSH**

Chemin : /usr/lib/systemd/system/sshd.service

```
[smaintos@LITP2 system]$ cat sshd.service | grep ExecStart
ExecStart=/usr/sbin/sshd -D $OPTIONS
```


**🌞 Afficher le fichier de service NGINX**

Chemin : /usr/lib/systemd/system/nginx.service
```
[smaintos@LITP2 system]$ cat nginx.service | grep ExecStart
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
```

**3. Création de service.**

Numéro Random : 11595

**🌞 Créez le fichier /etc/systemd/system/tp2_nc.service**

```
[smaintos@LITP2 system]$ cat tp2_nc.service 
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 17411
```

**🌞 Indiquer au système qu'on a modifié les fichiers de service**

```
[smaintos@LITP2 system]$ sudo systemctl daemon-reload
[smaintos@LITP2 system]$ 
```

**🌞 Démarrer notre service de ouf**

```
[smaintos@LITP2 system]$ systemctl start tp2_nc.service 
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ====
Authentication is required to start 'tp2_nc.service'.
Authenticating as: smaintos
Password: 
==== AUTHENTICATION COMPLETE ====
[smaintos@LITP2 system]$ 
```

**🌞 Vérifier que ça fonctionne**




```
[smaintos@LITP2 system]$ ss |grep FIN
tcp   FIN-WAIT-2 0      0                     192.168.64.10:11595     192.168.64.12:45740 
``` 

**🌞 Affiner la définition du service**

```
[smaintos@LITP2 system]$ cat tp2_nc.service 
©[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 11595
Restart=always
```





