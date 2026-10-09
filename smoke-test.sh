#!/usr/bin/env bash
set -euo pipefail
BASE=http://127.0.0.1:8080
curl --fail --silent --show-error --max-time 10 "$BASE/health"
printf '\n'
curl --fail --silent --show-error --max-time 10 "$BASE/v1/models"
printf '\n'
curl --fail --silent --show-error --max-time 180 "$BASE/v1/chat/completions" \
  -H 'Content-Type: application/json' \
  -d '{"model":"strata","messages":[{"role":"user","content":"Say hello in five words."}],"max_tokens":64,"reasoning_effort":"none"}'
printf '\n'
