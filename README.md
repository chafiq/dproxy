# dproxy
Dproxy permet de lancer en // sur de multiples projets utilisant docker.

## Installation
	> cd ./dproxy
	> cp .env.dist .env
	# remplacer le DOMAIN dans le fichier .env
    > docker network create traefik
    > docker network create mailhog
	> docker-compose up -d

## Create CA
    > make ca
    # Ajouter le ./certs/CA.crt dans le trousseau des cles

## Create certificates
    > N=test.local A=test.local,*.test.local,*.proxy.test.local,... make cert