# devstats-helm-lf

DevStats Deployment on Kubernetes using Helm. This is a deployment for LF and CNCF projects

Helm chart in `devstats-helm`.

# Adding new projects

See `cncf/devstats-helm`:`ADDING_NEW_PROJECTS.md` for information about how to add more projects.


# Usage

Please provide secret values for each file in `./secrets/*.secret.example` saving it as `./secrets/*.secret` or specify them from the command line.

Please note that `vim` automatically adds new line to all text files, to remove it run `truncate -s -1` on a saved file.

List of secrets:
- File `secrets/PG_ADMIN_USER.secret` or --set `pgAdminUser=...` setup postgres admin user name.
- File `secrets/PG_HOST.secret` or --set `pgHost=...` setup postgres host name.
- File `secrets/PG_HOST_RO.secret` or --set `pgHostRO=...` setup readonly postgres host name.
- File `secrets/PG_PORT.secret` or --set `pgPort=...` setup postgres port.
- File `secrets/PG_PASS.secret` or --set `pgPass=...` setup postgres password for the default user (gha_admin).
- File `secrets/PG_PASS_RO.secret` or --set `pgPassRO=...` setup for the read-only user (ro_user).
- File `secrets/PG_PASS_TEAM.secret` or --set `pgPassTeam=...` setup the team user (also read-only) (devstats_team).
- File `secrets/PG_PASS_REP.secret` or --set `pgPassRep=...` setup password for replication.
- File `secrets/ES_HOST.secret` or --set `esHost=...` setup Elastic Search host name.
- File `secrets/ES_PORT.secret` or --set `esPort=...` setup Elastic Search port.
- File `secrets/ES_PROTO.secret` or --set `esProto=...` setup Elastic Search protocol (http or https).
- File `secrets/GHA2DB_ES_URL.secret` or --set `esURL=...` setup full Elastic Search URL.
- File `secrets/GHA2DB_GITHUB_OAUTH.secret` or --set `githubOAuth=...` setup GitHub OAuth token(s) (single value or comma separated list of tokens).
- File `secrets/GF_SECURITY_ADMIN_USER.secret` or --set `grafanaUser=...` setup Grafana admin user name.
- File `secrets/GF_SECURITY_ADMIN_PASSWORD.secret` or --set `grafanaPassword=...` setup Grafana admin user password.

You can select which secret(s) should be skipped via: `--set skipPGSecret=1,skipESSecret=1,skipGitHubSecret=1,skipGrafanaSecret=1`.

To install:
- `helm install devstats ./devstats-helm --set deployEnv=test`.

To upgrade:
- `helm upgrade devstats ./devstats-helm`.

You can install only selected templates, see `values.yaml` for details (refer to `skipXYZ` variables in comments), example:
- `helm install --dry-run --debug --generate-name ./devstats-helm --set deployEnv=test,skipSecrets=1,skipPVs=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1`.

You can restrict ranges of projects provisioned and/or range of cron jobs to create via:
- `--set indexPVsFrom=5,indexPVsTo=9,indexProvisionsFrom=5,indexProvisionsTo=9,indexCronsFrom=5,indexCronsTo=9,indexGrafanasFrom=5,indexGrafanasTo=9,indexServicesFrom=5,indexServicesTo=9`.

You can overwrite the number of CPUs autodetected in each pod, setting this to 1 will make each pod single-threaded
- `--set nCPUs=1`.

Please note variables commented out in `./devstats-helm/values.yaml`. You can either uncomment them or pass their values via `--set variable=name`.

Resource types used: secret, pv, pvc, po, cronjob, deployment, svc

To debug provisioning, for example Kubernetes, use:
- `helm install ./devstats-helm debug-provision --set skipNamespace=1,skipSecrets=1,skipPVs=1,skipBootstrap=1,skipCrons=1,skipGrafanas=1,skipServices=1,indexProvisionsFrom=12,indexProvisionsTo=13,provisionCommand=sleep,provisionCommandArgs={36000s}`.
- `helm install ./devstats-helm debug-bootstrap --set skipNamespace=1,skipSecrets=1,skipPVs=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,bootstrapPodName=debug,bootstrapCommand=sleep,bootstrapCommandArgs={36000s}`.
- Bash into it: `github.com/cncf/devstats-k8s-lf`: `./util/pod_shell.sh devstats-provision-kubernetes`.
- Then for example: `PG_USER=gha_admin db.sh psql gha`, followed: `select dt, proj, prog, msg from gha_logs where proj = 'kubernetes' order by dt desc limit 40;`.
- Finally delete pod using Helm: `helm delete debug-bootstrap|debug-provision` or Kubernetes: `kubectl delete pod devstats-provision-kubernetes`.

Kubernetes dashboard

- You can track cluster state using Kubernetes dashboards, see [how to install it](https://github.com/cncf/devstats-kubernetes-dashboard).


Clear DevStats running flag and/or set provisioned flag:
- `AWS_PROFILE=... KUBECONFIG=... HELM=helm2 EXE='1' ./util/clear_devstats_running_flag.sh devstats-clearflag`.
- `AWS_PROFILE=... KUBECONFIG=... HELM=helm2 EXE='1' ./util/set_provisioned_flag.sh devstats-setflag`.
- `AWS_PROFILE=... KUBECONFIG=... HELM=helm2 EXE='1' ./util/repo_groups.sh devstats-repogroups`.


# New LF infra

Please see `NEW_LF.md`.
