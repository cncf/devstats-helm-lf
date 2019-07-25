#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 devstats
##"${1}h.sh" install --dry-run --debug --generate-name ./devstats-helm --set skipSecrets=1,skipPVs=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1
"${1}h.sh" install devstats-secrets ./devstats-helm --set skipPVs=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1,skipPGSecret=1
"${1}h.sh" install mini-devstats-pvs ./devstats-helm --set skipSecrets=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1,indexPVsFrom=0,indexPVsTo=4
"${1}h.sh" install devstats-bootstrap ./devstats-helm --set skipSecrets=1,skipPVs=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1
change_namespace.sh $1 default
