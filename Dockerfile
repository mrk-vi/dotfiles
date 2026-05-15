FROM node:22-slim

RUN apt-get update && apt-get install -y \
    ripgrep \
    git \
    curl \
    ca-certificates \
    openssh-client \
    && curl -sSL https://gitlab.com/gitlab-org/cli/-/releases/permalink/downloads/release-latest/glab_linux_amd64.deb -o /tmp/glab.deb \
    && dpkg -i /tmp/glab.deb || apt-get install -f -y \
    && rm /tmp/glab.deb \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"

ENV GIT_TERMINAL_PROMPT=0

RUN npm install -g @mariozechner/pi-coding-agent

WORKDIR /workspace
ENTRYPOINT ["pi"]
