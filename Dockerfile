FROM docker.io/vllm/vllm-openai@sha256:c48cf118e1e6e39d7790e174d6014f7af5d06f79c2d29d984d11cbe2e8d414e7

ARG BFCL_COMMIT=6ea57973c7a6097fd7c5915698c54c17c5b1b6c8

RUN python3 -m pip install --no-cache-dir \
    "https://github.com/ShishirPatil/gorilla/archive/${BFCL_COMMIT}.tar.gz#subdirectory=berkeley-function-call-leaderboard" \
    && python3 -c 'import bfcl_eval.__main__, vllm; assert vllm.__version__ == "0.8.5.post1"'

LABEL org.opencontainers.image.title="ToolSpiral Base LLM evaluation runtime" \
      org.opencontainers.image.description="Determined-compatible vLLM 0.8.5.post1 runtime with pinned BFCL dependencies" \
      ai.toolspiral.vllm.version="0.8.5.post1" \
      ai.toolspiral.vllm.base-digest="sha256:c48cf118e1e6e39d7790e174d6014f7af5d06f79c2d29d984d11cbe2e8d414e7" \
      ai.toolspiral.bfcl.commit="6ea57973c7a6097fd7c5915698c54c17c5b1b6c8"

ENTRYPOINT ["/usr/bin/env"]
CMD ["/bin/bash"]
