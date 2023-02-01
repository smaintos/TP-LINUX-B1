# TP5 NEXTCLOUD

### Partie 1 : Mise en place et maîtrise du serveur Web ###

### 🌞 Installer le serveur Apache : ###

`[keidko@webtp5 ~]$ sudo dnf install httpd`

### 🌞 Démarrer le service Apache : ###

`[keidko@webtp5 ~]$ sudo systemctl start httpd`

`[keidko@webtp5 ~]$ sudo dnf enable httpd`

```
[keidko@webtp5 ~]$ systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor p>
     Active: active (running) since Wed 2023-01-18 16:47:01 CET; 8min ago
       Docs: man:httpd.service(8)
   Main PID: 1590 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Byt>
      Tasks: 213 (limit: 22666)
     Memory: 39.1M
        CPU: 1.587s
     CGroup: /system.slice/httpd.service
             ├─1590 /usr/sbin/httpd -DFOREGROUND
             ├─1591 /usr/sbin/httpd -DFOREGROUND
             ├─1592 /usr/sbin/httpd -DFOREGROUND
             ├─1593 /usr/sbin/httpd -DFOREGROUND
             └─1594 /usr/sbin/httpd -DFOREGROUND

Jan 18 16:47:00 webtp5 systemd[1]: Starting The Apache HTTP Server...
Jan 18 16:47:00 webtp5 httpd[1590]: AH00558: httpd: Could not reliably determ>
Jan 18 16:47:01 webtp5 httpd[1590]: Server configured, listening on: port 80
Jan 18 16:47:01 webtp5 systemd[1]: Started The Apache HTTP Server.
```
```
[keidko@webtp5 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
[sudo] password for keidko: 
success
```

### 🌞 TEST : ###

```
[keidko@webtp5 ~]$ curl 192.168.64.23 |head -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  7441k      0 --:--:-- --:--:-- --:--:-- 7441k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
```


### 🌞 Le service Apache... ###

```
[keidko@webtp5 ~]$ sudo cat /usr/lib/systemd/system/httpd.service
# See httpd.service(8) for more information on using the httpd service.

# Modifying this file in-place is not recommended, because changes
# will be overwritten during package upgrades.  To customize the
# behaviour, run "systemctl edit httpd" to create an override unit.

# For example, to pass additional options (such as -D definitions) to
# the httpd binary at startup, create an override unit (as is done by
# systemctl edit) and enter the following:

#	[Service]
#	Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
KillMode=mixed
PrivateTmp=true
OOMPolicy=continue

[Install]
WantedBy=multi-user.target
```
### 🌞 Déterminer sous quel utilisateur tourne le processus Apache ###

```
[keidko@webtp5 ~]$ sudo cat /etc/httpd/conf/httpd.conf | grep -i user
User apache
```

```
[keidko@webtp5 ~]$ ps -ef | grep apache
apache       747     712  0 10:30 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache       748     712  0 10:30 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache       749     712  0 10:30 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache       750     712  0 10:30 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1420     712  0 10:31 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
keidko      1540    1492  0 10:38 pts/0    00:00:00 grep --color=auto apache
```
### 🌞 Changer l'utilisateur utilisé par Apache ###

`[keidko@webtp5 ~]$ sudo adduser bouchon`



```
[keidko@webtp5 ~]$ cat /etc/passwd | tail -n 5
systemd-oom:x:991:991:systemd Userspace OOM Killer:/:/usr/sbin/nologin
keidko:x:1000:1000:keidko:/home/keidko:/bin/bash
tcpdump:x:72:72::/:/sbin/nologin
apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin
bouchon:x:1001:1001::/home/bouchon:/bin/bash
```

```
[keidko@webtp5 ~]$ sudo cat /etc/httpd/conf/httpd.conf | grep -i user
User bouchon
```
```[keidko@webtp5 ~]$ sudo systemctl restart httpd```

```
[keidko@webtp5 ~]$ ps -ef | grep bouchon
bouchon     1570    1568  0 10:44 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
bouchon     1571    1568  0 10:44 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
bouchon     1572    1568  0 10:44 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
bouchon     1573    1568  0 10:44 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
keidko      1792    1492  0 10:45 pts/0    00:00:00 grep --color=auto bouchon
```

### 🌞 Faites en sorte que Apache tourne sur un autre port ###

```
[keidko@webtp5 ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
[sudo] password for keidko: 
success
```

`[keidko@webtp5 ~]$  sudo systemctl restart httpd`

```
[keidko@webtp5 ~]$ sudo cat /etc/httpd/conf/httpd.conf | grep -i Listen
Listen 8080
```
```
[keidko@webtp5 ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
```

```
[keidko@webtp5 ~]$ sudo ss -tulpn | grep httpd
tcp   LISTEN 0      511                *:8080            *:*    users:(("httpd",pid=1880,fd=4),("httpd",pid=1879,fd=4),("httpd",pid=1878,fd=4),
```

```
[keidko@webtp5 ~]$ curl 192.168.64.23:8080 |head -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  7441k      0 --:--:-- --:--:-- --:--:-- 744<!doctype html>
1<html>
k  <head>
    <meta charset='utf-8'>

    <meta name='viewport' content='width=device-width, initial-scale=1'>
```
### Partie 2 : Mise en place et maîtrise du serveur de base de données ###

### 🌞 Install de MariaDB sur db.tp5.linux ###

```
[keidko@dbtp5 ~]$ sudo dnf install mariadb-server`

`[keidko@dbtp5 ~]$ sudo systemctl enable mariadb`

`[keidko@dbtp5 ~]$ sudo systemctl start mariadb
````

```
[keidko@dbtp5 ~]$ sudo systemctl is-enabled mariadb
enabled
```
### 🌞 Port utilisé par MariaDB ###
```
[keidko@dbtp5 ~]$ sudo ss -tulnp | grep mariadb
tcp   LISTEN 0      80                 *:3306            *:*    users:(("mariadbd",pid=13440,fd=19))
```

```
[keidko@dbtp5 ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
```
### 🌞 Processus liés à MariaDB ###
```
[keidko@dbtp5 ~]$ ps -ef | grep mariadb
mysql      13440       1  0 12:02 ?        00:00:00 /usr/libexec/mariadbd --basedir=/usr
keidko     13552    1204  0 12:10 pts/0    00:00:00 grep --color=auto mariadb
```

### Partie 3 : Configuration et mise en place de NextCloud ###

### 🌞 Préparation de la base pour NextCloud ###

```
[keidko@dbtp5 ~]$ sudo mysql -u root -p
[sudo] password for keidko: 
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 11
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```
### 🌞 Exploration de la base de données ###


 