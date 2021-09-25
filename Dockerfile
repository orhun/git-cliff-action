FROM orhunp/git-cliff:0.3.0@sha256:f29c2635af6b11768799890c2da82457078ccac9be021cca4f0bc63a89d58430

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

ENTRYPOINT ["/entrypoint.sh"]
