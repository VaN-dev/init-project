#!/bin/bash

function string_replace() {
	echo "${1//\[\[$3\]\]/$2}"
}

template='<VirtualHost *:80>
	ServerName [[server_name]].[[server_extension]]

	DocumentRoot [[project_path]]
	<Directory [[project_path]]>
	    AllowOverride All
	    Require all granted
	    Allow from All
	</Directory>

	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>'

default_extension=localhost

read -p "Enter Server name: " server_name
read -p "Enter Server extension:[$default_extension] " server_extension
server_extension=${server_extension:-$default_extension}
read -p "Enter Project path: " project_path

vhost=$template
vhost=$(string_replace "$vhost" "$server_name" server_name)
vhost=$(string_replace "$vhost" "$server_extension" server_extension)
vhost=$(string_replace "$vhost" "$project_path" project_path)

printf -v site "%s.conf" "$server_name"
printf -v path "/etc/apache2/sites-available/%s" "$site"

echo -e "$vhost"

sudo bash -c 'echo -e "'"$vhost"'" > "'"$path"'"'

host="[[server_name]].[[server_extension]]"
host=$(string_replace "$host" "$server_name" server_name)
host=$(string_replace "$host" "$server_extension" server_extension)

sudo bash -c 'echo -e "127.0.0.1\t\t'"$host"'" >> /etc/hosts'

sudo a2ensite $site
sudo service apache2 reload
