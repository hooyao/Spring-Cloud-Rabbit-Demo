# Spring-Cloud-Stream-Demo

## Setup

### Generate Key and Certs

The gen_cert.sh will generate self-signed client and server certificates

```bash
cd gen_cert
bash gen_certs.sh
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
