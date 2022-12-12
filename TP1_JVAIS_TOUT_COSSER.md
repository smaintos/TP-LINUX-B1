# TP 1 JVAIS TOUT COSSER
-- 😼
### Première méthode  ###

- on supprime les fichiers qui charge le noyau et ensuite ... voila c'est tout 
(les fichiers dans le dossier /boot , ils se nomment "vmlinuz-linux")

### Deuxième méthode ###
 - un script qui redémarre la machine à chaque fois une fois qu'on la démarre
 
```
 #!/bin/bash
/usr/sbin/reboot
```

### Troisième méthode ###

- désactiver la touche entrée du clavier avec xmodmap ce qui rend inutile le terminal donc la vm

xmodmap -e 'keycode (keycode de la touche entrée) = 0x0000'

### Quatrième  méthode ###
- 