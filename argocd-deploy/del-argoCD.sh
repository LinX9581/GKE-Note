#!/bin/bash

kubectl delete namespace nodejs-helm-template
kubectl delete namespace ingress-nginx
kubectl delete namespace argocd
kubectl delete ingressclass nginx
