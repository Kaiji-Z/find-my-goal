# Goal Scenario Templates · 场景模板（EN / 中文）

Adapt to the user's project; replace numbers with real measured values (run a baseline if you don't have one). Produce the final goal in the user's language. Every template already includes criteria, brakes and budget.
起草时按场景套用，数字换成用户项目的实测值（拿不到就先跑 baseline）。用用户的语言出稿。每个模板都已含验收判据、刹车和预算。

## 1. Performance · 性能优化

The wish is usually "make it faster". Run a baseline before drafting.
用户原话一般是"帮我优化一下性能/速度"。出稿前必须先跑一次 baseline 拿到当前数字。

```
Goal: cut full `npm test` time from baseline 84s to under 40s, all green
Scope: only src/, tests and build config; no public-API behavior changes, no new deps
Done when: `npm test` exit 0 and green; 3 consecutive runs each ≤ 40s (report the three numbers)
Stop if: needs new deps or a runtime swap; the same optimization idea fails 3 times in a row
Budget: max 15 iterations; each round validates one idea, measure and record before the next
```

```
目标：把 `npm test` 全量耗时从 baseline 84s 压到 40s 以内，且全部通过
范围：只许 src/ 与测试文件、构建配置；不改公开 API 行为，不装新依赖
完成判据：`npm test` 退出码 0 且全绿；连跑 3 次，每次耗时 ≤ 40s（完成时附上三次数字）
停止条件：需要装新依赖或换运行时；同一优化思路连续 3 次无效
预算：最多 15 轮迭代；每轮只验证一种思路，测量记录后再进入下一轮
```

## 2. Flaky test · 间歇失败测试

The endpoint is "green N times in a row", not "green this once".
终点是"连续 N 次全绿"，不是"这次绿了"。

```
Goal: find and fix the intermittent failure of `login → refresh` in `tests/auth.test.js`
Scope: only code and tests related to that case; no public-API changes; never skip or weaken assertions to get green
Done when: root cause given with evidence (logs / race-timing analysis); that case alone passes 20 consecutive runs; full suite passes 3 consecutive runs
Stop if: root cause is inside a third-party lib (swap or upstream issue needed); cannot reliably reproduce for 3 straight rounds
Budget: max 15 iterations
```

```
目标：查明 `tests/auth.test.js` 的 `login → refresh` 用例间歇性失败的原因并修复
范围：只许该用例相关代码与测试；不改公开 API 行为，不为变绿而跳过/放宽断言
完成判据：完成时给出根因与证据（日志/竞态时序分析）；该用例单独连跑 20 次全绿；全量测试连跑 3 次全绿
停止条件：根因在第三方库内部需换库或提 upstream issue；连续 3 轮无法稳定复现
预算：最多 15 轮迭代
```

## 3. Batch task · 批量任务

Wishes with a clear count ("expand the word list to 1000").
用户原话："把词库扩到 1000 条"这类有明确数量的活。

```
Goal: expand src/data/words.json from 214 to 1000 unique entries, schema unchanged
Scope: only src/data/words.json; no schema changes, no validator changes, no new deps
Done when: `node tools/validate.js` exit 0; unique entries = 1000 (`jq 'length' src/data/words.json`)
Stop if: passing validation requires touching other files; validation fails 3 times in a row
Budget: max 10 iterations
```

```
目标：把 src/data/words.json 的词库从 214 条唯一词条扩展到 1000 条，schema 不变
范围：只许 src/data/words.json；不改 schema、不改校验脚本、不装新依赖
完成判据：`node tools/validate.js` 退出码 0；唯一词条数 = 1000（`jq 'length' src/data/words.json` 验证）
停止条件：需要修改其他文件才能通过校验；校验连续失败 3 次
预算：最多 10 轮迭代
```

## 4. Spec-driven · 规格驱动

"Implement per the spec." When details don't fit the goal text, externalize to a file.
用户原话："按 spec 实现"。细节放不下时写入项目文件、目标指向文件。

```
Goal: implement the change in openspec/changes/add-rerank/ strictly per its spec; read all spec files and confirm understanding before starting
Scope: only files listed in the spec; no behavior changes beyond the spec
Done when: every task in tasks.md checked, each with its change listed at completion; `npx tsc --noEmit` exit 0; `npm test` green; README/CHANGELOG updated per spec
Stop if: the spec is internally inconsistent or missing key info; the implementation must deviate from the spec design
Budget: max 20 iterations
```

```
目标：严格按 openspec/changes/add-rerank/ 的规格实现该变更，先读全部规格文件并确认理解后再动手
范围：只许规格中列出的文件；不做规格未提及的行为变更
完成判据：tasks.md 全部任务勾选，完成时逐项列出对应改动；`npx tsc --noEmit` 退出码 0；`npm test` 全绿；README/CHANGELOG 已按规格更新
停止条件：规格内部矛盾或缺失关键信息；实现需要偏离规格设计
预算：最多 20 轮迭代
```

## 5. Research / archaeology · 考古 / 研究型

The deliverable is a report file; criteria are file existence plus required sections.
产出是一份报告文件，判据是文件存在且覆盖约定的章节。

```
Goal: determine the cause of slow order-service memory growth since 2026-07; deliver docs/findings/memory-2026-08.md
Scope: read-only analysis (logs, metrics, code); report goes to docs/findings/; no production code changes
Done when: the report exists with four sections — symptoms & data / investigation path / conclusions with evidence / recommended fixes; every conclusion cites its evidence (log excerpt, code location, metric screenshot path)
Stop if: production access is required; data insufficient for any conclusion (the report must say what data is missing)
Budget: max 12 iterations
```

```
目标：查明 2026-07 以来订单服务内存缓慢增长的原因，产出报告 docs/findings/memory-2026-08.md
范围：只读分析（日志、metrics、代码）；报告写到 docs/findings/；不改生产代码
完成判据：报告存在，含四节：现象与数据 / 排查路径 / 结论（含证据）/ 建议修复方案；每条结论都标注证据来源（日志片段、代码位置、metric 截图路径）
停止条件：需要生产环境操作权限；数据不足以支撑任何结论（报告写明缺什么数据）
预算：最多 12 轮迭代
```
