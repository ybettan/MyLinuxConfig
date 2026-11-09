#!/usr/bin/env bash
# Launcher for the Google Workspace MCP server used by the OpenCode "enmaas" profile.
# Keeps the OAuth client credentials out of the dotfiles repo.
set -euo pipefail

ENV_FILE="$HOME/.config/opencode-enmaas/google-mcp.env"

if [ ! -r "$ENV_FILE" ]; then
  echo "gws-mcp: missing credentials file: $ENV_FILE" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
. "$ENV_FILE"
set +a

# The local OAuth callback is plain http://localhost:8000
export OAUTHLIB_INSECURE_TRANSPORT=1

# uv installs uvx in different places depending on the machine. Prefer the
# per-user install used on the workstation, then fall back to PATH.
if [ -x "$HOME/.local/share/bin/uvx" ]; then
  UVX="$HOME/.local/share/bin/uvx"
elif [ -x "$HOME/.local/bin/uvx" ]; then
  UVX="$HOME/.local/bin/uvx"
elif command -v uvx >/dev/null 2>&1; then
  UVX="$(command -v uvx)"
else
  echo "gws-mcp: uvx not found (install uv or add uvx to PATH)" >&2
  exit 1
fi

exec "$UVX" workspace-mcp \
  --permissions docs:full sheets:full slides:full drive:full "$@"
