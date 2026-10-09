#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if ! mountpoint -q /mnt/deepseek-nvme1; then
  echo 'SN8100 data filesystem is not mounted.' >&2
  exit 1
fi
cd "$ROOT/Strata"
if [[ ! -f run-unsloth-ud-iq4_xs.sh ]]; then
  echo 'UD-IQ4_XS not installed. Run bash install-iq4.sh first.' >&2
  exit 1
fi
exec bash ./run-unsloth-ud-iq4_xs.sh
