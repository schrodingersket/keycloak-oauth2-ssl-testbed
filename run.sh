#!/usr/bin/env bash
docker run -p 8443:8443 \
	   -e KEYCLOAK_USER=admin \
	   -e KEYCLOAK_PASSWORD=admin \
	   -v ${pwd}/certs/localhost.crt:/etc/x509/https/tls.crt \
	   -v ${pwd}/certs/localhost.key:/etc/x509/https/tls.key \
	   --name keycloak-oauth2-ssl \
	   --rm \
	   jboss/keycloak:15.0.2
