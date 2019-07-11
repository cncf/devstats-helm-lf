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
> out
objs=`kubectl get pv -o=jsonpath='{range .items[*]}{.metadata.name}{";"}{.status.phase}{"\n"}{end}'`
for obj in $objs
do
  IFS=';'
  arr=($obj)
  unset IFS
  pv=${arr[0]}
  sts=${arr[1]}
  if [ "$sts" = "Failed" ]
  then
    kubectl describe pv "$pv" | grep 'currently attached to' | grep 'Message:' >> out
  fi
done
cat out | sort | uniq
