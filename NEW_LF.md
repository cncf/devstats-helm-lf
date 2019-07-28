# Deployment on the new LF infra

- Dry run on the `test` env: `testh.sh install --dry-run --debug --generate-name ./devstats-helm --set deployEnv=test,skipSecrets=1,skipPVs=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1`.
- Create `devstats` namespace: `testh.sh install devstats-namespace ./devstats-helm --set skipSecrets=1,skipPVs=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1`.
