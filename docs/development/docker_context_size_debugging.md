# Search for what makes your context size so big

```
services:
  test:
    build:
      context: .
      dockerfile: test.Dockerfile
```

```
FROM bytesco/ncdu

WORKDIR temp
COPY . .
```

Run `docker compose --build` and `docker compose run test` to build and review the context changes.
