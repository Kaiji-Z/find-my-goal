# find-my-goal

**会打字，就会用 /goal。**

```
❌ /goal 帮我优化项目
   → 没判据、没预算、没刹车：循环空转，烧 token，干一半就停

✅ /goal 目标：把 npm test 全量耗时从 baseline 84s 压到 40s 以内，且全部通过
        范围：只许 src/ 与测试文件；不改公开 API，不装新依赖
        完成判据：npm test 退出码 0；连跑 3 次每次 ≤ 40s
        停止条件：需装新依赖；同一思路连续 3 次失败
        预算：最多 15 轮迭代
   → 一路跑到证据达标才收工
```

右边这份不是让你学会写的——是让 find-my-goal 替你写的。你说人话，答几道选择题，它跑 baseline 拿数字，出稿你粘给 `/goal`。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skill](https://img.shields.io/badge/type-agent--skill-green)](find-my-goal/SKILL.md)

> English README: [README_EN.md](README_EN.md)

## TL;DR

```bash
# 安装（一次性，任选其一）
npx skills add Kaiji-Z/find-my-goal                                # 任意 agent（skills.sh CLI）
git clone https://github.com/Kaiji-Z/find-my-goal ~/.claude/skills/   # Claude Code
git clone https://github.com/Kaiji-Z/find-my-goal ~/.agents/skills/   # ZCode / 通用跨工具位

# 使用（任意会话里，说人话即可）
帮我写个 goal：把我们小程序启动速度弄快点
```

## 它是怎么工作的

```
你说人话 ──► 至多 3 道选择题（每题可选"你帮我定"）──► 跑 baseline 拿数字 ──► 五段式强目标（等你确认）──► 粘给 /goal
```

五段式 = 目标 / 范围 / 完成判据 / 停止条件 / 预算。判据必须是可执行命令 + 期望退出码或阈值——"感觉差不多了"不算完成，这是它防止 /goal 空转的全部秘密。

## Why this exists

ZCode、Codex（0.128+）和装了 omo 的 opencode 都有 `/goal`——内核级的持久目标循环，空闲自动续跑，直到目标达成。很好，除了一个问题：

```
/goal 帮我优化项目
```

这是愿望，不是规格。没有验收判据、没有预算、没有停止条件，循环只能瞎转或干一半就停。官方教程教你写"六要素强 Goal"——但普通用户不该为了用一条命令去学一门 prompt 课。

**find-my-goal 把这门课装进 skill 里**：你答几道选择题（每题都有"你帮我定"选项），它跑 baseline 拿数字，产出这样一份目标：

```
目标：把 npm test 全量耗时从 baseline 84s 压到 40s 以内，且全部通过
范围：只许 src/ 与测试文件、构建配置；不改公开 API 行为，不装新依赖
完成判据：npm test 退出码 0 且全绿；连跑 3 次每次耗时 ≤ 40s
停止条件：需要装新依赖或换运行时；同一优化思路连续 3 次无效
预算：最多 15 轮迭代
```

这份格式对任何循环命令通用：原生 `/goal`、omo 的 `/goal`、`/ralphloop`。

## What you get

| 文件 | 用途 |
|---|---|
| [`find-my-goal/SKILL.md`](find-my-goal/SKILL.md) | 意图路由 + 三道选择题追问（验收/边界/预算）+ baseline 定判据 + 弱目标体检 |
| [`find-my-goal/references/goal-templates.md`](find-my-goal/references/goal-templates.md) | 5 个场景模板：性能优化 / flaky test / 批量任务 / 规格驱动 / 考古研究 |

## Installation

**Option 1：一行安装（推荐）**——见 TL;DR，clone 整个仓库到 skills 目录，`find-my-goal/SKILL.md` 自动落位。

**Option 2：.skill 文件（Claude Desktop / Claude.ai）**——下载 [find-my-goal.skill](find-my-goal.skill)（zip 格式），解压到 skills 目录，或在 Claude Desktop 里拖拽安装：

```bash
curl -L -o /tmp/find-my-goal.skill https://github.com/Kaiji-Z/find-my-goal/raw/main/find-my-goal.skill
unzip -o /tmp/find-my-goal.skill -d ~/.claude/skills/
```

装完新开会话即可，无需配置。

## Usage

三个入口，一句话一个：

| 你说 | 它做 |
|---|---|
| "帮我写个 goal：把我们小程序启动速度弄快点" | 追问 1-3 道选择题，跑 baseline 拿数字，出稿等你确认 |
| "按刚才讨论的方向设个目标" | 从对话收割方向/范围/已有数字，只补缺的项 |
| "我的 goal 一直在空转" | 按硬规则体检重写，提醒清掉旧目标重新 /goal |

典型会话：

```
你：帮我写个 goal：把我们小程序启动速度弄快点
skill：做到什么程度算完成？
       A. 我先看看项目现状，提一个能验证的标准给你确认
       B. 我直接告诉你
       C. 说不清，你定个保守的
你：A
skill：（跑完 baseline）现在冷启动 3.2s，我建议压到 1.5s 以内，
       判据是 `npm run build && npm test` 全绿 + 模拟器冷启动 ≤1.5s，
       最多 15 轮，卡住就停。确认后粘给 /goal 执行——出稿：

       目标：把小程序冷启动从 baseline 3.2s 压到 1.5s 以内
       范围：……
```

> **口诀：先写后跑。** 别直接打 `/goal 弱目标`（内核会立刻执行，skill 拦不到）；先让 skill 写好，再 `/goal` 粘贴。

## 设计原则

1. **证据完成**：判据必须可执行（命令 + 退出码/阈值），"感觉差不多了"不算。
2. **有刹车**：预算和停止条件必填——没有刹车的长跑目标会烧掉你的钱。
3. **人是开关**：未经确认不定稿；目标文本自包含，不怕上下文压缩、换会话。
4. **不越界**：不检测你的 agent 有没有 /goal、不模拟运行时——起草归 skill，循环归内核。

## 与 [win4r/goal-prompt-builder](https://github.com/win4r/goal-prompt-builder) 的区别

定位致敬（同为 /goal 起草器），差异化三点：**中文交互与产出**（它英文、面向 Codex）；**选择题式追问**（答不出"验证面是什么"也没关系，每题都有"你帮我定"）；**交付格式通用**（原生 /goal、omo /goal、/ralphloop 都能吃）。

## Contributing

正本只有一份：`find-my-goal/SKILL.md`（+ `references/goal-templates.md`）。改完跑 `./sync.sh`，一键同步到本机两个安装位并重新打包 `.skill`。记得用全角引号「」写 frontmatter——ASCII 引号会截断 YAML。

## FAQ

**我的 agent 没有 /goal，能用吗？** 能。装了它，说"设个目标"照样走起草流程；出稿后说一声"我没有 /goal"，它直接在当前会话按目标循环执行（每轮验证判据，达标才收工）。

**会误触发吗？** 只认消息中的"目标/goal"字样。单纯的"帮我优化项目"不会触发，不和其他 skill 撞车。

**支持哪些 agent？** 任何支持 skills 目录标准的：Claude Code、ZCode、opencode，以及支持 .skill 文件的 Claude Desktop / Claude.ai。Codex CLI 用户不需要装它——把 README 里那份交付格式抄去写目标即可。

## License

[MIT](LICENSE) © Kaiji-Z
