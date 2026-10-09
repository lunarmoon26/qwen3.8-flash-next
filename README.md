# Local Qwen3.8-Flash-Next with Strata

Dedicated installation of [Strata](https://github.com/Niko1221/Strata), copied
from the supplied reference checkout at commit
`fb58e0dbc8399662c0e47c76578c6e878b14f6cf`. The reference is unchanged.

## Configuration

- Qwen3.8-Flash-Next Unsloth UD-IQ4_XS (roughly 94 GB download).
- CUDA, GPUs 0 and 1: two RTX PRO 6000 Blackwell 96 GB cards, automatic layer split.
- 262,144-token native context window; images disabled.
- Local-only server: http://127.0.0.1:8080.
- Weights and prepared packs: `/mnt/deepseek-nvme1/strata-data/` on the SN8100.
- Shared draft layer: `Strata-data/mtp/`; private Python environment: `Strata/.venv/`.
- 12 GiB expert RAM budget; KV stays in VRAM. IQ2_XS has been removed.

## Commands

```bash
cd ~/Workspace/qwen3.8-flash-next
bash check.sh
bash install.sh   # resumable; logs/setup-iq4.log
bash start.sh     # foreground; Ctrl+C stops the server
```

From another terminal:

```bash
bash smoke-test.sh
```

Open http://127.0.0.1:8080 for chat. OpenAI-compatible clients use
`http://127.0.0.1:8080/v1`, model `strata`, and any placeholder API key.
Do not expose this unauthenticated server to other devices or through a tunnel.

The first launch can take several minutes and temporarily slow the desktop.
Do not run a second server while one is loading. Startup logs are under
`Strata/strata-*.log`; split-test server output is in `logs/server-iq4-split.log`.
No system driver changes or automatic boot services are installed.

## Verified on this PC

SHA-256 checks and packing passed. The model loaded on two GPUs with
`max_context: 262144`; a chat request correctly returned `323` for 17 × 19.
Auto split placed layers 0–23 on GPU 0 and 24–47 on GPU 1. All 24,576 experts
fit in the GPU caches (27.60 + 27.83 GiB), with 0 GiB of resident expert RAM.
Total GPU allocations were approximately 41 GiB on each card, including other
desktop allocations on GPU 0. Full-window prompts, tool calling, and sustained
throughput have not been tested.

`start-iq4.sh` is an alias for the same model launch used by `start.sh`.
`install-iq4.sh` installs with setup's single-card RAM budget, then configures
the verified engine split directly. This avoids setup's Unsloth multi-GPU path,
which would remove the RAM budget and load all experts into host RAM. Do not
rerun plain `setup.sh --gpus` to configure this model on the 48 GB RAM host.
The original single-GPU config is saved at `logs/iq4-single-gpu.json`.
The NVMe `mtp` symlink depends on `Strata-data/mtp`; keep that directory.
