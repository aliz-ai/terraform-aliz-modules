# Tools

## Introduction

This document provide selected tools for GKE development and operations.

## Google Cloud SDK (gcloud)

[Google Cloud SDK][1] contains tools and libraries for interacting with Google Cloud products and services including `gcloud`, `gsutil` and `bq`.

Follow [this guide][2] to install Google Cloud SDK on your system.

## Kubectl

The [kubectl][3] command line tool lets you control Kubernetes clusters.

Follow [this guide][4] to install kubectl on your system.

## k9s

[K9s][5] is a terminal based UI to interact with your Kubernetes clusters. The aim of this project is to make it easier to navigate, observe and manage your deployed applications in the wild. K9s continually watches Kubernetes for changes and offers subsequent commands to interact with your observed resources.

You can follow [this guide][6] to install k9s on your systems

## helm

[helm][7] is Kubernetes package manager.

To install helm you can follow [this guide][8]

## helmfile 

[Helmfile][9] is a declarative spec for deploying helm charts.

Follow the [installation guide][10].


## helm-diff plugin

[helm-diff][11] is a Helm plugin giving your a preview of what a helm upgrade would change. It basically generates a diff between the latest deployed version of a release and a helm upgrade --debug --dry-run. This can also be used to compare two revisions/versions of your helm release.

To Install helm-diff you can follow [this guide][12]

[1]: https://cloud.google.com/sdk/
[2]: https://cloud.google.com/sdk/docs/install
[3]: https://kubernetes.io/docs/reference/kubectl/overview/
[4]: https://kubernetes.io/docs/tasks/tools/
[5]: https://k9scli.io/
[6]: https://k9scli.io/topics/install/
[7]: https://helm.sh/
[8]: https://helm.sh/docs/intro/install/
[9]: https://github.com/roboll/helmfile
[10]: https://github.com/roboll/helmfile#installation
[11]: https://github.com/databus23/helm-diff
[12]: https://github.com/databus23/helm-diff#install
