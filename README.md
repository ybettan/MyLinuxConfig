[![fedora](https://github.com/ybettan/MyLinuxConfig/actions/workflows/fedora.yaml/badge.svg?branch=ci)](https://github.com/ybettan/MyLinuxConfig/actions/workflows/fedora.yaml)
[![ubuntu](https://github.com/ybettan/MyLinuxConfig/actions/workflows/ubuntu.yaml/badge.svg?branch=ci)](https://github.com/ybettan/MyLinuxConfig/actions/workflows/ubuntu.yaml)
[![macos](https://github.com/ybettan/MyLinuxConfig/actions/workflows/macos.yaml/badge.svg?branch=ci)](https://github.com/ybettan/MyLinuxConfig/actions/workflows/macos.yaml)

# Instructions

Just run Makefile targets.

For the complete installation locally run
```
make --ignore-errors all
```
Since we are configuring everything only after installation packages, then we
want to ignore errors in order to execute the `configure` target.
    
 
## `.netrc` (one-time setup)

Codex EnMaaS and OpenCode EnMaaS read the gateway key from `~/.netrc`, without
exporting it into the shell environment.

Create `~/.netrc` once per machine by copying it from the `osac` SSH host, which
already holds the EnMaaS and Jira entries:

```bash
ssh osac 'cat /root/.netrc' > ~/.netrc
chmod 600 ~/.netrc
```

This is a manual step: it is not part of `make all`, and `.netrc` is never
tracked in this repository. If EnMaaS returns `401 Unauthorized`, replace the
`api.enmaas.devshift.net` entry with a valid EnMaaS key.

## Codex EnMaaS (corporate)

The corporate Codex home includes an EnMaaS profile using GPT-6 Luna at `xhigh`
reasoning effort. Start an EnMaaS session with:

```bash
codex-corp-enmaas
```

Pass any Codex CLI options after the function name, for example
`codex-corp-enmaas --model gpt-6-luna`.

## OpenCode private (default)

The private profile config is tracked at `dotfiles/opencode/opencode.json` and
its TUI settings at `dotfiles/opencode/cli.json`. `make link` links both to
`~/.config/opencode/opencode/`.

Start it with:

```bash
opencode
```

The function isolates the profile by setting the `XDG_CONFIG_HOME`,
`XDG_DATA_HOME`, `XDG_STATE_HOME`, and `XDG_CACHE_HOME` directories to their
defaults and running `opencode --standalone`. This keeps the private profile in
use even when launched from a shell that inherited the EnMaaS `XDG_*` variables.

It defaults to `openai/gpt-6-luna` at `xhigh` reasoning with a 872k context
window, matching `codex-priv`. Connect the private OpenAI account once with
`/connect` and choose **Sign in with ChatGPT**.

## OpenCode EnMaaS (corporate)

The EnMaaS profile config is tracked at `dotfiles/opencode/enmaas.opencode.json`
and its TUI settings at `dotfiles/opencode/cli.json`. `make link` links the
config to `~/.config/opencode-enmaas/opencode/opencode.json` and the shared TUI
settings to both profiles.

Start the profile with:

```bash
opencode-enmaas
```

The function reads the key from `~/.netrc` and runs `opencode --standalone` with
fully isolated directories:

| Variable | Purpose |
| --- | --- |
| `ENMAAS_KEY` | Provider credential declared in `providers.enmaas.env`; scoped to this command. |
| `XDG_CONFIG_HOME` | Profile config (`opencode.json`, `cli.json`). |
| `XDG_DATA_HOME` | Database, sessions, snapshots, logs. |
| `XDG_STATE_HOME` | Service registration and prompt history. |
| `XDG_CACHE_HOME` | Caches. |

`--standalone` runs a private server tied to this TUI, so it always sees
`ENMAAS_KEY` and this profile's directories instead of a shared server started
with different settings.

Both profiles also map `Ctrl+u` / `Ctrl+d` to half-page transcript scrolling,
matching nvim and tmux. The conflicting default bindings are remapped:

- `Ctrl+Alt+u` deletes to the start of the line.
- `Delete` and `Shift+Delete` delete characters.
- `Ctrl+c` and `<leader>q` exit.
- `<leader>d` deletes a session.

These keys scroll inside OpenCode's full TUI. tmux copy mode still cannot see
the full transcript because the TUI owns it internally; `opencode mini` writes
the whole transcript to normal scrollback if that behavior is needed.
