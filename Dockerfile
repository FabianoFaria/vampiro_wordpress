# Use a imagem base do WordPress
FROM wordpress:latest

# Autor
LABEL maintainer="vampiroblogueirinho@gmail.com"

# Copie os arquivos do tema e plugins para o diretório do WordPress
COPY wp-content/themes/ /var/www/html/wp-content/themes/
COPY wp-content/plugins/ /var/www/html/wp-content/plugins/

# Exponha a porta padrão do WordPress
EXPOSE 80

# Comando padrão para iniciar o servidor web (Apache no caso do WordPress)
CMD ["apache2-foreground"]