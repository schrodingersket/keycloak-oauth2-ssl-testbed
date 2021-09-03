#!/usr/bin/env bash

# This file was used to generate the certificates and certificate authority committed to this repository
# and is included for reference (or to generate new certificates, should the need arise).
#
# Credit to: https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309
#
openssl genrsa -out rootCA.key 4096
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -subj "/C=US/ST=CO/O=AcmeCorporation/CN=localhost" -out rootCA.crt
openssl genrsa -out localhost.key 2048
openssl req -new -sha256 -key localhost.key -subj "/C=US/ST=CO/O=AcmeCorporation, Inc./CN=localhost" -out localhost.csr
openssl x509 -req -in localhost.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out localhost.crt -days 3650 -sha256
