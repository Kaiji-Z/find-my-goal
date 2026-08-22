#!/usr/bin/env bash
# 根目录 SKILL.md 是唯一正本；本脚本把它同步到 plugin/ 与两个本机安装位。
set -e
cd "$(dirname "$0")"
for d in plugin/skills/find-my-goal ~/.agents/skills/find-my-goal ~/.claude/skills/find-my-goal; do
  mkdir -p "$d/references"
  cp SKILL.md "$d/SKILL.md"
  cp references/goal-templates.md "$d/references/"
done
echo "synced: plugin/ + ~/.agents/skills + ~/.claude/skills"
