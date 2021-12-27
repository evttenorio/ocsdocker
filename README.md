## Acesso ao banco
```bash
mysql -u root -p
Enter password: {SENHADOBANCO}


MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO ocs@{IPOCS} IDENTIFIED BY '{SENHADOBANCO}' WITH GRANT OPTION;
```
