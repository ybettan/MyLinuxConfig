---
name: jira-cli
description: Jira CLI conventions and workarounds. Use when creating or editing Jira issues, updating descriptions, or working with jira-cli.
---

# Jira CLI Conventions

## Issue Descriptions

When updating a Jira issue description or creating a new Jira issue, always write the content to a temporary file first, then pipe it via stdin:

```bash
cat /tmp/jira-desc.md | jira issue edit ISSUE-KEY --no-input
```

The `-b` flag does not work reliably for multi-line descriptions. The stdin pipe is the only reliable method.

## Creating Issues

Always use `-p OSAC` explicitly when creating issues — the default project in the config is not picked up by `jira issue create`.

```bash
cat /tmp/jira-desc.md | jira issue create -tBug -s "title" -p OSAC -l OSAC --no-input
```

$ARGUMENTS
