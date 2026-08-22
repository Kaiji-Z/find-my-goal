# find-my-goal

**If you can type, you can use /goal.**

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

You don't learn to write the right-hand side — find-my-goal writes it for you. Say it in plain words, answer a few multiple-choice questions, paste the draft into `/goal`.

> 中文说明：[README.md](README.md)

## TL;DR

```bash
# Install (one-time, pick one)
git clone https://github.com/Kaiji-Z/find-my-goal ~/.claude/skills/   # Claude Code
git clone https://github.com/Kaiji-Z/find-my-goal ~/.agents/skills/   # ZCode / cross-tool

# Use (in any session, plain language)
Help me write a goal: make our mini-app start faster
```

## Why this exists

ZCode, Codex (0.128+) and opencode-with-omo all have `/goal` — a kernel-level persistent goal loop. Great, except:

```
/goal optimize my project
```

That's a wish, not a spec. No criteria, no budget, no stop conditions — the loop wanders. Official guides teach you the "six elements of a strong goal", but ordinary users shouldn't have to take a prompt-writing course to use one command.

**find-my-goal puts the course inside the skill**: you answer a few multiple-choice questions (each with a "you decide" option), it runs a baseline for real numbers, and produces:

```
Goal: cut full `npm test` time from baseline 84s to under 40s, all green
Scope: only src/ and tests/build config; no public API changes, no new deps
Done when: `npm test` exit 0; 3 consecutive runs each ≤ 40s
Stop if: needs new deps or runtime swap; same idea fails 3 times
Budget: max 15 iterations
```

The format works with any loop command: native `/goal`, omo's `/goal`, `/ralphloop`.

## Usage

| You say | It does |
|---|---|
| "Help me write a goal: make the app faster" | Asks 1-3 multiple-choice questions, runs baseline, drafts for your confirmation |
| "Set a goal based on what we just discussed" | Harvests direction/scope/numbers from the conversation, fills only the gaps |
| "My goal keeps spinning" | Audits against hard rules, rewrites, reminds you to re-set /goal |

> **Mantra: draft first, run later.** Don't paste a weak goal straight into `/goal` — the kernel executes it before any skill can help.

## Design principles

1. **Evidence-based completion**: criteria must be executable (command + exit code / threshold). "Feels done" doesn't count.
2. **Always a brake**: budget and stop conditions are mandatory — a goal without brakes burns your money.
3. **Human is the switch**: no final draft without your confirmation; goal text is self-contained across compaction and sessions.
4. **No overreach**: never detects whether /goal exists, never emulates the runtime — drafting belongs to the skill, looping belongs to the kernel.

## FAQ

**No /goal in my agent?** Still works — tell it so, and it executes the goal in the current session (verify criteria each round, stop only when all pass).

**False triggers?** Only fires on messages containing "goal"-like words (目标/goal). A plain "optimize my project" won't trigger it.

**Which agents?** Anything with a skills directory: Claude Code, ZCode, opencode, plus Claude Desktop / Claude.ai via the `.skill` file. Codex CLI users don't need it — just reuse the delivery format above.

## License

[MIT](LICENSE) © Kaiji-Z
