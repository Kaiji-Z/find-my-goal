#!/usr/bin/env bash
# 同步 skill 正本 → 两个本机安装位 + 打包 find-my-goal.skill（zip 格式，Claude Desktop / Claude.ai 用）
set -e
cd "$(dirname "$0")"
for d in ~/.agents/skills/find-my-goal ~/.claude/skills/find-my-goal; do
  mkdir -p "$d/references"
  cp find-my-goal/SKILL.md "$d/SKILL.md"
  cp find-my-goal/references/goal-templates.md "$d/references/"
done
rm -f find-my-goal.skill
python -m zipfile -c find-my-goal.skill find-my-goal
echo "synced: ~/.agents/skills + ~/.claude/skills + find-my-goal.skill"
