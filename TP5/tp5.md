

### TP 5 : Self-hosted cloud ###

### 🌞 Partie 1 : Mise en place et maîtrise du serveur web 🌞 ###

```
[keidko@web ~]$ sudo dnf install httpd
[sudo] password for keidko: 
```
```
[keidko@web ~]$ sudo systemctl start httpd 
[keidko@web ~]$ sudo systemctl status httpd 
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
     Active: active (running) since Fri 2023-02-10 20:40:22 CET; 5s ago
       Docs: man:httpd.service(8)
   Main PID: 11272 (httpd)
     Status: "Started, listening on: port 80"
      Tasks: 213 (limit: 5878)
     Memory: 22.1M
        CPU: 63ms
     CGroup: /system.slice/httpd.service
             ├─11272 /usr/sbin/httpd -DFOREGROUND
             ├─11282 /usr/sbin/httpd -DFOREGROUND
             ├─11283 /usr/sbin/httpd -DFOREGROUND
             ├─11284 /usr/sbin/httpd -DFOREGROUND
             └─11285 /usr/sbin/httpd -DFOREGROUND

Feb 10 20:40:22 web.linux.tp5 systemd[1]: Starting The Apache HTTP Server...
Feb 10 20:40:22 web.linux.tp5 systemd[1]: Started The Apache HTTP Server.
Feb 10 20:40:22 web.linux.tp5 httpd[11272]: Server configured, listening on: port 80
```

```
[keidko@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```

```
[keidko@web conf]$ ss -lapten | grep httpd
LISTEN 0      511                *:80            *:*     ino:37438 sk:34 cgroup:/system.slice/httpd.service v6only:0 <->          
```

```
[keidko@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[keidko@web ~]$ sudo firewall-cmd --reload
success
[keidko@web ~]$ sudo firewall-cmd --list-all | grep 80
  ports: 80/tcp
  ```

  ```
  [keidko@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
     Active: active (running) since Fri 2023-02-10 20:42:21 CET; 10min ago
       Docs: man:httpd.service(8)
   Main PID: 11272 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/sec"
      Tasks: 213 (limit: 5878)
     Memory: 22.2M
        CPU: 889ms
     CGroup: /system.slice/httpd.service
             ├─11272 /usr/sbin/httpd -DFOREGROUND
             ├─11282 /usr/sbin/httpd -DFOREGROUND
             ├─11283 /usr/sbin/httpd -DFOREGROUND
             ├─11284 /usr/sbin/httpd -DFOREGROUND
             └─11285 /usr/sbin/httpd -DFOREGROUND

Feb 10 20:42:21 web.linux.tp5 systemd[1]: Starting The Apache HTTP Server...
Feb 10 20:42:21 web.linux.tp5 systemd[1]: Started The Apache HTTP Server.
Feb 10 20:42:21 web.linux.tp5 httpd[11272]: Server configured, listening on: port 80```

