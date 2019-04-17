#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to set project index value from 'devstats-helm/values.yaml', for example kubernetes=12"
  exit 1
fi
from=$1
to=$((from+1))
if [ -z "$EXE" ]
then
  helm install --dry-run --debug ./devstats-helm --set skipSecrets=1,skipPVs=1,skipBootstrap=1,skipCrons=1,skipGrafanas=1,skipServices=1,indexProvisionsFrom=${from},indexProvisionsTo=${to},provisionCommand=sleep,provisionCommandArgs={36000s} "${@:2:99}"
  echo "To actually execute prepend with EXE=1 and set other env variables, for example:"
  echo "KUBECONFIG=/root/.kube/config_lf"
  echo "AWS_PROFILE=profile_name"
  echo "Additional --set var=1val1,..."
else
  helm install ./devstats-helm --set skipSecrets=1,skipPVs=1,skipBootstrap=1,skipCrons=1,skipGrafanas=1,skipServices=1,indexProvisionsFrom=${from},indexProvisionsTo=${to},provisionCommand=sleep,provisionCommandArgs={36000s} "${@:2:99}"
  echo "You should now bash into the container: '../devstats-k8s-lf/util/pod_shell.sh devstats-provision-projname'"
fi
