# Spring-Cloud-Stream-Demo

## Setup

### Generate Key and Certs

The gen_cert.sh will generate self-signed client and server certificates

```bash
cd gen_cert
bash gen_certs.sh
```

#### Test Certificate

Start a server with generated server certs
```bash
openssl s_server -accept 8443 -cert ./gen_cert/server/cert.pem -key ./gen_cert/server/key.pem -CAfile ./gen_cert/server/cacert.pem
```

Connect to above server with client certs
```bash
openssl s_client -connect localhost:8443 -cert ./gen_cert/client/cert.pem -key ./gen_cert/client/key.pem -CAfile ./gen_cert/client/cacert.pem
```

Then start the RabbitMQ broker in Docker.

```bash
cd middleware
docker-compose -f cnpay-compose.yml
```

### Start Spring Boot

```bash
mvn clean spring-boot:run
```

Use curl to test

```bash
curl -X POST \
  http://localhost:8080/demo/stream/msg \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
    "Id": null,
    "Message": "suck it 10"
}'
``
