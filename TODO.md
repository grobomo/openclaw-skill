# openclaw-skill

## Overview
Claude Code skill for talking to local OpenClaw instances. Knowledge skill (SKILL.md), not a code wrapper.

## Tasks
- [x] T001: Create SKILL.md with openclaw HTTP API docs, gotchas, auth, live URLs (PR #1)
- [x] T002: Review for secrets/PII/bad code (PR #1 — fixed /root/ hardcode, no secrets/PII found)
- [ ] T003: Publish to grobomo marketplace (claude-code-skills repo)
- [x] T004: Create separate grobomo/openclaw-skill GitHub repo (https://github.com/grobomo/openclaw-skill)

## Key Research (done in dd-lab session 2026-04-18)

### What works
- HTTP API at `localhost:18789/v1/chat/completions` (OpenAI-compatible)
- Auth: Bearer token from `~/.openclaw/openclaw.json` → `auth.token` field
- Model: `openclaw` (routes to configured default, currently claude-4.6-opus via RDsec)

### Gotchas discovered
1. `openclaw agent` CLI needs env vars (RDSEC_API_KEY, SLACK_BOT_TOKEN) that only the systemd service has — CLI calls fail with missing env warnings
2. `openclaw agent` requires `--to`, `--session-id`, or `--agent` flag — no default session
3. HTTP API returns `401 Unauthorized` without Bearer token (even though it's localhost)
4. Token is in `~/.openclaw/openclaw.json` under `auth.mode: "token"` / `auth.token: "..."`
5. WSL proxy warning is cosmetic noise — doesn't affect functionality
6. Gateway must be running: `systemctl --user status openclaw-gateway`

### Sources
- OpenClaw docs: https://docs.openclaw.ai/cli
- openclaw.json config: `wsl -e cat ~/.openclaw/openclaw.json`
- Gateway service: `wsl -e systemctl --user status openclaw-gateway`
