# Cilium Gophers Around the World Demo

A simple Cilium demo, Gophers travel themed 

## Requirements

- docker
- kind or any kubernetes cluster
- kubectl
- helm

## Overview

Welcome to Gopherland where gophers travel across the continents.

## Demo flow

TODO: Add schema

## Deploy Gophers around the world

```shell
make deploy
```

## Check that pods and services are deployed 

```shell
$ kubectl get pod
```

Example of output
```shell
NAME                                READY   STATUS    RESTARTS   AGE
gopher-colony-au-6f49cd8cd-j6g8h    1/1     Running   0          10h
gopher-colony-au-6f49cd8cd-m2knj    1/1     Running   0          10h
gopher-colony-au-6f49cd8cd-tgdr7    1/1     Running   0          10h
gopher-colony-eu-6798c884d6-9c4g8   1/1     Running   0          11h
gopher-colony-eu-6798c884d6-d7l56   1/1     Running   0          11h
gopher-colony-eu-6798c884d6-xqrf9   1/1     Running   0          11h
gopher-colony-us-6d649fd6d4-tfccl   1/1     Running   0          11h
gopher-colony-us-6d649fd6d4-vz87n   1/1     Running   0          11h
gopher-colony-us-6d649fd6d4-xlh5f   1/1     Running   0          11h
```

```shell
$ kubectl get svc
```

Example of output
```shell
 k get svc                                                                                                       ✔  12078  22:30:52 
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
gopher-colony-au   ClusterIP   10.96.154.165   <none>        8080/TCP   10h
gopher-colony-eu   ClusterIP   10.96.149.155   <none>        8080/TCP   11h
gopher-colony-us   ClusterIP   10.96.188.7     <none>        8080/TCP   11h
kubernetes         ClusterIP   10.96.0.1       <none>        443/TCP    24h
```

## Install Cilium

```shell
helm upgrade --install -n kube-system cilium cilium/cilium --version v1.15.1  --set debug.enabled=true  --set image.pullPolicy="IfNotPresent"
```

## Scenario 1: Freedom, gophers travel all around the world

For example Gophers from EU can travel everywhere.
```shell
make test-eu-eu
make test-eu-us
make test-eu-au
```

## Scenario 2: Gophers from EU can travel only to EU

Apply Cilium Network Policy
```shell
kubectl apply -f gopher-travel-policy-allow-only-eu.yaml
```

Verify the Cilium Network Policy is applied correctly
```shell
kubectl get ciliumnetworkpolicies.cilium.io                                                                 SIGINT(2) ↵  12080  22:36:24 
NAME                                       AGE
gopher-travel-policy-allow-only-eu         27m
```

The following command should succeed ✅
```shell
make test-eu-eu
```

The following commands should fail ❌(should never be able to connect)
```shell
make test-eu-us
make test-eu-au
```

> CTRL+C to kill the commands

Delete Cilium Network Policy
```shell
kubectl delete ciliumnetworkpolicies.cilium.io gopher-travel-policy-allow-only-eu
```

## Scenario 3: Gophers from EU can travel only to US

Apply Cilium Network Policy
```shell
kubectl apply -f gopher-travel-policy-allow-only-eu-to-us.yaml
```

Verify the Cilium Network Policy is applied correctly
```shell
kubectl get ciliumnetworkpolicies.cilium.io                                                                 SIGINT(2) ↵  12080  22:36:24 
NAME                                       AGE
gopher-travel-policy-allow-only-eu-to-us   27m
```

The following command should succeed ✅
```shell
make test-eu-us
```

The following commands should fail ❌(should never be able to connect)
```shell
make test-eu-eu
make test-eu-au
```

Delete Cilium Network Policy
```shell
kubectl delete ciliumnetworkpolicies.cilium.io gopher-travel-policy-allow-only-eu
```

## Clean 🧹 

```shell
make clean
```
