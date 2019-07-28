#!/bin/bash
if ( [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] )
then
  echo "$0: you need to specify env: test, dev, stg, prod then project from index and finaly project to index"
  echo "Example: '$0 test 4 6', will add projects [4, 6) to the test env"
  echo"If you want to expose grafanas via AWS ELB(s), prepend with ELB=1"
  exit 1
fi
change_namespace.sh $1 devstats
"${1}h.sh" install "devstats-pvs-$2-$3" ./devstats-helm --set "deployEnv=$1,skipSecrets=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1,indexPVsFrom=$2,indexPVsTo=$3"
"${1}h.sh" install "devstats-provisions-$2-$3" ./devstats-helm --set "deployEnv=$1,skipSecrets=1,skipPVs=1,skipBootstrap=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1,indexProvisionsFrom=$2,indexProvisionsTo=$3"
"${1}h.sh" install "devstats-crons-$2-$3" ./devstats-helm --set "deployEnv=$1,skipSecrets=1,skipPVs=1,skipBootstrap=1,skipProvisions=1,skipGrafanas=1,skipServices=1,skipNamespace=1,indexCronsFrom=$2,indexCronsTo=$3"
if [ ! -z "$ELB" ]
then
  "${1}h.sh" install "devstats-grafanas-$2-$3" ./devstats-helm --set "deployEnv=$1,skipSecrets=1,skipPVs=1,skipBootstrap=1,skipProvisions=1,skipCrons=1,skipNamespace=1,indexGrafanasFrom=$2,indexGrafanasTo=$3,indexServicesFrom=$2,indexServicesTo=$3"
fi
change_namespace.sh $1 default
