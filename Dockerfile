FROM orhunp/git-cliff:2.0.3@sha256:f8eb85a767c5e14f9bb08b2bce2c8fb37662cd9bd111a1257a8c2f4c2f88ea7a

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
