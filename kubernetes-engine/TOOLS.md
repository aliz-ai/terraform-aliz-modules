# Tools

## Introduction

This document provide selected tools for GKE development and operations.

## Google Cloud SDK (gcloud)

Google Cloud SDK contains tools and libraries for interacting with Google Cloud products and services.

### Install Google Cloud SDK on MacOS

Using homebrew you can run the following command

```bash
brew install --cask google-cloud-sdk
```

### Install Google Cloud SDK on Linux

### Install Google Cloud SDK on Windows

## Kubectl

The kubectl command line tool lets you control Kubernetes clusters.

### Install kubectl on MacOS

### Install kubectl on Linux

### Install kubectl on Windows

## k9s

K9s is a terminal based UI to interact with your Kubernetes clusters. The aim of this project is to make it easier to navigate, observe and manage your deployed applications in the wild. K9s continually watches Kubernetes for changes and offers subsequent commands to interact with your observed resources.


### Install k9s on MacOS using homebrew

```bash
brew install derailed/k9s/k9s
```

### Install k9s on Linux

Using Linuxbrew

```bash
brew install derailed/k9s/k9s
```

Using PacMan

```bash
pacman -S k9s
```

### Install k9s on Windows

Using Scoop

```powershell
scoop install k9s
```

Using chocolatey

```bash
choco install k9s
```


## helm

helm is Kubernetes package manager.

### Install helm on MacOS

### Install helm on Linux

### Install helm on Windows

## helmfile 

Helmfile is a declarative spec for deploying helm charts

### Install helmfile on MacOS

Install helmfile using homebrew

```bash
brew install helmfile
```

### Install helmfile on Linux

### Install helmfile on Windows

Install helmfile using scoop

```powershell
scoop install helmfile
```

```powershell
chocolatey install helmfile
```

## helm-diff plugin

This is a Helm plugin giving your a preview of what a helm upgrade would change. It basically generates a diff between the latest deployed version of a release and a helm upgrade --debug --dry-run. This can also be used to compare two revisions/versions of your helm release.

### Install helm-diff plugin

```bash
helm plugin install https://github.com/databus23/helm-diff
```

## References

[1] Google Cloud SDK : https://cloud.google.com/sdk/docs/install
[2] Kubectl : https://kubernetes.io/docs/reference/kubectl/overview/
[3] k9s https://k9scli.io/
[4] Helm https://helm.sh/
[5] Helmfile : https://github.com/roboll/helmfile
[6] Helm-diff plugin https://github.com/databus23/helm-diff