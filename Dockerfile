FROM orhunp/git-cliff:2.1.2@sha256:5418cf78c69f2c470ec93bf4f19ce6dd209e6c4035ca0fdb5ecbab8866ecae37

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
