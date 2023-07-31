# dproxy
Dproxy permet de lancer en // sur de multiples projets utilisant docker.

## Installation
	> cd ./dproxy
	> cp .env.dist .env
	# remplacer le DOMAIN dans le fichier .env
    > docker network create traefik
    > docker network create mailhog
	> docker-compose up -d
    
## DNS Proxy
    * Linux -> dnsmasq : @see https://www.linuxtricks.fr/wiki/dnsmasq-le-serveur-dns-et-dhcp-facile-sous-linux
    * Mac OS -> dnsmasq : @see https://allanphilipbarku.medium.com/setup-automatic-local-domains-with-dnsmasq-on-macos-ventura-b4cd460d8cb3
    * Windows -> Acrylic : @see https://mayakron.altervista.org/support/acrylic/Home.htm

## Create CA
    > make ca
    # Ajouter le ./certs/CA.crt dans le trousseau des cles entant que certificat fiable

## Create certificates
    > N=test.local A=test.local,*.test.local,*.proxy.test.local,... make cert