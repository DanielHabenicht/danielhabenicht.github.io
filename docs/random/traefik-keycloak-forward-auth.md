https://cloud.support.dracoon.com/hc/de/articles/360001372679-OpenID-Anbindung-Keycloak

https://www.keycloak.org/getting-started/getting-started-docker

Create new user with email.

secret: 9be88129eac68765191d502d884dd9e8

# the master realm (already created)

oidc_issuer_url: https://keycloak.test.aquiver.de/auth/realms/master

# the word id of the created client

oidc_client_id: test

# secret, activated after switchting access type to confidential

oidc_client_secret: 7d84adaf-dbed-491c-8ea9-9424cc5a234c

https://github.com/thomseddon/traefik-forward-auth/issues/160

https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/overview/#configuring-for-use-with-the-traefik-v2-forwardauth-middleware

- dont forget to set created user to be email verified
-

For Azure : https://www.paraesthesia.com/archive/2020/09/03/setting-up-oauth2-proxy-with-istio/
