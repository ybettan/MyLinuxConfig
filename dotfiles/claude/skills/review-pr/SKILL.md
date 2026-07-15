---
name: review-pr
description: Review a GitHub pull request. Use when the user says 'review this PR', 'review PR', 'review these PRs', provides a PR URL, or asks to approve/comment on a pull request. Also use when the user asks 'did they address my comments', 'check my review comments', or wants to follow up on a previously reviewed PR.
---

# Review Pull Request

Review a GitHub pull request and optionally post inline comments as a review.

## GitHub CLI Convention

- Use `gh` for all read-only operations (viewing PRs, fetching diffs, listing comments, checking CI status)
- Use `gh-rw` only for write operations (posting comments, creating reviews, approving, requesting changes)

## Workflow

### Step 1: Fetch PR details

```bash
gh pr view <number> --repo <owner/repo> --json title,body,state,author,headRefName,baseRefName,additions,deletions,changedFiles
```

### Step 2: Fetch the diff

```bash
gh pr diff <number> --repo <owner/repo>
```

For large diffs, also list changed files first to prioritize review:

```bash
gh pr diff <number> --repo <owner/repo> | grep '^diff --git'
```

### Step 3: Check for existing review comments

```bash
gh api repos/<owner>/<repo>/pulls/<number>/comments
gh api repos/<owner>/<repo>/pulls/<number>/reviews
```

### Step 4: Review and post comments

1. Share the PR link so the user knows which PR is being reviewed (especially when reviewing multiple PRs)
2. Give a short description of what the change does and why it is needed
3. Suggest inline comments or PR-level comments one by one, and ask the user whether to post each one before proceeding to the next

Use `gh-rw` for all write operations. Do not post anything until the user explicitly confirms each comment.

```bash
# Approve
gh-rw pr review <number> --repo <owner/repo> --approve --body "<message>"

# Request changes
gh-rw pr review <number> --repo <owner/repo> --request-changes --body "<message>"

# Comment only
gh-rw pr review <number> --repo <owner/repo> --comment --body "<message>"
```

## Follow-up: Check if comments were addressed

When the user asks whether the PR author has addressed their review comments:

### Step 1: Fetch all review comments and replies

```bash
gh api repos/<owner>/<repo>/pulls/<number>/comments
gh api repos/<owner>/<repo>/pulls/<number>/reviews
```

### Step 2: Report status

1. List each of the user's review comments with its current resolution status (addressed in code, replied to, or unresolved)
2. Present a summary table:

```
| # | Comment | Status |
|---|---------|--------|
| 1 | <short description> | Resolved / Unresolved |
| 2 | <short description> | Resolved / Unresolved |
```

### Step 3: Offer to approve

If the user is the only reviewer and all comments are resolved (or the user confirms they are satisfied with the author's resolutions), ask if they would like to approve the PR.

When the user says "lgtm", post a `/lgtm` comment on the PR:

```bash
gh-rw pr review <number> --repo <owner/repo> --comment --body "/lgtm"
```

$ARGUMENTS
