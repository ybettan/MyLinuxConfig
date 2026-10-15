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
reasoning effort. Codex reads the gateway key from `.netrc` when it needs to
authenticate, without exporting it into the shell environment.

Add an EnMaaS entry to `~/.netrc`, preserving any existing Jira entries:

```bash
machine api.enmaas.devshift.net
  login enmaas
  password <your-enmaas-api-key>
```

Keep `.netrc` private and out of source control:

```bash
chmod 600 ~/.netrc
```

Add this entry on each machine where Codex runs. Start an EnMaaS session with:

```bash
codex-corp-enmaas
```

Pass any Codex CLI options after the function name, for example
`codex-corp-enmaas --model gpt-6-luna`.

If EnMaaS returns `401 Unauthorized`, replace the key in this `.netrc` entry
with a valid EnMaaS key.
