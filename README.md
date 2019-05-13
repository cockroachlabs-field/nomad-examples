# nomad_examples

```
brew install consul
brew install nomad
```

## Consul
Start Consul
```
consul agent -dev
```

Consul UI - http://localhost:8500/ui

## Vault
Start Vault
```
vault server -dev -config=example-1/vault-config.hcl
```

In new terminal
```
export VAULT_ADDR='http://127.0.0.1:8200'
```

Vault UI -  http://127.0.0.1:8200/ui

## Nomad
Start Nomad
```
nomad agent -dev -config=example-1/client.conf
```

Nomad UI - http://localhost:4646/ui

### Start Job
```
nomad job run example-1/crdb.nomad
```

## Configure Cockroach 
```
vault secrets enable database

vault write database/config/my-crdb-database \
    plugin_name=postgresql-database-plugin \
    allowed_roles="my-role" \
    connection_url="postgresql://{{username}}:{{password}}@localhost:5432/?sslmode=disable&timezone=UTC" \
    username="root" \
    password=""
    
vault write database/roles/my-role \
    db_name=my-crdb-database \
    creation_statements="CREATE USER {{name}} WITH PASSWORD '{{password}}'; \
        GRANT SELECT ON TABLE * TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"    
```

