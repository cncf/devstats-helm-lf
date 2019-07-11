#!/bin/bash
# EXE=1 - run command instead of preview
# HELM=helm2 - set different helm command
helm="helm"
if [ ! -z "$HELM" ]
then
  helm=$HELM
fi
if [ -z "$EXE" ]
then
  $helm install --dry-run --debug ./devstats-helm --set skipSecrets=1,skipPVs=1,skipBootstrap=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1,provisionCommand='./k8s/clear_devstats_running_flag.sh' "${@}"
  echo "To actually execute prepend with EXE=1 and set other env variables, for example:"
  echo "KUBECONFIG=/root/.kube/config_lf"
  echo "AWS_PROFILE=profile_name"
  echo "Additional --set var=1val1,..."
else
  $helm install ./devstats-helm --set skipSecrets=1,skipPVs=1,skipBootstrap=1,skipCrons=1,skipGrafanas=1,skipServices=1,skipNamespace=1,provisionCommand='./k8s/clear_devstats_running_flag.sh' "${@}"
fi
