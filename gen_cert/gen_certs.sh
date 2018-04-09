#!/usr/bin/env bash

root_dir=$(pwd)
ca_dir=${root_dir}/cnpay-dev-ca
server_dir=${root_dir}/server
client_dir=${root_dir}/client

client_key_pass=123456
server_key_pass=123456

rabbit_cert_dir=${root_dir}/../middleware/rabbit/server_certs
spring_cert_dir=${root_dir}/../src/main/resources/client_certs

if [ ! -d "${rabbit_cert_dir}" ]; then
    mkdir -p ${rabbit_cert_dir}
fi

if [ ! -d "${spring_cert_dir}" ]; then
    mkdir -p ${spring_cert_dir}
fi

gen_ca(){
    mkdir ${ca_dir}
    cd ${ca_dir}
    mkdir certs private
    chmod 700 private
    echo 01 > serial
    touch index.txt
    export CA_DIR=${ca_dir}
    openssl req -x509 -config ${root_dir}/openssl.cnf -newkey rsa:2048 -days 3650 \
    -out ${ca_dir}/cacert.pem -outform PEM -subj /CN=cnpay-dev-ca/ -nodes
    openssl x509 -in ${ca_dir}/cacert.pem -out ${ca_dir}/cacert.cer -outform DER
}


gen_server_cert(){
    mkdir ${server_dir}
    openssl genrsa -out ${server_dir}/key.pem 2048
    openssl req -new -key ${server_dir}/key.pem -out ${server_dir}/req.pem \
    -outform PEM -subj /CN=cnpay-dev-rabbit/O=server/ -nodes

    openssl ca -config ${root_dir}/openssl.cnf -in ${server_dir}/req.pem -out \
        ${server_dir}/cert.pem -notext -batch -extensions server_ca_extensions

    openssl pkcs12 -export -out ${server_dir}/keycert.p12 -in \
    ${server_dir}/cert.pem -inkey ${server_dir}/key.pem -passout pass:${server_key_pass}

    cp ${ca_dir}/cacert.pem ${server_dir}/cacert.pem
    cp ${server_dir}/cacert.pem ${rabbit_cert_dir}/cacert.pem
    cp ${server_dir}/cert.pem ${rabbit_cert_dir}/cert.pem
    cp ${server_dir}/key.pem ${rabbit_cert_dir}/key.pem
    chmod 777 ${rabbit_cert_dir}/*.*
}

gen_client_cert(){
    mkdir ${client_dir}
    openssl genrsa -out ${client_dir}/key.pem 2048
    openssl req -new -key ${client_dir}/key.pem -out ${client_dir}/req.pem \
    -outform PEM -subj /CN=cnpay-dev-rabbit/O=client/ -nodes

    openssl ca -config ${root_dir}/openssl.cnf -in ${client_dir}/req.pem -out \
        ${client_dir}/cert.pem -notext -batch -extensions client_ca_extensions

    openssl pkcs12 -export -out ${client_dir}/keycert.p12 -in \
    ${client_dir}/cert.pem -inkey ${client_dir}/key.pem -passout pass:${client_key_pass}

    keytool -import -trustcacerts -alias root -storepass ${client_key_pass} \
     -file ${ca_dir}/cacert.pem -keystore ${client_dir}/truststore.jks -noprompt

    cp ${client_dir}/keycert.p12 ${spring_cert_dir}/keycert.p12
    cp ${client_dir}/truststore.jks ${spring_cert_dir}/truststore.jks
    chmod 777 ${spring_cert_dir}/*.*
}

gen_ca
gen_server_cert
gen_client_cert
