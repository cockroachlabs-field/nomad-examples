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

vault write database/config/vault_test \
    plugin_name=postgresql-database-plugin \
    allowed_roles="test-role" \
    connection_url="postgresql://{{username}}:{{password}}@localhost:5432/test?timezone=UTC&sslcert=/mnt/certs/roach-0/client.root.crt&sslkey=/mnt/certs/roach-0/client.root.key&sslmode=verify-full&sslrootcert=/mnt/certs/roach-0/ca.crt" \
    username="root" \
    password=""
    
vault write database/roles/test-role \
    db_name=vault_test \
    creation_statements="CREATE ROLE IF NOT EXISTS vault_testers; \
        CREATE USER \"{{name}}\"; \
        CREATE vault_testers to \"{{name}}\"; \
        GRANT SELECT ON DATABASE vault_test TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"
    
vault read database/creds/test-role 
```

