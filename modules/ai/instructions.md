# AI Agent Operating Guidelines

## 🔴 CRITICAL RULES 🔴

### ⛔ NEVER DEPLOY ⛔

**READ BEFORE EVERY ACTION.**

#### FORBIDDEN COMMANDS:
* `npx sst deploy` `npm run deploy` `yarn deploy` `terraform apply`
* `kubectl apply` `docker push` `aws cloudformation deploy`
* `serverless deploy` `cdk deploy` `pulumi up`
* Any deploy/publish/push to live environment

#### NO EXCEPTIONS:
User says "continue" → still no. Just finished changes → still no. Seems logical → still no.

#### INSTEAD: give command, let user run it.
```
 "Changes ready. To deploy: `npx sst deploy`"
 [runs deployment]
```

**Why:** Affects live systems. Costs money. Needs human timing/coordination.

---

### 🚫 Git — NO DESTRUCTIVE COMMANDS

#### ✅ Auto-run OK:
`git add`, `git commit`, `git status`, `git log`, `git diff`, `git show`, `git branch`, `git remote -v`

#### ❌ Never run — give command, let user decide:
`git push` `git reset` `git rebase` `git rm` `git merge`
`git checkout` `git switch` `git stash` `git cherry-pick` `git revert`
`git tag` `git branch -d`

#### ❌ No commit trailers:
No `Co-authored-by`, `Signed-off-by`, or AI attribution. Description only.

#### ✍️ Conventional Commits:

**Format:** `<type>[scope]: <description>`

**Types:** `feat` `fix` `docs` `refactor` `perf` `test` `chore` `ci` `revert`

**Rules:**
* Imperative, lowercase, no period. `fix null pointer` not `Fixed null pointer.`
* Scope = functional domain (`web` `api` `auth` `infra` `ci` `db`) — never tool name (`sst` `npm` `pulumi`)
* Breaking: append `!` or `BREAKING CHANGE:` footer
* Body = why, not what
* Max 72 chars
* No internal IDs (`feat-008` `T017` `issue-42`) — message must make sense standalone

```
 feat(auth): add OAuth2 login support
 fix(api): handle null response from payment provider
 refactor(db): extract query builder into separate module
 feat!: remove support for legacy API v1
 fix stuff / WIP / update config
 fix(sst): upgrade cloudflare provider    ← tool scope
 fix(infra): upgrade cloudflare provider to meet SST requirements
 fix(ci): commit feat-008 changes         ← internal ID
```

---

## Before Every Push — Simulate CI

Run in order, fix all failures before commit:
1. `npm ci` (or equivalent) — strict install
2. Lint — `npm run lint` / `ruff check .`
3. Typecheck — `npm run typecheck` / `mypy .`
4. Tests — `npm test` / `pytest`

CI failure caught locally = no wasted pipeline run.

---

## File Changes

* Modify only what task needs. Small incremental changes. Keep existing style.
* No refactor unless asked.
* No README/CHANGELOG/CONTRIBUTING unless asked. Ask first: "Want docs?"
* Never commit screenshots, logs, temp files, binary blobs. Not even temporarily.
  If file can't be uploaded programmatically → tell user immediately, explain manual step.

---

## Code Changes

* Break into small reviewable steps. No "while we're here" improvements unless asked.
* Focused tests for what changed. Not exhaustive suites.
* **Prefer snapshot/golden file testing** for data transforms, JSON/HTML output, API responses.

---

## Communication

* Short, current-state focused. No verbose history unless asked.
* When uncertain: present options (A/B/C with pros/cons), ask which.

---

## Debug — Investigate Before Assuming

Bug reported → **never jump to conclusion**. Always ask first:
1. What exactly observed? (error, logs, screenshot)
2. Expected vs actual?
3. Consistent or intermittent? Conditions?
4. What do logs show?

```
 "API slow" → immediately adds caching
 "API slow" → ask: which endpoints? response times? check logs first
```

**Workflow:** gather facts → form hypothesis → present it → verify → propose solution → confirm.

---

## Verify Before Publishing

Before stating status in PR/issue/comment — **verify actual current state first**. Session notes go stale.

Must verify:
* Merge status — `git log origin/main`, `gh pr view`
* Deployment status — check pipeline, not notes
* Approval status — check PR, not memory
* Cross-repo state — each repo independent

```
 "AGW changes (etp-infra PR already merged)" — from stale session notes
 Run `git log origin/master` in etp-infra, then state actual status
```

---

## When to Ask vs Act

#### Always ask first:
Deploy commands · git destructive ops · new docs · delete files
Refactor >20 lines · config file changes · new dependencies
Changes touching >3 files · changes across subsystems · "while we're at it" improvements

#### Safe to act:
Bug        features <10 lines · inline comments · running tests · reading filesfixes 

#### Gray area — use judgment:
Test files · multi-file features · changing function signatures

---

## Rules Relax When...

User says "go ahead" / "I trust your judgment" / clearly experienced.

**Still never relax:**
* Deploy commands
* Destructive git ops
* File deletion

When in doubt, ask.

---

## MCP Tools

Only use tools in available list. Never guess or try variations.

If tool missing → say so immediately + give manual command or URL with values filled in.

---

## Pre-Action Checklist

- [ ] User explicitly requested this?
- [ ] Deploy command? → STOP, give command
- [ ] Destructive git? → STOP, ask
- [ ] Undocumented docs/files?
- [ ] Non-code file going to repo?
- [ ] Deleting anything?
- [ ] Breaking existing code?
- [ ] More than asked?
- [ ] State a status (merged/deployed/done) without verifying?

YES to any → ask first.

---

## Priority

1. Safety — don't break, don't lose work
2. User intent — do what was asked
3. Minimal change
4. Clarity
5. Maintainability
