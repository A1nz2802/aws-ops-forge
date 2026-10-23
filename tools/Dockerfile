# Tool versions and upstream image contents are selected explicitly.
FROM golang:1.26@sha256:3745f1aa11822297b79113f5e84ce2bffeb039734571c39855809cfe9e5d7be6 AS go
FROM hashicorp/terraform:1.16.5@sha256:c7926feace05d0f7e73542842bf3945924e955a1f782cf000ccbb8d18fa42d77 AS terraform
FROM amazon/aws-cli:2.32.7@sha256:2fcb4059b4f87a42cfe28a674bee119c0c484f7bdc67f1643f9dda0200134d1e

# OS packages still resolve from the distribution repositories at build time.
RUN yum install -y git tar gzip shadow-utils \
    && yum clean all

COPY --from=go /usr/local/go /usr/local/go
COPY --from=terraform /bin/terraform /usr/local/bin/terraform
ENV PATH="/usr/local/go/bin:${PATH}" \
    HOME=/home/forge \
    CGO_ENABLED=0 \
    GOTOOLCHAIN=local

ARG TOOL_UID=1000
ARG TOOL_GID=1000
RUN groupadd --gid "$TOOL_GID" forge \
    && useradd --uid "$TOOL_UID" --gid "$TOOL_GID" --create-home --shell /bin/bash forge

COPY aws-config /usr/local/share/forge/aws-config
COPY --chmod=755 entrypoint.sh /usr/local/bin/forge-entrypoint
USER forge
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/forge-entrypoint"]
CMD ["bash"]
