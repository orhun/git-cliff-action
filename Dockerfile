FROM orhunp/git-cliff:1.3.1@sha256:70992c19e459ddaf6094e80d25035cd304cbe6f8cf4ab8b383e9f149d994b01b

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
