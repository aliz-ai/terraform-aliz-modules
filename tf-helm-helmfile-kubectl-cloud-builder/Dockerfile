# Use Terraform image to download provider plugins
FROM hashicorp/terraform:0.12.31 as terraform-provider

COPY provider.tf .

RUN terraform init && \
    mv .terraform/plugins/linux_amd64/terraform-provider* /bin/

# Use gcloud-slim as parent image
FROM gcr.io/cloud-builders/gcloud-slim

# Use ARG so that values can be overriden by user/cloudbuild
ARG TERRAFORM_VERSION=1.0.11
ARG TERRAFORM_VERSION_SHA256SUM=eeb46091a42dc303c3a3c300640c7774ab25cbee5083dafa5fd83b54c8aca664
ARG TERRAFORM_VALIDATOR_RELEASE=v0.4.0
ARG KUBECTL_VERSION="v1.22.4"
ARG HELM_VERSION="v3.7.0"
ARG HELM_SHA256="096e30f54c3ccdabe30a8093f8e128dba76bb67af697b85db6ed0453a2701bf9"
ARG HELM_LOCATION="https://get.helm.sh"
ARG HELM_FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELMFILE_VERSION="v0.142.0"

ENV ENV_TERRAFORM_VERSION=$TERRAFORM_VERSION
ENV ENV_TERRAFORM_VERSION_SHA256SUM=$TERRAFORM_VERSION_SHA256SUM
ENV ENV_TERRAFORM_VALIDATOR_RELEASE=$TERRAFORM_VALIDATOR_RELEASE
ENV ENV_KUBECTL_VERSION=$KUBECTL_VERSION
ENV ENV_HELM_SHA256=$HELM_SHA256
ENV ENV_HELM_LOCATION=$HELM_LOCATION
ENV ENV_HELM_FILENAME=$HELM_FILENAME
ENV ENV_HELMFILE_VERSION=$HELMFILE_VERSION
ENV PATH=/builder:/builder/terraform/:$PATH

# Add Terraform to the image
RUN apt-get update && \
\
   /builder/google-cloud-sdk/bin/gcloud -q components install alpha beta && \
\
    apt-get -y install curl jq unzip git ca-certificates && \
\
    curl https://releases.hashicorp.com/terraform/${ENV_TERRAFORM_VERSION}/terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip \
      > terraform_linux_amd64.zip && \
\
    echo "${ENV_TERRAFORM_VERSION_SHA256SUM} terraform_linux_amd64.zip" > terraform_SHA256SUMS && \
    sha256sum -c terraform_SHA256SUMS --status && \
\
    unzip terraform_linux_amd64.zip -d /builder/terraform && \
    rm -f terraform_linux_amd64.zip && \
\
    gsutil cp gs://terraform-validator/releases/${ENV_TERRAFORM_VALIDATOR_RELEASE}/terraform-validator-linux-amd64 /builder/terraform/terraform-validator && \
    chmod +x /builder/terraform/terraform-validator && \
\
    apt-get remove --purge -y unzip && \
    apt-get --purge -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=terraform-provider /bin/terraform-provider* /bin/

# Add Kubectl to the image
RUN  \
    curl https://storage.googleapis.com/kubernetes-release/release/${ENV_KUBECTL_VERSION}/bin/linux/amd64/kubectl > /builder/kubectl \
        && chmod +x /builder/kubectl

# Add Helm to the image
RUN set -x && \
    curl ${ENV_HELM_LOCATION}/${ENV_HELM_FILENAME} > ${ENV_HELM_FILENAME} &&\
    sha256sum ${ENV_HELM_FILENAME} | grep -q "${ENV_HELM_SHA256}" && \
    tar zxvf ${ENV_HELM_FILENAME} && mv /linux-amd64/helm /builder/helm && \
    rm ${ENV_HELM_FILENAME} && rm -r /linux-amd64

# Add Helmfile to the image
ADD https://github.com/roboll/helmfile/releases/download/${ENV_HELMFILE_VERSION}/helmfile_linux_amd64 /builder/helmfile
RUN chmod +x /builder/helmfile

# Add helm-diff plugin to the image
RUN helm plugin install https://github.com/databus23/helm-diff --version v3.1.3 && \
    apt-get remove --purge -y curl

COPY entrypoint.bash /builder/entrypoint.bash
RUN chmod +x /builder/entrypoint.bash
ENTRYPOINT ["/builder/entrypoint.bash"]