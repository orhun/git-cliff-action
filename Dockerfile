FROM orhunp/git-cliff:2.5.0@sha256:1decc44f731f4f95777429ead823a0a6df8159c877c8a59ac79c34d45f899105

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
