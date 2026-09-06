# find-my-goal

**If you can type, you can use /goal.** · [中文说明](README.zh-CN.md)

```
❌ /goal optimize my project
   → no criteria, no budget, no brake: the loop wanders, burns tokens, stalls halfway

✅ /goal Goal: cut full npm test time from baseline 84s to under 40s, all green
        Scope: only src/ and tests; no public API changes, no new deps
        Done when: npm test exit 0; 3 consecutive runs each ≤ 40s
        Stop if: needs new deps; same idea fails 3 times
        Budget: max 15 iterations
   → runs until the evidence says done
```

You don't learn to write the right-hand side — find-my-goal writes it for you. Say it in plain words, answer a few multiple-choice questions, paste the draft into `/goal`. Works in English or Chinese.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skill](https://img.shields.io/badge/type-agent--skill-green)](find-my-goal/SKILL.md)

## TL;DR

```bash
# Install (one-time, pick one)
npx skills add Kaiji-Z/find-my-goal                                   # any agent (skills.sh CLI)
git clone https://github.com/Kaiji-Z/find-my-goal ~/.claude/skills/   # Claude Code
git clone https://github.com/Kaiji-Z/find-my-goal ~/.agents/skills/   # ZCode / cross-tool

# Use (in any session, plain language)
Help me write a goal: make our mini-app start faster
```

## How it works

```
you speak plainly ──► at most 3 multiple-choice questions (every one has a "you decide" option)
──► a baseline run for real numbers ──► a five-part strong goal (awaits your confirmation)
──► paste into /goal
```

The five parts = Goal / Scope / Done-when / Stop-if / Budget. Criteria must be an executable command + expected exit code or threshold — "feels done" doesn't count. That is the entire secret of stopping /goal from spinning.

## Why this exists

ZCode, Codex (0.128+) and opencode-with-omo all have `/goal` — a kernel-level persistent goal loop that auto-continues until the goal is verifiably done. Great, except:

```
/goal optimize my project
```

That's a wish, not a spec. No criteria, no budget, no stop conditions — the loop wanders. The official guide — [Using Goals in Codex](https://developers.openai.com/cookbook/examples/codex/using_goals_in_codex) (OpenAI Developer Cookbook) — teaches the "six elements of a strong goal". This skill's five-part format is distilled from that officially recommended practice, so you never have to learn it: **find-my-goal puts the course inside the skill.**

## What you get

| File | Purpose |
|---|---|
| [`find-my-goal/SKILL.md`](find-my-goal/SKILL.md) | Intent routing + 3 multiple-choice questions (acceptance / boundaries / budget) + baseline-driven criteria + weak-goal audits — bilingual EN/中文 |
| [`find-my-goal/references/goal-templates.md`](find-my-goal/references/goal-templates.md) | 5 scenario templates: performance / flaky test / batch / spec-driven / research — bilingual |

## Installation

**Option 1: one line (recommended)** — see TL;DR; clone the repo into your skills directory and `find-my-goal/SKILL.md` lands in place.

**Option 2: .skill file (Claude Desktop / Claude.ai)** — download [find-my-goal.skill](find-my-goal.skill) (zip format), unzip into your skills directory, or drag-install in Claude Desktop:

```bash
curl -L -o /tmp/find-my-goal.skill https://github.com/Kaiji-Z/find-my-goal/raw/main/find-my-goal.skill
unzip -o /tmp/find-my-goal.skill -d ~/.claude/skills/
```

Open a fresh session after installing. No configuration needed.

## Usage

Three entrances, one sentence each (English or Chinese):

| You say | It does |
|---|---|
| "Help me write a goal: make our mini-app start faster" | Asks 1-3 multiple-choice questions, runs a baseline for numbers, drafts for your confirmation |
| "Set a goal based on what we just discussed" | Harvests direction/scope/numbers from the conversation, fills only the gaps |
| "My goal keeps spinning" | Audits against hard rules, rewrites, reminds you to clear and re-set /goal |

> **Mantra: draft first, run later.** Don't paste a weak goal straight into `/goal` — the kernel executes it before any skill can help; let the skill write it first.

A typical session:

```
You: Help me write a goal: make our mini-app start faster
Skill: What counts as done?
       A. I'll look at the project and propose a verifiable standard for your confirmation
       B. I'll tell you directly
       C. Can't say — you pick a conservative one
You: A
Skill: (runs a baseline) Cold start is currently 3.2s; I suggest under 1.5s,
       criteria: `npm run build && npm test` green + cold start ≤ 1.5s on the emulator,
       max 15 rounds, stops and asks if stuck. Confirm to hand to /goal — draft:

       Goal: cut mini-app cold start from baseline 3.2s to under 1.5s
       Scope: ...
```

## Design principles

1. **Evidence-based completion**: criteria must be executable (command + exit code / threshold). "Feels done" doesn't count.
2. **Always a brake**: budget and stop conditions are mandatory — a goal without brakes burns your money.
3. **Human is the switch**: no final draft without your confirmation; goal text is self-contained across compaction and sessions.
4. **No overreach**: never detects whether /goal exists, never emulates the runtime — drafting belongs to the skill, looping belongs to the kernel.

## FAQ

**No /goal in my agent?** Still works — tell it so, and it executes the goal in the current session (verify criteria each round, stop only when all pass).

**False triggers?** Only fires on messages containing "goal"-like words (goal / 目标). A plain "optimize my project" won't trigger it.

**Which agents?** Anything with a skills directory: Claude Code, ZCode, opencode, plus Claude Desktop / Claude.ai via the `.skill` file. Codex CLI users don't need it — just reuse the delivery format above.

## Contributing

One source of truth: `find-my-goal/SKILL.md` (+ `references/goal-templates.md`). After editing, run `./sync.sh` to sync both local install locations and repackage the `.skill` file. Use fullwidth quotes 「」 in frontmatter — ASCII quotes truncate YAML.

## License

[MIT](LICENSE) © Kaiji-Z
