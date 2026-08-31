FROM docker.io/vllm/vllm-openai@sha256:c48cf118e1e6e39d7790e174d6014f7af5d06f79c2d29d984d11cbe2e8d414e7

ARG BFCL_COMMIT=6ea57973c7a6097fd7c5915698c54c17c5b1b6c8
ARG DETERMINED_AGENT_USER=yl95xudo
ARG DETERMINED_AGENT_UID=1647
ARG DETERMINED_AGENT_GROUP=mlde_wsp_NoE_LLMs
ARG DETERMINED_AGENT_GID=1651

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openssh-server \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m pip install --no-cache-dir \
    "https://github.com/ShishirPatil/gorilla/archive/${BFCL_COMMIT}.tar.gz#subdirectory=berkeley-function-call-leaderboard" \
    soundfile \
    && if getent group "${DETERMINED_AGENT_GROUP}" >/dev/null; then \
         test "$(getent group "${DETERMINED_AGENT_GROUP}" | cut -d: -f3)" = "${DETERMINED_AGENT_GID}"; \
       else \
         groupadd --gid "${DETERMINED_AGENT_GID}" "${DETERMINED_AGENT_GROUP}"; \
       fi \
    && if getent passwd "${DETERMINED_AGENT_USER}" >/dev/null; then \
         test "$(id -u "${DETERMINED_AGENT_USER}")" = "${DETERMINED_AGENT_UID}"; \
       else \
         useradd --uid "${DETERMINED_AGENT_UID}" --gid "${DETERMINED_AGENT_GID}" --create-home --shell /bin/bash "${DETERMINED_AGENT_USER}"; \
       fi \
    && test "$(id -u "${DETERMINED_AGENT_USER}")" = "${DETERMINED_AGENT_UID}" \
    && test "$(id -g "${DETERMINED_AGENT_USER}")" = "${DETERMINED_AGENT_GID}" \
    && python3 -c 'import bfcl_eval.__main__, vllm; assert vllm.__version__ == "0.8.5.post1"' \
    && test -x /usr/sbin/sshd

LABEL org.opencontainers.image.title="ToolSpiral Base LLM evaluation runtime" \
      org.opencontainers.image.description="Determined-compatible vLLM 0.8.5.post1 runtime with pinned BFCL dependencies" \
      ai.toolspiral.vllm.version="0.8.5.post1" \
      ai.toolspiral.vllm.base-digest="sha256:c48cf118e1e6e39d7790e174d6014f7af5d06f79c2d29d984d11cbe2e8d414e7" \
      ai.toolspiral.bfcl.commit="6ea57973c7a6097fd7c5915698c54c17c5b1b6c8" \
      ai.toolspiral.determined.agent-user="yl95xudo" \
      ai.toolspiral.determined.agent-uid="1647" \
      ai.toolspiral.determined.agent-group="mlde_wsp_NoE_LLMs" \
      ai.toolspiral.determined.agent-gid="1651" \
      ai.toolspiral.determined.sshd="/usr/sbin/sshd"

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash"]
