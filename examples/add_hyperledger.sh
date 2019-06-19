#!/bin/bash
if [ -z "$AWS_PROFILE" ]
then
  echo "$0: you must set AWS_PROFILE=..."
  exit 1
fi
if [ -z "$KUBECONFIG" ]
then
  echo "$0: you must set KUBECONFIG=..."
  exit 1
fi
helm2 install --name devstats-hyperledger ./devstats-helm --set skipSecrets=1,indexPVsFrom=62,skipBootstrap=1,indexProvisionsFrom=62,indexCronsFrom=62,indexGrafanasFrom=62,indexServicesFrom=62,skipNamespace=1
