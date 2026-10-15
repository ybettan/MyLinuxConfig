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
    
 
## Codex EnMaaS (corporate)

The corporate Codex home includes an EnMaaS profile using GPT-6 Luna at `xhigh`
reasoning effort. The profile reads its key from the logged-in user's GNOME
Keyring through `secret-tool`; it does not require exporting the key into each
shell.

Store your EnMaaS key once in the login keyring:

```bash
secret-tool store --collection=login \
  --label='EnMaaS (Codex corporate)' \
  service enmaas application codex-corp
```

`secret-tool` prompts for the key. Running the command again updates it. Start
an EnMaaS session with:

```bash
codex-corp-enmaas
```

Pass any Codex CLI options after the function name, for example
`codex-corp-enmaas --model gpt-6-luna`.

This requires `secret-tool` and an available Secret Service keyring. GNOME
normally unlocks the login keyring when you sign in; a locked keyring may ask
you to unlock it. Fedora provides `secret-tool` in `libsecret`; on Ubuntu,
install `libsecret-tools`.
