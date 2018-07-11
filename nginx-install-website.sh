#!/bin/bash
function installHttp(){
    host=$1
    port=$2
    sudo echo "server {
            listen 80;
            listen [::]:80;
            server_name $host www.$host;

            location /
            {
                proxy_pass http://0.0.0.0:$port;
            }
        }
    " >> /etc/nginx/sites-available/$1.conf
}

function installHttps(){
    host=$1
    port=$2
    crt=`realpath "$3"`
    key=`realpath "$4"`
    sudo echo "server {
            listen 80;
            listen [::]:80;
            server_name $host www.$host;
            listen 443 ssl;

            ssl_certificate $crt;
            ssl_certificate_key $key;

            location /
            {
                proxy_pass http://0.0.0.0:$port;
            }
        }
    " >> /etc/nginx/sites-available/$1.conf
}

echo $#

if [ "$#" -eq 4 ];
then
    installHttps $1 $2 $3 $4
else
    installHttp $1 $2
fi

sudo ln -s /etc/nginx/sites-available/$1.conf /etc/nginx/sites-enabled/$1.conf
sudo systemctl reload nginx
