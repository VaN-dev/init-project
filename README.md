init-project
================

This script is a tool for quickly setting a new local web project. It will :
- generate a custom vhost file and save it into /etc/apache2/sites-available
- enable the project via `a2ensite`
- reload apache
- add the host in /etc/hosts

# Installation

## clone the repo
```
git clone git@github.com:VaN-dev/init-project.git
```

## set bash script as executable
```
sudo chmod +x /path/to/project/init-project.sh
```

## set an alias to use it from anywhere in shell (optional)
```
alias init-project='sh -c /path/to/project/init-project.sh'
```

# Usage
Simply run the command 
```
$ init-project
```

You will be asked 3 parameters. As an example :
- server name: my-project
- server extension: localhost
- project path: /home/me/www/my-project-path

will produce the following vhost:

```
<VirtualHost *:80>
	ServerName my-project.localhost

	DocumentRoot /home/me/www/my-project-path
	<Directory /home/me/www/my-project-path>
	    AllowOverride All
	    Require all granted
	    Allow from All
	</Directory>

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```