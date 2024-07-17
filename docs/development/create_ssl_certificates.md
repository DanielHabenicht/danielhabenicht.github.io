# Create Valid Certificate Chain for use in multiple Docker Containers

```
# Create Root Key

openssl genrsa -des3 -out testca.key -passout pass:password 4096

# Create CA Certificate
openssl req -x509 -new -nodes -key testca.key -passin pass:password -sha256 -days 1826 -out testca.crt -subj '/CN=MyOrg Root CA/C=AT/ST=Dresden/L=Dresden/O=MyOrg'
```

## Create Certificate for a Service
```Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS certificates
# Create development ssl Certifcate: https://learn.microsoft.com/en-us/dotnet/core/additional-tools/self-signed-certificates-guide#with-openssl
SHELL ["/bin/bash", "-c"]
COPY testca.key testca.key
COPY testca.crt testca.crt

ENV MYCERT=servercert
ENV CANAME=testca
RUN openssl req -new -nodes -out $MYCERT.csr -newkey rsa:4096 -keyout $MYCERT.key -subj '/CN=Testcertificate/C=AT/ST=Dresden/L=Dresden/O=MyOrg'
# create a v3 ext file for SAN properties
RUN echo -e '\
authorityKeyIdentifier=keyid,issuer\n\
basicConstraints=CA:FALSE\n\
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\n\
subjectAltName = @alt_names\n\
[alt_names]\n\
DNS.1 = localhost\n\
DNS.2 = host.testcontainers.internal\n\
DNS.3 = identityserver'\
>> $MYCERT.v3.ext

RUN openssl x509 -req -in $MYCERT.csr -CA $CANAME.crt -CAkey $CANAME.key -passin pass:password -CAcreateserial -out $MYCERT.crt -days 730 -sha256 -extfile $MYCERT.v3.ext
RUN openssl pkcs12 -export -out $MYCERT.pfx -inkey $MYCERT.key -in $MYCERT.crt -password pass:

COPY --from=certificates servercert.pfx servercert.pfx

ENV Kestrel__Certificates__Default__Path=servercert.pfx
ENV Kestrel__Certificates__Default__Password=""
```



## Trust the Root CA: 
```
COPY testca.crt /usr/local/share/ca-certificates/testca.crt
RUN update-ca-certificates
```




Thanks to: https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/

https://learn.microsoft.com/en-us/dotnet/core/additional-tools/self-signed-certificates-guide#with-openssl
