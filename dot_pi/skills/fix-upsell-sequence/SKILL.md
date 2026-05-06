---
name: fix-upsell-sequence
description: Update e2e upsell/downsell sequence from a Jira ticket or description, verify via targeted smoke tests, and open a GitLab MR. Works across any *-playwright-e2e project. Use when upsell product ordering changes.
---

# fix-upsell-sequence

## Parameters

When invoking, provide one of:
- A Jira ticket URL (e.g. `https://kilohealth.atlassian.net/browse/COM-XXXXX`)
- A pasted description of the required upsell sequence changes

## Workflow

> **STOP — Ask the user first:** Before proceeding, ask: "What is your Jira task number for this upsell sequence update work?" (e.g. `AQA-12345`, `COM-99999`, etc.). Use this task number as `MY_TASK_NO` in the commit message.

### 1. Parse Requirements

Extract from input:
- The developer's Jira ticket ID / description that specifies the new upsell sequence orders (by `country` and `funnel`) and any downsell changes.
- Capture the user's own Jira task number (asked above) as `MY_TASK_NO`.

### 2. Discover Repo Layout

All actions are relative to the current working directory (CWD), which must be inside a `*-playwright-e2e` git repo.

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
PROJECT_NAME=$(basename "$REPO_ROOT")
```

Target files to edit (always from repo root):
- `POM/upsell-page.ts`
- `tests/smoke/smoke.spec.ts`
- If the repo does not contain an upsell-page file, abort and inform the user.

### 3. Create Git Worktree & Branch

```bash
# Use ticket ID if available, otherwise generate a descriptive branch name
BRANCH_NAME="${TICKET_ID:-aqa}-update-upsell-sequence"
# Create worktree in a sibling directory named after the branch
WORKTREE_DIR="${REPO_ROOT}-worktrees/${BRANCH_NAME}"
mkdir -p "$(dirname "$WORKTREE_DIR")"
git worktree add -b "$BRANCH_NAME" "$WORKTREE_DIR"
cd "$WORKTREE_DIR"
```

### 4. Isolate Upsell Tests

In `tests/smoke/smoke.spec.ts`, add `.only` to the two relevant tests (names are consistent across `*-playwright-e2e` projects):
- `test.only('Upsell test', ...)`
- `test.only('Downsell flow', ...)`

### 5. Update Sequence in POM

In `POM/upsell-page.ts`:
- Update `upsellsOrder` (accept-flow) to match the new sequence.
- Update `downsellsOrder` if the issue also changes downsell ordering.

### 6. Run Tests

Run the smoke project to execute only the `.only` tests:
```bash
pnpm run playwright test --project=smoke
```

#### On Failure — Diagnose from Logs

If tests fail, locate the latest test output (Playwright HTML report, `test-results/`, terminal output, or CI logs) and read the error for the failed test.

Look specifically for Playwright `expect` mismatch lines such as:
```
Expected pattern: /bioma/
Received string: "https://.../coloncleanse"
```
or
```
expect(received).toHaveURL(expected)
Expected: ...
Received: ...
```

Extract the **expected slug** and the **actual slug** (or full URL) and report them to the user. Use this information to adjust `upsellsOrder` / `downsellsOrder` in `POM/upsell-page.ts` and re-run.

Repeat the edit → run → diagnose loop until both tests pass.

### 7. Clean Up `.only`

Before committing, remove the `.only` markers from both tests in `tests/smoke/smoke.spec.ts` so the full smoke suite remains intact.

### 8. Commit, Push & Open MR

Make a single clean commit:
```bash
git add -A
git commit -m "feat(e2e): update upsell sequence [${MY_TASK_NO}]"
git push -u origin "$BRANCH_NAME"
```

Open the GitLab MR via push options:
```bash
git push -o merge_request.create \
  -o merge_request.title="feat(e2e): update upsell sequence [${MY_TASK_NO}]" \
  -o merge_request.description="[${JIRA_URL}](${JIRA_URL})" \
  origin "$BRANCH_NAME"
```

> **Fallback:** If `git push -o merge_request.create` is not supported by the origin, open the MR manually from the URL pattern:
> `https://git.kilo.dev/${PROJECT_PATH}/-/merge_requests/new`

### 9. Return to Original Worktree

```bash
cd "$REPO_ROOT"
git worktree prune
```
