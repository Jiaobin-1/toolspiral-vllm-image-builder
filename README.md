# ToolSpiral vLLM image builder

This private helper repository publishes the Determined-compatible ToolSpiral
Base LLM runtime image. It contains no model weights, project source code,
datasets, server credentials, or evaluation results.

The workflow builds from the pinned official vLLM 0.8.5.post1 Linux/AMD64
image, installs the official BFCL package from the frozen Gorilla commit,
replaces the API-server entrypoint so Determined can inject its launcher, and
publishes the resulting image to GHCR. It still contains no model weights,
ToolSpiral source code, private datasets, credentials, or evaluation results.
