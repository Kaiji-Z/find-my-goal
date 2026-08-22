# find-my-goal

**会打字，就会用 /goal。**

你的 agent 有 `/goal`（ZCode、Codex、装了 omo 的 opencode……），但你打出的是：

```
/goal 帮我优化项目
```

——然后它空转、烧 token、干完一半就停。问题不在 /goal，在于这是一句**愿望**，不是**规格**。本 skill 把愿望翻译成规格：你只管说人话、答几道选择题，它产出一份带验收判据、范围约束、迭代预算和停止条件的强目标，你粘给 /goal 跑。

> **口诀：先写后跑。** 别直接打 `/goal`，先说"帮我写个 goal"，拿到成品再 `/goal` 粘贴执行。

## 它做什么 / 不做什么

- ✅ 把"帮我优化项目"起草成"把 `npm test` 全量耗时从 baseline 84s 压到 40s 以内，且全部通过（最多 15 轮，卡住就停）"
- ✅ 从已有讨论中收割目标（"按刚才讨论的设个目标"），只补缺的项，最多问你一两道选择题
- ✅ 体检已写好的 goal（"我的 goal 在空转"→ 逐条补判据、预算、刹车）
- ✅ 你的 agent 没有 /goal？说一声，它直接在当前会话按目标循环执行
- ❌ 不替代 /goal 的运行时（持久状态、自动续跑、完成校验是 agent 内核的事，不重复造）
- ❌ 不含"目标/goal"字样的普通请求不触发，不和其他 skill 撞车

## 安装

**ZCode / 任何认 `~/.agents/skills/` 的 agent（推荐）：**

```bash
git clone https://github.com/Kaiji-Z/find-my-goal ~/.agents/skills/find-my-goal
```

**Claude Code：**

```bash
git clone https://github.com/Kaiji-Z/find-my-goal ~/.claude/skills/find-my-goal
```

Windows（Git Bash）同命令；PowerShell 用户把 `~` 换成 `$HOME`。

装完新开会话即可，无需配置。

## 用法

三句话，覆盖 90% 场景：

| 你说 | 它做 |
|---|---|
| "帮我写个 goal：把我们小程序启动速度弄快点" | 追问 1-3 道选择题（每题都有"你帮我定"选项），跑 baseline 拿数字，出稿等你确认 |
| "按刚才讨论的方向设个目标" | 从对话里收割方向/范围/已有数字，只补缺的项 |
| "我的 goal 一直在空转" | 按硬规则体检重写，提醒清掉旧目标重新 /goal |

出稿长这样（各家 /goal、/loop、/ralphloop 通用）：

```
目标：把 npm test 全量耗时从 baseline 84s 压到 40s 以内，且全部通过
范围：只许 src/ 与测试文件、构建配置；不改公开 API 行为，不装新依赖
完成判据：npm test 退出码 0 且全绿；连跑 3 次每次耗时 ≤ 40s
停止条件：需要装新依赖或换运行时；同一优化思路连续 3 次无效
预算：最多 15 轮迭代
```

## 设计原则

1. **证据完成**：判据必须可执行（命令 + 退出码/阈值），"感觉差不多了"不算。
2. **有刹车**：预算和停止条件必填——没有刹车的长跑目标会烧掉你的钱。
3. **人是开关**：未经你确认不定稿；目标文本自包含（不怕上下文压缩、换会话）。

## 与 goal-prompt-builder 的区别

同为 /goal 起草器（定位致敬 win4r/goal-prompt-builder），差异化三点：中文交互与中文产出；选择题式追问（答不出"验证面是什么"也没关系，每题都有"你帮我定"）；交付格式对任何循环命令通用（原生 /goal、omo /goal、/ralphloop）。

## 插件市场提交

`plugin/` 目录是 ZCode / Claude Code 插件市场格式（`.zcode-plugin/plugin.json` + `skills/`），可整目录提交到 marketplace 仓库。修改 skill 后记得跑 `./sync-plugin.sh` 同步双份。

## License

MIT
