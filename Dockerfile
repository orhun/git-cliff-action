FROM orhunp/git-cliff:1.3.0-rc.1@sha256:b6fc34bf033f41d1d8d351ba75f0f37eb26952451a9db22873a7cc2297814f8f

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