```

```
[keidko@web ~]$ sudo systemctl is-enabled httpd
enabled
```
```
[keidko@web ~]$ curl localhost | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
      html {
100  7620  100  7620    0     0   826k      0 --:--:-- --:--:-- --:--:--  826k

```

```
(base) ➜  ~ git:(main) ✗ curl 192.168.64.23 |head -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   716k      0 --:--:-- --:--:-- --:--:-- 1488k
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
[keidko@web ~]$ sudo cat /usr/lib/systemd/system/httpd.service
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

```
[keidko@web ~]$ sudo cat /etc/httpd/conf/httpd.conf | grep User 
User apache
```

```
[keidko@web ~]$ ps -ef | grep apache
apache     11282   11272  0 20:42 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
```

```
[keidko@web testpage]$ sudo cat /etc/passwd | tail -n 2
apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin
bouchon:x:1001:1001::/usr/share/httpd/:/sbin/nologin
```
```
[keidko@web testpage]$ sudo cat /etc/httpd/conf/httpd.conf | grep User
User bouchon
```

```
[keidko@web testpage]$ sudo systemctl restart httpd
```

```
[keidko@web testpage]$ ps -ef | grep httpd
root           11738       1  0 20:45 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
bouchon        11741   11738  0 20:45 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
bouchon        11742   11738  0 20:45 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
bouchon        11743   11738  0 20:45 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
bouchon        11744   11738  0 20:45 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
```

```
[keidko@web testpage]$ sudo cat /etc/httpd/conf/httpd.conf | grep Listen
Listen 8080
```

```
[keidko@web testpage]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
```

```
[keidko@web testpage]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[keidko@web testpage]$ sudo firewall-cmd --reload
success
```

```
[[keidko@web conf]$ ss -lapten | grep httpd
LISTEN 0      511                *:8080            *:*     ino:37438 sk:34 cgroup:/system.slice/httpd.service v6only:0 <->       
```

```
(base) ➜  ~ git:(main) ✗ curl 192.168.64.23:8080 |head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   668k      0 --:--:-- --:--:-- --:--:-- 1240k
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

        
### 🌞 Partie 2 : Mise en place et maîtrise du serveur de base de données 🌞 ###

```

[keidko@db ~]$ sudo dnf install mariadb-server

```


```
[keidko@db ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
```

```
[keidko@db ~]$ sudo systemctl start mariadb
[keidko@db ~]$ sudo mysql_secure_installation

[keidko@db ~]$ sudo systemctl is-enabled mariadb
enabled
```


```
[keidko@db ~]$ ss -lapten | grep mariadb
LISTEN 0      80                 *:3306            *:*     uid:27 ino:36842 sk:4 cgroup:/system.slice/mariadb.service v6only:0 <->  
```


```
[keidko@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
[sudo] password for keidko: 
success
[keidko@db ~]$ sudo firewall-cmd --reload
success
[keidko@db ~]$ sudo firewall-cmd --list-all | grep ports
 ports: 3306/tcp
  

  
[keidko@db ~]$ ps -ef | grep mariadb
mysql      13015       1  0 20:48 ?        00:00:01 /usr/libexec/mariadbd --basedir=/usr
```

### 🌞 Partie 3 : Configuration et mise en place de NextCloud 🌞 ###

```
[keidko@db ~]$ sudo mysql -u root -p
MariaDB [(none)]> CREATE USER 'nextcloud'@'192.168.64.23' IDENTIFIED BY 'pewpewpew';
Query OK, 0 rows affected (0.008 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'192.168.64.23';
Query OK, 0 rows affected (0.004 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.002 sec)
```

```
[keidko@web conf]$ sudo dnf install mysql
```

```
[keidko@web conf]$ mysql -u nextcloud -h 192.168.64.24 -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 27
Server version: 5.5.5-10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```
```
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.01 sec)

mysql> USE nextcloud;
Database changed
mysql> show tables;
Empty set (0.00 sec)
```
```
[keidko@web conf]$ sudo cat httpd.conf | head -n 10

ServerRoot "/etc/httpd"

Listen 80

Include conf.modules.d/*.conf

User apache
Group apache

[keidko@web conf]$ ps -ef | grep httpd
root       12581       1  0 20:51 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     12584   12581  0 20:51 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     12585   12581  0 20:51 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     12586   12581  0 20:51 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     12587   12581  0 20:51 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
[keidko@web conf]$ ss -lapten | grep httpd
LISTEN 0      511                *:80              *:*     ino:41155 sk:35 cgroup:/system.slice/httpd.service v6only:0 <->                
[keidko@web conf]$ sudo firewall-cmd --remove-port=8080/tcp --permanent
success
[keidko@web conf]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[keidko@web conf]$ sudo firewall-cmd --reload
success
  ```
  ```
(base) ➜  ~ git:(main) ✗ curl 192.168.64.23 |head -n 5
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   620k      0 --:--:-- --:--:-- --:--:-- 1063k
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
[keidko@web conf]$ sudo dnf config-manager --set-enabled crb
[sudo] password for keidko:
[keidko@web conf]$ sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y

[keidko@web conf]$ dnf module list php

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled

[keidko@web conf]$ sudo dnf module enable php:remi-8.1 -y

[keidko@web conf]$ sudo dnf install -y php

    ```
    ```
[keidko@web ~]$ cat i
libxml2
openssl
php
php-ctype
php-curl
php-gd
php-iconv
php-json
php-libxml
php-mbstring
php-openssl
php-posix
php-session
php-xml
php-zip
php-zlib
php-pdo
php-mysqlnd
php-intl
php-bcmath
php-gmp
```
```
[keidko@web www]$ sudo mkdir tp5_nextcloud
[keidko@web www]$ ls
cgi-bin  html  tp5_nextcloud
```

```
[keidko@web tp5_nextcloud]$ curl -O https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0Warning: Failed to create the file nextcloud-25.0.0rc3.zip: Permission denied
  0  168M    0 16384    0     0   7892      0  6:12:24  0:00:02  6:12:22  7895
curl: (23) Failure writing output to destination
[keidko@web tp5_nextcloud]$ sudo curl -O https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  168M  100  168M    0     0  6914k      0  0:00:24  0:00:24 --:--:-- 7781k
[keidko@web tp5_nextcloud]$ ls
nextcloud-25.0.0rc3.zip
```
```
[keidko@web tp5_nextcloud]$ sudo dnf install unzip
```
```
[keidko@web tp5_nextcloud]$ sudo unzip nextcloud-25.0.0rc3.zip 
```
```
[keidko@web nextcloud]$ sudo cp -r * /var/www/tp5_nextcloud/
```
```
[keidko@web www]$ sudo chown apache -R tp5_nextcloud/
```

```
[keidko@web conf.d]$ sudo systemctl restart httpd
```
```
(base) ➜  ~ git:(main) ✗ cat hosts |grep web
192.168.64.23 web.tp5.linux
```
```
[keidko@web conf.d]$ mysql -u nextcloud -h 192.168.64.24 -p
Enter password:
```
```
mysql> select count(*) as nombre_de_tables
    -> from information_schema.tables
    -> where table_schema = 'nextcloud'
    -> ;
+------------------+
| nombre_de_tables |
+------------------+
|               95 |
+------------------+
1 row in set (0.01 sec)
```