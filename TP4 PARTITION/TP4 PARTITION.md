# TP4 PARTITION

### Partie 1 : ###

### 🌞 Partitionner le disque à l'aide de LVM ###

```
[smaintos@storage-tp4 ~]$ sudo pvdisplay
  --- Physical volume ---
  PV Name               /dev/vdb
  VG Name               storage
```


```
[smaintos@storage-tp4 ~]$ sudo vgdisplay
  --- Volume group ---
  VG Name               storage
```

```
[smaintos@storage-tp4 ~]$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/storage/vdblv
  LV Name                vdblv
  VG Name                storage
```

### 🌞 Formater la partition ###

```
[smaintos@storage-tp4 ~]$ sudo mkfs -t ext4 /dev/storage/vdblv
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done  
```
 
```
 [smaintos@storage-tp4 storage]$ df -h | grep storage
/dev/mapper/storage-vdblv  2.0G   24K  1.9G   1% /dev/storage
```
```
[smaintos@storage-tp4 mapper]$ sudo touch oui
[smaintos@storage-tp4 mapper]$ ls
control  oui  rl-root  rl-swap  storage-vdblv
```
```
[smaintos@storage-tp4 mapper]$ sudo umount /dev/storage
[smaintos@storage-tp4 mapper]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
/boot/efi                : already mounted
none                     : ignored
mount: /dev/storage does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/dev/storage             : successfully mounted
```

### Partie 2 : Serveur de partage de fichiers ###


