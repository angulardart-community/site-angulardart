FROM ruby:2.7-slim-buster as base

RUN apt update && apt install -yq --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      lsof \
      make \
      unzip \
      vim-nox \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /site


# ============== DART ==============
FROM base as dart

ARG TARGETARCH

ARG DART_VERSION=latest
ARG DART_CHANNEL=stable
ENV DART_VERSION=$DART_VERSION
ENV DART_CHANNEL=$DART_CHANNEL
ENV DART_SDK=/usr/lib/dart
ENV PATH=$DART_SDK/bin:$PATH
RUN set -eu; \
    case "${TARGETARCH}_${DART_CHANNEL}" in \
      amd64_stable) \
        DART_SHA256="f837f385603a1cfb14ddb7dd0cd64820b297646626bdb689ccfc3278fa83b2b1"; \
        SDK_ARCH="x64";; \
      arm64_stable) \
        DART_SHA256="8e71b0c958a587c83ecd6c8cc637bc624bb85bc64e877e9ea00831a659a904b1"; \
        SDK_ARCH="arm64";; \
      amd64_beta) \
        DART_SHA256="dc57e88d3c60cbd5ee738505fed804d854bfb1b30bdff9f218bb1d1085ec8173"; \
        SDK_ARCH="x64";; \
      arm64_beta) \
        DART_SHA256="99c787a521458e6fd3d402bff47f4b4c47c5ad32727f9b3a204310fc25e3b14a"; \
        SDK_ARCH="arm64";; \
      amd64_dev) \
        DART_SHA256="d507faf120db2b4949e750800d38b39a088df98319c095cfb7e7351431d3cb92"; \
        SDK_ARCH="x64";; \
      arm64_dev) \
        DART_SHA256="cdfbf3bdffde243951ae6ba7b431df0e4a5a5c0496dcc34343534de14949b444"; \
        SDK_ARCH="arm64";; \
    esac; \
    SDK="dartsdk-linux-${SDK_ARCH}-release.zip"; \
    BASEURL="https://storage.googleapis.com/dart-archive/channels"; \
    URL="$BASEURL/$DART_CHANNEL/release/$DART_VERSION/sdk/$SDK"; \
    curl -fsSLO "$URL"; \
    echo "$DART_SHA256 *$SDK" | sha256sum --check --status --strict - || (\
        echo -e "\n\nDART CHECKSUM FAILED! Run 'make fetch-sums' for updated values.\n\n" && \
        rm "$SDK" && \
        exit 1 \
    ); \
    unzip "$SDK" > /dev/null && mv dart-sdk "$DART_SDK" && rm "$SDK";
ENV PUB_CACHE="${HOME}/.pub-cache"
RUN dart --disable-analytics
RUN echo -e "Successfully installed Dart SDK:" && dart --version

WORKDIR /site


# ============== NODEJS ==============
FROM dart as node

RUN set -eu; \
    NODE_PPA="node_ppa.sh"; \
    NODE_SHA256=9820c0fcf01527ffd3b2077de1f76d4bbe67bdb38df9d12fa195d7eea1521e8a; \
    curl -fsSL https://deb.nodesource.com/setup_lts.x -o "$NODE_PPA"; \
    echo "$NODE_SHA256 $NODE_PPA" | sha256sum --check --status --strict - || (\
        echo -e "\n\nNODE CHECKSUM FAILED! Run tool/fetch-node-ppa-sum.sh for updated values.\n\n" && \
        rm "$NODE_PPA" && \
        exit 1 \
    ); \
    sh "$NODE_PPA" && rm "$NODE_PPA"; \
    apt-get update -q && apt-get install -yq --no-install-recommends \
      nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable

WORKDIR /site


# ============= RUBY/JEKYLL =============
FROM node as site

WORKDIR /site
COPY ./ ./

RUN dart pub get
RUN yarn install
RUN bundle install

# Let's not play "which dir is this"
ENV BASE_DIR=/site
ENV TOOL_DIR=$BASE_DIR/tool

# Jekyl
EXPOSE 5000
EXPOSE 35729
