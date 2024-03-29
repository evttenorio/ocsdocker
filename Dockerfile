FROM debian:buster

WORKDIR /ocs
RUN apt update
RUN apt-get install libgdbm-dev libxml-simple-perl perl libperl5.28 libdbi-perl\
                    libdbd-mysql-perl libapache-dbi-perl libnet-ip-perl\
                    libsoap-lite-perl libswitch-perl\
                    php-pclzip php7.3 php7.3-soap\
                    php7.3-xml php7.3-gd php7.3-curl php7.3-mysql\
                    php7.3-zip libxml-parser-perl build-essential\
                    git libconfig-yaml-perl php7.3-mbstring apache2\
                    wget nano mariadb-server -y

RUN cpan -i XML::Entities Archive::Zip Mojolicious Net::IP Plack::Handler

RUN sed -i 's/max_execution_time = 30/max_execution_time = 200/g' /etc/php/7.3/apache2/php.ini\
&& sed -i 's/max_input_time = 60/max_input_time = 200/g' /etc/php/7.3/apache2/php.ini\
&& sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php/7.3/apache2/php.ini\
&& sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /etc/php/7.3/apache2/php.ini\
&& sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g' /etc/php/7.3/apache2/php.ini

RUN wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.9.2/OCSNG_UNIX_SERVER-2.9.2.tar.gz\ 
&& tar -zxvf OCSNG_UNIX_SERVER-2.9.2.tar.gz\
&& cd /ocs/OCSNG_UNIX_SERVER-2.9.2\ 
&& chmod +x setup.sh && yes '' | ./setup.sh && rm -rf setup.sh\ 
&& cp /etc/apache2/conf-available/ocsinventory-reports.conf  /etc/apache2/sites-available/ && cp /etc/apache2/conf-available/z* /etc/apache2/sites-available/

RUN sed -i 's/php_value post_max_size         101m/php_value post_max_size         128m/g' /etc/apache2/sites-available/ocsinventory-reports.conf\
&& sed -i 's/php_value upload_max_filesize   100m/php_value upload_max_filesize   128m/g' /etc/apache2/sites-available/ocsinventory-reports.conf\
&& sed -i 's/PerlSetEnv OCS_DB_HOST localhost/PerlSetEnv OCS_DB_HOST "${DB_ROOT_IP}"/g' /etc/apache2/sites-available/z-ocsinventory-server.conf\
&& sed -i 's/PerlSetVar OCS_DB_PWD ocs/PerlSetVar OCS_DB_PWD "${DB_ROOT_PASSWORD}"/g' /etc/apache2/sites-available/z-ocsinventory-server.conf\
&& ln -s /etc/apache2/sites-available/z-ocsinventory-server.conf /etc/apache2/sites-enabled/\
&& ln -s /etc/apache2/sites-available/zz-ocsinventory-restapi.conf /etc/apache2/sites-enabled/\
&& ln -s /etc/apache2/sites-available/ocsinventory-reports.conf /etc/apache2/sites-enabled/

CMD apachectl -D FOREGROUND


