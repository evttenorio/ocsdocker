## Acesso ao banco
```bash
mysql -u root -p
Enter password: {SENHADOBANCO}


MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO ocs@{IPOCS} IDENTIFIED BY '{SENHADOBANCO}' WITH GRANT OPTION;
```
## Restart apache
```bash
/etc/init.d/apache2
```

## Pós instalação
```bash
rm /usr/share/ocsinventory-reports/ocsreports/install.php
```
