# Local HTTP File Server

For KUAL, extract `fileserver` directory to /mnt/us/extensions/

```
# Generate certificate
openssl req -x509 -out localhost.crt -keyout localhost.key -newkey rsa:2048 -nodes -sha256 -days 3650
# View certificate
openssl x509 -in localhost.crt -text
```
