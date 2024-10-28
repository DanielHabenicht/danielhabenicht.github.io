# Run Migration before E2E Test


Add pr replace this function in your `env.py`
```py
from sqlalchemy.ext.asyncio import async_engine_from_config

def run_migrations_online():
    connectable = config.attributes.get("connection", None)

    if connectable is None:
        # only create Engine if we don't have a Connection
        # from the outside
        connectable = engine_from_config(
            config.get_section(config.config_ini_section), prefix="sqlalchemy.", poolclass=pool.NullPool
        )

        with connectable.connect() as connection:
            context.configure(connection=connection, target_metadata=target_metadata)

            with context.begin_transaction():
                context.run_migrations()
    else:
        context.configure(connection=connectable, target_metadata=target_metadata)

        with context.begin_transaction():
            context.run_migrations()
```

Use this fixture in your tests: 
```python
@pytest_asyncio.fixture()
async def database_client():
    with PostgresContainer("postgres:16") as postgres:
        connection_string = postgres.get_connection_url().replace("psycopg2", "asyncpg")

        # Run Migration
        def run_upgrade(connection):
            alembic_cfg = Config()
            alembic_cfg.set_main_option("script_location", "app/backend/alembic")
            alembic_cfg.set_main_option("url", connection_string)
            alembic_cfg.attributes["connection"] = connection
            command.upgrade(alembic_cfg, "head")

        async_engine = create_async_engine(connection_string, echo=True)
        async with async_engine.begin() as conn:
            await conn.run_sync(run_upgrade)

        # Initialize your Test SQL Client (or something else)
        database_client = PSqlClientClient(connection_string=connection_string)
        await database_client.init()
        yield database_client
        await database_client.close()

```
