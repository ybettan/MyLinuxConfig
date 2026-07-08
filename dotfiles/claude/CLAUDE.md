# Global Claude Instructions

## GitHub CLI

Use the standard `gh` command for read-only operations (viewing PRs, fetching diffs, listing comments).
Only use the `gh-rw` alias for write operations (posting comments, creating reviews, approving/requesting changes).

## Jira CLI

When updating a Jira issue description, always write the content to a temporary file first, then pipe it via stdin:
`cat /tmp/jira-desc.md | jira issue edit ISSUE-KEY --no-input`
The `-b` flag does not work reliably for multi-line descriptions. The stdin pipe is the only reliable method.

## Git

Always use the `-s` flag when running `git commit` to include a `Signed-off-by` trailer.
