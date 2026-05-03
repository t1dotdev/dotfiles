---
description: Stage and commit changes with a Conventional Commits message
agent: build
---

You are creating a git commit. Follow this exact workflow.

## Context (gather in parallel)

Run these in a single message, in parallel:

!`git status --short`
!`git diff --stat`
!`git diff --cached --stat`
!`git log -n 10 --pretty=format:'%h %s'`
!`git branch --show-current`

## Rules

1. **Stage intentionally.** If nothing is staged, stage tracked changes with `git add -A` only after confirming the working tree contains exclusively work the user wants committed. If untracked files look unrelated (build artifacts, secrets, scratch files), ask before staging.
2. **Inspect the actual diff** with `git diff --cached` before writing the message. Don't infer from filenames alone.
3. **Write a Conventional Commits message** in this exact shape:

   ```
   <type>(<scope>): <subject>

   <body>
   ```

   - `type`: one of `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`, `style`, `revert`.
   - `scope`: short, lowercase, derived from the touched area (module, package, or feature). Omit the parens entirely if no clear scope exists.
   - `subject`: imperative mood, lowercase first letter, no trailing period, <= 72 chars.
   - `body` (optional): wrap at 72 chars; explain *why* and any non-obvious *what*. Skip the body for trivial single-purpose changes.
   - Add `BREAKING CHANGE: ...` footer when applicable.
   - Match the style of recent commits in `git log` if the repo has an established convention (e.g. ticket prefixes).

4. **Commit with a heredoc** so multi-line messages survive shell quoting:

   ```bash
   git commit -m "$(cat <<'EOF'
   feat(auth): add refresh-token rotation

   Rotate refresh tokens on every use to limit replay window.
   Existing tokens remain valid until their original expiry.
   EOF
   )"
   ```

5. **Do not** add Claude/co-author trailers, emojis, or marketing language. Do not run `git push`. Do not amend prior commits unless the user asks.
6. After committing, run `git status` and `git log -n 1 --stat` and show the result.

## If the user passed arguments

`$ARGUMENTS` may contain a hint (e.g. a scope, a ticket id, or a one-line summary). Honor it: use it as the scope or fold it into the subject/body, but still validate it against the actual diff. If it contradicts the diff, point that out and propose a corrected message before committing.

## If there's nothing to commit

Report `git status` and stop. Don't create empty commits.
