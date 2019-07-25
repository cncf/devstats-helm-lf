#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 devstats
"${1}h.sh" delete devstats-bootstrap
"${1}h.sh" delete mini-devstats-pvs
"${1}h.sh" delete devstats-secrets
#"${1}k.sh" delete pvc pgdata-devstats-postgres-0 pgdata-devstats-postgres-1 pgdata-devstats-postgres-2 devstats-backups
change_namespace.sh $1 default
