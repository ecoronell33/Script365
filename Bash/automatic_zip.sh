#!/bin/bash

#Crear el archivo zip del directorio deseado
zip -r xfusioncorp_blog.zip /var/www/html/blog

#Añadir el permiso de ejecucion
chmod u+x xfusioncorp_blog.zip

#Mueve el archivo zip creado al directorio backup
mv xfusioncorp_blog.zip /backup

#Copia el comprimido al directorio backup de Backup Server
scp /backup/xfusioncorp_blog.zip clint@stbkp01:/backup
