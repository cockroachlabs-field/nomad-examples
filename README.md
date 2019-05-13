# nomad_examples

```
brew install consul
brew install nomad
```
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

## Consul
Start Consul
```
consul agent -dev
```

Consul UI - http://localhost:8500/ui

## Nomad
Start Nomad
```
nomad agent -dev -config=example-1/client.conf
```

Nomad UI - http://localhost:4646/ui



