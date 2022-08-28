FROM ruby:2.7.6-slim-bullseye as base

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
        DART_SHA256="ba8bc85883e38709351f78c527cbf72e22cd234b3678a1ec6a2e781f7984e624"; \
        SDK_ARCH="x64";; \
      arm64_stable) \
        DART_SHA256="ee0acf66e184629b69943e9f29459e586095895c6aae6677ab027d99c00934b6"; \
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
    NODE_SHA256=27932797347f900242caaaeba5c1d7c965b3da70566d81123b15be1c0b80cc2c; \
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
EXPOSE 35729
EXPOSE 5000
