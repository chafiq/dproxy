#!make

include .env
.PHONY: helps
args = $(foreach a,$($(subst -,_,$1)_args),$(if $(value $a),$a="$($a)"))

CONTAINER_MARIADB := @docker exec -it dproxy-mariadb

.DEFAULT_GOAL := helps

DIR=./certs
SUBCOMMAND = $(subst £,=, $(subst +,-, $(filter-out $@,$(MAKECMDGOALS))))

helps:
	@clear
	@printf "\033[36m%-30s\033[0m %s\n" help Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | cut -d: -f2- | sort -t: -k 2,2 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: ca cert

ca: ## CA
	./bin/ca-gen -v -c FR -s Marseille -l Marseille -o DEV -u DEV -n "TRAEFIK SELF-SIGNED CA - DEV" -e ca@example.com $(DIR)/CA.key $(DIR)/CA.crt

cert: ## CA
	./bin/cert-gen -v -c FR -s Marseille -l Marseille -o Develop -u Develop -n $(N) -e admin@$(N) -a $(A) $(DIR)/CA.key $(DIR)/CA.crt $(DIR)/$(N).key $(DIR)/$(N).csr $(DIR)/$(N).crt
	echo "[[tls.certificates]]" > ./traefik/conf.d/tls.certificates.$(N).toml
	echo '  certFile = "/certs/$(N).crt"' >> ./traefik/conf.d/tls.certificates.$(N).toml
	echo '  keyFile = "/certs/$(N).key"' >> ./traefik/conf.d/tls.certificates.$(N).toml

db: ## Create Database
	${CONTAINER_MARIADB} mysql -h 127.0.0.1 -proot -e  "CREATE DATABASE $(name)"
	${CONTAINER_MARIADB} mysql -h 127.0.0.1 -proot -e  "GRANT ALL PRIVILEGES ON $(name).* TO 'user'@'%' WITH GRANT OPTION"

# Wilcard unused targets, including error
# Need for avoid ${SUBCOMMAND} missing target false flag. (Clever, if you find better)
%:
	@echo "♪ღ♪*•.¸¸¸.•*¨¨*•.¸¸¸.•*•♪ღ♪¸.•*¨¨*•.¸¸¸.•*•♪ღ♪•*"
