```bash
#!/bin/bash
docker rm generate-keycloak-setup --force || true
docker rm generate-keycloak-setup-stage --force || true
docker image rm generate-keycloak-setup-stage --force || true

# 1. Run the keycloak container
docker run --name generate-keycloak-setup --env KEYCLOAK_ADMIN=admin --env KEYCLOAK_ADMIN_PASSWORD=admin -d quay.io/keycloak/keycloak:latest start-dev

# Wait for server start
while ! docker logs generate-keycloak-setup | grep -q "Running the server in development mode.";
do
    sleep 1
    echo "waiting for server start..."
done

# 2. Spawn a shell inside the container and modify the realms, user etc 
cat <<EOF | docker exec -i generate-keycloak-setup sh
# Login into keycloak with admin credentials
/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --user admin --password admin --realm master

/opt/keycloak/bin/kcadm.sh create realms -s realm=businessgpt -s enabled=true

# Create Claim Mapper
/opt/keycloak/bin/kcadm.sh create -x "client-scopes" --target-realm=businessgpt --server http://localhost:8080 -s name=businessgpt -s protocol=openid-connect -s id=3d68dadc-bd71-4dce-93fe-d486fb67b83d -s 'description=Mapper for the BusinessGPT'
/opt/keycloak/bin/kcadm.sh create -x "client-scopes/3d68dadc-bd71-4dce-93fe-d486fb67b83d/protocol-mappers/models" --target-realm=businessgpt --server http://localhost:8080 -s name=user-attribute-role-mapper -s protocol=openid-connect -s protocolMapper=oidc-usermodel-attribute-mapper -s id=b783ca7e-cc53-4d5e-9da4-2f5d5db8e35a -s 'config."introspection.token.claim"=false' -s 'config."multivalued"=true' -s 'config."userinfo.token.claim"=true' -s 'config."id.token.claim"=true' -s 'config."claim.name"=role' -s 'config."jsonType.label"=String' -s 'config."user.attribute"=role'

# Create Client for the businessgpt
/opt/keycloak/bin/kcadm.sh create clients --target-realm=businessgpt --server http://localhost:8080 -s clientId=businessgpt -s enabled=true -s secret=b1a44ee2-1699-4da8-8e83-874a983e33e7 -s id=206a5ca5-7230-4568-a1ca-5ebe0cba791c -s 'redirectUris=["*"]' -s 'attributes."post.logout.redirect.uris"=*'
/opt/keycloak/bin/kcadm.sh update -x clients/206a5ca5-7230-4568-a1ca-5ebe0cba791c/optional-client-scopes/3d68dadc-bd71-4dce-93fe-d486fb67b83d --target-realm=businessgpt

# Create users and set passwords
# Admin
/opt/keycloak/bin/kcadm.sh create users --target-realm=businessgpt --server http://localhost:8080 -s username=admin -s enabled=true -s email=admin@test.de -s emailVerified=true -s attributes.role=admin
/opt/keycloak/bin/kcadm.sh set-password --target-realm=businessgpt --server http://localhost:8080 --username admin --new-password password

# Normal User
/opt/keycloak/bin/kcadm.sh create users --target-realm=businessgpt --server http://localhost:8080 -s username=user -s enabled=true -s email=user@test.de -s emailVerified=true -s attributes.role=user
/opt/keycloak/bin/kcadm.sh set-password --target-realm=businessgpt --server http://localhost:8080 --username user --new-password password
EOF

# Stop running server and make an image
docker stop generate-keycloak-setup
docker commit generate-keycloak-setup generate-keycloak-setup-stage

# Export to realm.json
docker run --mount type=bind,source=$(pwd),target=/tmp/export --name generate-keycloak-setup-stage generate-keycloak-setup-stage export --realm businessgpt --dir /tmp/export

docker rm generate-keycloak-setup
docker rm generate-keycloak-setup-stage
docker image rm generate-keycloak-setup-stage


# Debugging
# /opt/keycloak/bin/kcadm.sh get clients -r businessgpt --server http://localhost:8080
# /opt/keycloak/bin/kcadm.sh get -x "client-scopes" --target-realm=businessgpt --server http://localhost:8080
# /opt/keycloak/bin/kcadm.sh get clients/206a5ca5-7230-4568-a1ca-5ebe0cba791c/protocol-mappers/models/6c5aa465-1352-4ad6-9ed8-8398377cd0fe --target-realm=businessgpt --server http://localhost:8080



# Other
# /opt/keycloak/bin/kcadm.sh add-roles --realm=businessgpt --server http://localhost:8080 --username admin --rolename admin-role
# /opt/keycloak/bin/kcadm.sh create roles --realm=businessgpt --server http://localhost:8080 -s name=admin-role -s 'description=Role for 
Tool Admins.' -s 'attributes.test=sksid-sk-admin'

```

Then simply build and start with the generated configurations: 
```dockerfile
FROM quay.io/keycloak/keycloak:latest
COPY ./generated-realm-realm.json /opt/keycloak/data/import/generated-realm-realm.json
COPY ./generated-realm-users-0.json /opt/keycloak/data/import/generated-realm-users-0.json
```


```docker-compose
services:
  auth:
    build: Dockerfile
    environment:
      - KEYCLOAK_ADMIN=admin
      - KEYCLOAK_ADMIN_PASSWORD=admin
    ports:
      - 8080:8080
    command:
      - start-dev
      - --import-realm
```
