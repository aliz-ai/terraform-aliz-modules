# Tools

## Introduction

This document provide selected tools for GKE development and operations.

## Google Cloud SDK (gcloud)

[Google Cloud SDK][1] contains tools and libraries for interacting with Google Cloud products and services.

### Install Google Cloud SDK on MacOS

Using homebrew you can run the following command

```bash
brew install --cask google-cloud-sdk
```

### Install Google Cloud SDK on Ubuntu

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk
```

### Install Google Cloud SDK on Windows

From powershell you can run the following command to install Google Cloud SDK 

```powershell
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")

& $env:Temp\GoogleCloudSDKInstaller.exe
```

Alternatively you can download [GoogleCloudSDKInstaller.exe][9] and manually install it.

## Kubectl

The [kubectl][2] command line tool lets you control Kubernetes clusters.

### Install kubectl on MacOS

```bash
brew install kubectl
```

### Install kubectl on Ubuntu

```bash
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```


### Install kubectl on Windows

Using chocolatey

```powershell
choco install kubernetes-cli
```

Using scoop

```powershell
scoop install kubectl
```

## k9s

[K9s][3] is a terminal based UI to interact with your Kubernetes clusters. The aim of this project is to make it easier to navigate, observe and manage your deployed applications in the wild. K9s continually watches Kubernetes for changes and offers subsequent commands to interact with your observed resources.


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

```powershell
choco install k9s
```

## helm

[helm][4] is Kubernetes package manager.

### Install helm on MacOS

You can install helm using homebrew command below

```bash
brew install helm
```

### Install helm on Ubuntu

```bash
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```


### Install helm on Windows

```powershell
choco install kubernetes-helm
```

## helmfile 

[Helmfile][5] is a declarative spec for deploying helm charts

### Install helmfile on MacOS

Install helmfile using homebrew

```bash
brew install helmfile
```

### Install helmfile on Linux

```bash
HELMFILE_VERSION=$(curl --silent "https://api.github.com/repos/roboll/helmfile/releases/latest" | grep '"tag_name":' | cut -d \" -f 4)
wget -O helmfile_linux_amd64 "https://github.com/roboll/helmfile/releases/download/$HELMFILE_VERSION/helmfile_linux_amd64"
chmod +x helmfile_linux_amd64
sudo mv helmfile_linux_amd64 /usr/local/bin/helmfile
```

### Install helmfile on Windows

Install helmfile using scoop

```powershell
scoop install helmfile
```

```powershell
chocolatey install helmfile
```

## helm-diff plugin

[helm-diff][6] is a Helm plugin giving your a preview of what a helm upgrade would change. It basically generates a diff between the latest deployed version of a release and a helm upgrade --debug --dry-run. This can also be used to compare two revisions/versions of your helm release.

### Install helm-diff plugin

```bash
helm plugin install https://github.com/databus23/helm-diff
```

[1]: https://cloud.google.com/sdk/docs/install
[2]: https://kubernetes.io/docs/reference/kubectl/overview/
[3]: https://k9scli.io/
[4]: https://helm.sh/
[5]: https://github.com/roboll/helmfile
[6]: https://github.com/databus23/helm-diff
[7]: https://scoop.sh/
[8]: https://chocolatey.org/
[9]: https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe