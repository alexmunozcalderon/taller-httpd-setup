#!/bin/bash

# --- Configuration Variables ---
APP_NAMESPACE=cicd-tu-nombre
ARGO_NAMESPACE=argocd-taller
GITHUB_CONFIG_REPO=https://github.com/jovemfelix/taller-httpd-release-engineering.git
APP_UID='httpd-demo-renato' 

# --- Project Configuration ---
oc label namespace $APP_NAMESPACE argocd.argoproj.io/managed-by=argocd-taller --overwrite

# --- ArgoCD Application Definition ---
cat <<EOF | oc apply -f -
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $APP_UID
  namespace: $ARGO_NAMESPACE
  labels:
    env: dev
    team: application
    author: renato
spec:
  project: default
  source:
    repoURL: '$GITHUB_CONFIG_REPO'
    targetRevision: HEAD
    path: .
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: $APP_NAMESPACE
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF