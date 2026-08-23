---
name: find-my-goal
description: Zero-barrier /goal drafter · 零门槛 /goal 起草器。Trigger only when the user message contains the word goal or 目标 — e.g. set a goal / help me write a goal / turn this into a goal / my goal keeps spinning / 设个目标 / 帮我写个 goal / 按刚才讨论的设个目标 / 我的 goal 在空转 — or types "/goal optimize my project" as plain text (which usually means the agent has no native /goal). Drafts the vague wish or the discussion conclusion into strong goal text — executable acceptance criteria, scope, iteration budget, stop conditions — for pasting into /goal or any loop command. Interact and deliver in the user's language (English or Chinese). Do NOT trigger on plain task requests with no goal wording (如单纯的「帮我优化项目」), to avoid colliding with other skills.
---

# find-my-goal · Zero-Barrier Goal Drafter · 零门槛写强目标

**Mental model:** say a wish with the word "goal" in it → answer a few multiple-choice questions → paste the resulting strong goal into /goal.
**心智模型：** 说带"目标/goal"的愿望 → 答几道选择题 → 把产出的目标交给 /goal 跑。

/goal itself is the agent kernel's loop mechanism (persistent state, auto-continuation, completion verification) — never mind that, and never try to detect whether it exists. **Your one job:** translate a vague wish like "optimize my project" into a verifiable, braked, strong goal. The prompt-writing knowledge lives in you, not in the user. Interact and produce the final goal text in the user's language (English users get English goals, 中文用户得到中文目标).
/goal 本身是 agent 内核的循环机制（持久状态、自动续跑、完成校验），那些不用你操心，也不要去检测它存不存在。**你只负责一件事**：把"帮我优化项目"这类模糊愿望，翻译成一段可验证、有刹车的强目标。写好 prompt 的知识在你这里，不在用户那里。始终用用户的语言交互与出稿。

## DRAFT Flow · 起草流程

### 0. Harvest the existing discussion · 先收割已有讨论

When the user says "set a goal based on what we discussed" / 按刚才讨论的设个目标 — the richest information source is this conversation, not questioning:

- **Extract**: the agreed direction, files/modules involved, constraints already stated, numbers already measured (if a test/benchmark was run during the discussion, use it as the baseline — do not re-run).
- **Gap-check against the delivery format** (goal / scope / criteria / stop / budget): ask only what is truly missing — with context in hand that is usually just criteria details and budget, one or two multiple-choice questions. You have seen the context, so you should ask less than in a cold start.
- **Bake key decisions into the goal text**: approach trade-offs, known pitfalls, explicit user preferences — either in the goal itself, or (when long) into `.goal/SPEC.md` with the goal pointing at it. Goal execution spans context compaction and even session switches; the goal text must be self-contained.
- **提取**：商定的方向、涉及的文件/模块、已说过的约束、讨论中已跑过的数字（讨论时跑过测试/benchmark 就直接用作 baseline，不要重跑）。
- **对照交付格式查缺**：目标/范围/判据/停止条件/预算——只问真正缺的。带着上下文来时通常只剩判据细节和预算，一两道选择题就够；判据缺失时基于讨论内容直接提一个让用户确认，你见过上下文，问得就该比冷启动少。
- **关键决定写进目标文本**：讨论中的方案取舍、已知坑、用户明确的偏好，要么写进目标本身，细节多时写入 `.goal/SPEC.md` 并让目标指向它——目标执行会跨上下文压缩甚至换会话，目标文本必须自包含。

### 1. Vague-word detection · 模糊词检测

If the wish contains words with no verifiable endpoint — optimize / improve / clean up / refactor a bit / make it better / 优化 / 提升 / 清理 / 完善 / 更好 / 增强 — **do not draft directly**: it is a wish, not a spec; go to questioning. (If the wish already has a verifiable endpoint, e.g. "fix all 47 failing tests", skip questioning and draft for confirmation.)
愿望里出现"优化 / 提升 / improve / optimize / 清理 / clean up / 重构一下 / 完善 / 更好 / 增强"这类没有可验证终点的词时，**不要直接出稿**——这句话是愿望，不是规格，进入追问。（若愿望本身已含可验证终点，如"把 47 个 failing 测试修到全绿"，跳过追问直接出稿确认。）

### 2. Multiple-choice questioning (max 3 rounds) · 选择题式追问（最多 3 轮）

Rules: one question per round; 2-3 options each; one option is always "you decide"; if the user is impatient or cannot answer, treat everything as "you decide" and draft directly. Never ask open-ended questions — users cannot answer "what is your verification surface". Ask in the user's language.
规则：一轮只问一个问题；每个问题给 2-3 个选项；选项里永远有一个"你帮我定"；用户嫌烦或答不上来，全部按"你帮我定"处理，直接出稿。绝不做开放式提问——用户答不出"验证面是什么"这种问题。用用户的语言提问。

> **Q1 Acceptance · 验收** — For "{wish}", what counts as done? / 「{原话}」做到什么程度算完成？
> A. I'll look at the project and propose a verifiable standard for your confirmation · 我先看看项目现状，提一个能验证的标准给你确认
> B. I'll tell you directly (free input) · 我直接告诉你（自由输入）
> C. Can't say — you pick a conservative one · 说不清，你定个保守的

> **Q2 Boundaries · 边界** — What may be touched during the work? / 过程中只允许动哪些东西？
> A. Related files freely, but no public-interface changes beyond tests / no new deps (default) · 相关文件随便动，但别碰测试之外的公开接口、别装新依赖（默认）
> B. Only the files I list · 只许改我指定的文件
> C. You judge · 你判断

> **Q3 Budget · 预算** — How many iterations at most? / 最多试多少轮？
> A. 15 (default) · 15 轮（默认）
> B. You set it by task size · 你按任务规模定
> C. I'll name a number · 我说个数

### 3. When you decide (user picked A/C or didn't answer) · 你帮用户定时

Go look at the project: read the relevant code and config; run a baseline if runnable (tests, build, benchmark). Translate the vague word into **numeric criteria**: concrete command + expected exit code or output threshold. When unsure, pick the more conservative, more easily verified criterion. — Example: "optimize my project" + all "you decide" → "cut full `npm test` time from baseline 84s to under 40s, all green".
去看项目：读相关代码和配置，能跑就跑一次 baseline（测试、构建、benchmark）。把模糊词翻译成**带数字的判据**：具体命令 + 期望退出码或输出阈值。拿不准就选更容易验证、更保守的判据。例："帮我优化项目" + 全套"你帮我定" → "把 `npm test` 全量耗时从 baseline 84s 压到 40s 以内，且全部通过"。

### 4. Draft and confirm · 出稿确认

Generate the full goal in the delivery format, show it verbatim, and say "**confirm to hand it to your /goal** / **确认后交给你的 /goal 执行**". Revise until confirmed. **No final draft without user confirmation.**
按交付格式生成完整目标，原文展示给用户，明确说"确认后交给你的 /goal 执行"。用户要改就改，改完再确认。**未经确认不定稿。**

## Delivery format · 交付格式

Every loop command (native /goal, omo's /goal, /ralphloop…) consumes a plain goal text; this format works for all. Produce it in the user's language:
各家循环命令吃的都是一段目标文本，这份格式通用。用用户的语言出稿：

```
Goal · 目标：{one sentence with numbers · 一句话结果，含数字}
Scope · 范围：only {scope}; never touch {forbidden} · 只许 {范围}；禁碰 {禁区}
Done when · 完成判据：{command + expected exit code/output threshold} (multiple allowed, each verifiable · 可多条，逐条可验证)
Stop if · 停止条件：{things needing user decisions; same idea failing 3 times in a row · 需要用户决策的事；同一思路连续 3 次失败}
Budget · 预算：max {N} iterations · 最多 {N} 轮迭代
```

When details are too many (or the goal goes to Codex, capped at 4000 chars): write them into a project file (e.g. `.goal/SPEC.md`) and have the goal say "read .goal/SPEC.md first and confirm before executing".
细节过多时（或目标给 Codex，其限 ≤4000 字符）：把细节写入项目文件（如 `.goal/SPEC.md`），目标文本里写"先读 .goal/SPEC.md 并确认后执行"。

## Hard rules · 硬规则

- **The ambition of the criteria decides the round count · 判据的野心决定轮数**：criteria satisfiable in one round end the goal (correctly) in one round — that is not a fault. If the task is iterative-experimental by nature (performance tuning, flaky-test hunting, approach exploration), do two things: set criteria at a level "unlikely to be reached in a single attempt" (84s → 40s, not 84s → 75s); and write the iteration structure into the goal, e.g. "each round validates exactly one idea, measure and record before the next round; no multiple changes within one round". Add the anti-cheat clause: tests, benchmarks, or the criteria themselves must not be modified to satisfy the criteria. 若任务本质是迭代实验，判据要定在「单次尝试难以一次达到」的水平，并写明迭代结构，同时禁止改测试/基准/判据本身来凑达标。
- Criteria must be **executable and re-checkable**: concrete command + expected exit code/threshold. "All better" / "全部变好" is not a criterion. 完成判据必须可执行、可复核。
- Budget and stop conditions are mandatory. A long-running goal without brakes burns the user's money. 预算和停止条件必填——没有刹车的长跑目标会烧掉用户的钱。
- Scope is mandatory, with explicit forbidden zones. 范围必填，明确禁区。
- No final draft without user confirmation; the user's word overrides. 用户没确认不定稿；用户改口径以用户为准。
- Always interact and deliver in the user's language. 始终用用户的语言交互与出稿。

## Special cases · 特殊情况

- The user typed "/goal ..." as plain text (only happens when the agent has no native /goal), or says "I don't have /goal": don't detect, don't recommend other tools — ask one question: "want me to execute this goal directly in the current session? I'll verify each criterion per round". If yes, execute per the goal text: each round make changes → re-run criterion commands for evidence → stop only when all pass; stop and ask when a stop condition hits. 用户在消息文本里输入了 "/goal ……"或明说"我没有 /goal"：问一句"要我在当前会话里直接执行吗"，说行就按目标文本逐轮验证推进。
- The user shows an already-written goal asking "is this strong enough", or complains "my goal is spinning / drifting": spinning is almost always a weak goal (no criteria, no budget). Audit against the hard rules, rewrite with changes marked; if that goal is already running, remind the user to clear it and re-set with the new text. 用户求体检或抱怨空转：按硬规则逐条重写，并提醒清掉旧目标重新设置。
- The user pastes "/goal weak-text" in a client WITH a native command: the kernel intercepts it before any skill can see it — whenever you do get to talk, teach the mantra "**draft first, run later** / **先写后跑**": say 'help me write a goal' first, then paste into /goal. 有原生命令的客户端里弱目标会被内核直接执行，skill 拦不住——有机会对话就传达口诀。

## Scenario templates · 场景模板

When drafting, consult `references/goal-templates.md` (performance / flaky test / batch / spec-driven / research · 性能优化 / flaky test / 批量任务 / 规格驱动 / 考古研究 — each already has criteria and brakes, bilingual).
起草时参考 `references/goal-templates.md`（双语的 5 个场景模板，均已含判据与刹车）。
