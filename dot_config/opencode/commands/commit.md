---
description: Create atomic git commits with smart style detection
subtask: true
---

Load the `git-master` skill and execute a commit following its full protocol.

Current git state:

!`git status`

!`git diff --staged`

!`git diff`

Recent history (for style + language detection):
!`git log --oneline -20`

Follow the git-master COMMIT mode protocol exactly:
1. Detect commit message language (English/Korean) and style (conventional/plain/short) from git log
2. If nothing is staged, stage all tracked changes (`git add -u`)
3. Split into MULTIPLE atomic commits — different concerns = different commits (3+ files = 2+ commits minimum)
4. Commit in dependency order: utilities → models → services → config
5. Each commit message must match detected style and language
6. Add footer to every commit: `Co-authored-by: t1dotdev`
7. Run `git status` at end to verify clean working directory

$ARGUMENTS
