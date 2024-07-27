FROM orhunp/git-cliff:2.4.0@sha256:f15810fd4dcbe984093dac804d177f2e1d259428611d28e9d187cb7fd1655b1d

LABEL maintainer="orhun <orhunparmaksiz@gmail.com>"
LABEL repository="https://github.com/orhun/git-cliff-action"
LABEL homepage="https://github.com/orhun/git-cliff"

LABEL com.github.actions.name="Changelog Generator"
LABEL com.github.actions.description="Generate changelog based on your Git history"
LABEL com.github.actions.icon="triangle"
LABEL com.github.actions.color="green"

COPY README.md /
COPY LICENSE /
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]
