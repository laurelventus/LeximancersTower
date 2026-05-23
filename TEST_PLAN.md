# Test Plan: Leximancer's Tower

> **版本**: v1.0 | **日期**: 2025-07-17 | **关联**: PRD.md
>
> Godot 4.6 · GDScript · 2D 像素解密单机游戏

---

## 1. Test Strategy Overview

### 1.1 测试金字塔

```
         ╱  Playtest  ╲          ← 真人试玩（定性验证核心体验）
        ╱──────────────╲
       ╱  Puzzle        ╲         ← 每个谜题的可解性 & 难度验证
      ╱  Validation     ╲
     ╱──────────────────╲
    ╱  Integration Tests ╲        ← 系统间交互（咒语→谜题→存档）
   ╱──────────────────────╲
  ╱   Unit Tests (GUT)    ╲       ← 每个 .gd 脚本的独立测试
 ╱──────────────────────────╲
```

### 1.2 测试原则

| 原则 | 说明 |
|---|---|
| **核心系统必测** | 咒语书、存档、对话、谜题状态机——不允许回归 Bug |
| **谜题逐个验证** | 每个谜题独立走通 ≥3 次，确保不存在卡死/不可解状态 |
| **英语难度必校** | 所有游戏内英文文本须经目标玩家（A1–B1）可读性检查 |
| **无卡死保证** | 任何操作组合都不应导致进度锁死（无法继续的游戏状态） |
| **先测后写** | 核心系统写测试 → 实现 → 测试通过 → 进入下一系统 |

---

## 2. Unit Tests (GUT)

> **工具**: [GUT (Godot Unit Test)](https://github.com/bitwes/Gut) v9.x
> **路径**: `tests/unit/`
> **运行**: `gut --path tests/unit/`

### 2.1 测试文件规划

```
tests/
├── unit/
│   ├── test_spell_book.gd           # 咒语书系统
│   ├── test_inventory.gd            # 物品栏系统
│   ├── test_dialogue_manager.gd     # 对话系统
│   ├── test_puzzle_manager.gd       # 谜题状态机
│   ├── test_save_manager.gd         # 存档/读档
│   ├── test_localization.gd         # 中英切换
│   ├── test_player.gd               # 玩家移动 & 交互
│   ├── test_recipe.gd               # 合成/配方逻辑
│   └── test_interactable.gd         # 可交互对象基类
├── integration/
│   ├── test_spell_to_puzzle.gd      # 咒语→谜题 联调
│   ├── test_inventory_to_recipe.gd  # 物品→合成 联调
│   ├── test_dialogue_to_puzzle.gd   # 对话→谜题线索 联调
│   ├── test_save_restore_full.gd    # 完整存档恢复
│   └── test_floor_transition.gd     # 楼层切换状态保持
└── data/
    ├── spell_test_data.json
    ├── puzzle_test_data.json
    └── save_test_data.json
```

### 2.2 test_spell_book.gd

```
测试目标: SpellBookManager (autoload)
```

| ID | 测试用例 | 输入 | 预期输出 |
|---|---|---|---|
| SB-01 | 收集新咒语碎片 | `add_spell("BURN")` | `spells` 数组包含 `"BURN"`，信号 `spell_collected` 发射 |
| SB-02 | 重复收集同一咒语 | 连续两次 `add_spell("BURN")` | 不重复添加，`spells` 中 `"BURN"` 仅出现一次 |
| SB-03 | 施放已收集的咒语 | `cast_spell("BURN", target)` | 返回 `true`，信号 `spell_cast` 发射 |
| SB-04 | 施放未收集的咒语 | `cast_spell("FREEZE", target)` | 返回 `false`，不发射信号 |
| SB-05 | 按分类获取咒语列表 | `get_spells_by_category("element")` | 仅返回 element 类的咒语 |
| SB-06 | 咒语书为空时施放 | `cast_spell("ANY", target)` | 返回 `false` |
| SB-07 | 获取咒语总数 | `get_spell_count()` | 返回已收集咒语数量 |
| SB-08 | 清空咒语书（新游戏） | `reset()` | `spells` 为空数组 |

### 2.3 test_inventory.gd

```
测试目标: InventoryManager (autoload)
```

| ID | 测试用例 | 输入 | 预期输出 |
|---|---|---|---|
| INV-01 | 添加物品 | `add_item("blue_herb")` | 物品栏包含 `blue_herb`，数量=1 |
| INV-02 | 添加多个同种物品 | `add_item("blue_herb")` ×3 | 数量=3 |
| INV-03 | 移除物品 | `remove_item("blue_herb")` | 数量-1，归零时从物品栏移除 |
| INV-04 | 移除不存在的物品 | `remove_item("not_exist")` | 返回 `false`，不报错 |
| INV-05 | 检查是否拥有物品 | `has_item("blue_herb")` | 有→`true`，无→`false` |
| INV-06 | 检查是否拥有足够数量 | `has_items(["blue_herb", "spring_water"])` | 全部有→`true`，缺一→`false` |
| INV-07 | 物品栏容量上限 | 添加到上限+1 | 返回 `false`，不添加（默认上限 20） |
| INV-08 | 清空物品栏 | `reset()` | 物品栏为空 |

### 2.4 test_dialogue_manager.gd

```
测试目标: DialogueManager (autoload)
```

| ID | 测试用例 | 输入 | 预期输出 |
|---|---|---|---|
| DIA-01 | 加载 NPC 对话 | `start_dialogue("owly", "greeting")` | 返回对话行数组 |
| DIA-02 | 逐句推进 | `advance()` | 返回下一句，`is_finished` 为 `false` |
| DIA-03 | 对话结束 | 推进到最后一句后 `advance()` | `is_finished` = `true`，信号 `dialogue_ended` |
| DIA-04 | 关键词高亮解析 | 文本包含 `[color=red]RED[/color]` | 解析为 BBCode 标记文本 |
| DIA-05 | 对话历史记录 | 完整对话结束后 `get_history()` | 返回所有已显示语句数组 |
| DIA-06 | 加载不存在的对话 ID | `start_dialogue("owly", "not_exist")` | 返回空数组，打印 warning |
| DIA-07 | 中断对话（玩家走开） | `interrupt()` | 对话关闭，状态重置 |

### 2.5 test_puzzle_manager.gd

```
测试目标: PuzzleManager (autoload)
```

| ID | 测试用例 | 输入 | 预期输出 |
|---|---|---|---|
| PUZ-01 | 谜题初始状态 | `get_puzzle_state("floor1_main")` | `is_solved` = `false`，`attempts` = 0 |
| PUZ-02 | 提交正确解法 | `submit_solution("floor1_main", correct_input)` | 返回 `true`，`is_solved` = `true`，信号 `puzzle_solved` |
| PUZ-03 | 提交错误解法 | `submit_solution("floor1_main", wrong_input)` | 返回 `false`，`attempts` +1，`is_solved` 仍为 `false` |
| PUZ-04 | 已解决的谜题再次提交 | 先正确解决，再 `submit_solution` | 返回 `true`（幂等），不重复发射信号 |
| PUZ-05 | 获取当前楼层未解谜题 | `get_unsolved_on_floor(1)` | 返回该层未解谜题 ID 列表 |
| PUZ-06 | 谜题依赖检查 | 前置谜题未解时 `is_unlocked("floor2_main")` | 返回 `false` |
| PUZ-07 | 全层谜题解决检测 | 该层全部谜题解决后 `is_floor_complete(1)` | 返回 `true` |

### 2.6 test_save_manager.gd

```
测试目标: SaveManager (autoload)
```

| ID | 测试用例 | 输入 | 预期输出 |
|---|---|---|---|
| SAV-01 | 存档到空槽位 | `save_game(1)` | 返回 `true`，存档文件存在 |
| SAV-02 | 读档 | `load_game(1)` | 返回 `SaveData` 对象，字段完整 |
| SAV-03 | 覆盖已有存档 | 槽位 1 已有存档，`save_game(1)` | 返回 `true`，旧存档被覆盖 |
| SAV-04 | 读取空槽位 | `load_game(3)` （从未存档） | 返回 `null` 或 `false` |
| SAV-05 | 存档数据完整性 | 存档后读档，对比 SpellBook/Inventory/Puzzle | 所有数据字段一致 |
| SAV-06 | 自动存档触发 | 进入新楼层 | 自动存档到 auto 槽位 |
| SAV-07 | 删除存档 | `delete_save(1)` | 返回 `true`，槽位 1 为空 |
| SAV-08 | 存档版本兼容 | 旧版本存档文件 → `load_game()` | 检测版本不匹配，给出迁移或警告 |

### 2.7 test_player.gd

```
测试目标: Player 节点
```

| ID | 测试用例 | 输入 | 预期输出 |
|---|---|---|---|
| PLY-01 | 四方向移动 | WASD 输入 | 角色向正确方向移动，播放对应动画 |
| PLY-02 | 斜向移动 | W+A 同时按下 | 角色沿对角线移动，速度归一化 |
| PLY-03 | 碰撞检测 | 走向墙壁 | 角色不穿过碰撞体 |
| PLY-04 | 交互范围检测 | 站在可交互对象旁按 E | 检测到最近的可交互对象 |
| PLY-05 | 交互范围外 | 远离任何对象按 E | 无反应 |
| PLY-06 | 移动中交互 | 行走时按 E | 交互优先，停止移动 |

### 2.8 test_recipe.gd

```
测试目标: 合成/配方逻辑
```

| ID | 测试用例 | 输入 | 预期输出 |
|---|---|---|---|
| REC-01 | 正确配方合成 | 放入正确材料 + 选择配方 | 返回产物 ID，材料消耗 |
| REC-02 | 材料不足 | 缺少一种材料 | 返回 `false`，不消耗材料 |
| REC-03 | 错误组合 | 放入不匹配配方的材料 | 返回 `false`，提示 "Nothing happens" |
| REC-04 | 配方解锁 | 收集到配方卡后 `is_recipe_known()` | 返回 `true` |

---

## 3. Integration Tests

### 3.1 跨系统交互测试

| ID | 测试场景 | 步骤 | 验证点 |
|---|---|---|---|
| INT-01 | 收集咒语→施放→谜题解开 | 1. 走到咒语碎片处收集 "BURN" 2. 走向藤蔓门 3. 打开咒语书选择 BURN 4. 施放 | 藤蔓燃烧动画播放 → 门打开 → PuzzleManager 标记已解 → SaveManager 可存档此状态 |
| INT-02 | 收集物品→合成→使用产物 | 1. 收集 blue_herb 和 spring_water 2. 阅读配方卡 3. 在合成界面选择材料 4. 获得 healing_potion 5. 在对应谜题中使用 | Inventory 材料减少 → 新物品出现 → 谜题可用 potion 推进 |
| INT-03 | NPC 对话→获得线索→解谜 | 1. 与 Owly 对话 "The door needs something SHINY to open" 2. 玩家理解 SHINY 3. 找到 mirror 物品 4. 对门使用 mirror | 对话关键词 SHINY 高亮 → 物品 mirror 可交互 → 门打开 |
| INT-04 | 存档→退出→读档→继续 | 1. 在 3F 解了 2 个谜题 2. 手动存档到槽位 1 3. 退出游戏 4. 重启→读档槽位 1 | 楼层=3F，2 个谜题仍为已解，咒语书/物品栏完整，角色位置正确 |
| INT-05 | 楼层切换→状态保持 | 1. 在 1F 收集所有咒语 2. 解开主谜题→上楼 3. 到 2F → 回到 1F | 1F 咒语仍存在（不重新生成），已解谜题保持已解 |

### 3.2 无卡死（Softlock）验证

| ID | 场景 | 操作 | 预期 |
|---|---|---|---|
| SL-01 | 错过后再回来 | 在 1F 跳过可选咒语碎片→上 2F→回 1F | 碎片仍在原地 |
| SL-02 | 错误操作后 | 对谜题使用错误咒语 10 次 | 谜题不锁死，仍可重试 |
| SL-03 | 物品丢弃 | （如果支持丢弃）丢弃关键物品后 | 关键物品不可丢弃，或谜题有替代解法 |
| SL-04 | 异常退出 | 解谜中途 Alt+F4 → 重启 | 自动存档恢复到最后一次自动保存点 |

---

## 4. Puzzle Validation（谜题验证）

### 4.1 逐层谜题验证清单

每个谜题必须通过以下检查：

```
┌─ 可解性检查 ─────────────────────────────┐
│ □ 谜题存在至少一条可达成的解决路径         │
│ □ 所需线索/物品/咒语均可获取               │
│ □ 不存在"先做B会卡死A"的顺序依赖 Bug       │
│ □ 如果玩家离开再回来，谜题状态正确保持     │
│ □ 错误尝试后的状态可恢复（不累积副作用）   │
└──────────────────────────────────────────┘
┌─ 线索清晰度检查 ──────────────────────────┐
│ □ 英文线索中的关键词有视觉强调             │
│ □ 线索位置在谜题附近（≤2屏距离）          │
│ □ 同一线索不会被误解为指向两个不同谜题     │
│ □ Owly 在玩家卡关 5 分钟后给出渐进提示    │
└──────────────────────────────────────────┘
┌─ 难度检查 ────────────────────────────────┐
│ □ 目标楼层词汇在玩家已收集范围内           │
│ □ 句子长度与楼层难度匹配（1F≈3词,7F≈15词）│
│ □ 理解英文是必要条件（不能靠穷举乱试通过） │
│ □ 但不要求拼写（咒语书自动填充）           │
└──────────────────────────────────────────┘
```

### 4.2 1F 门厅谜题验证（最早验证）

| 谜题 | 验证步骤 | 通过标准 |
|---|---|---|
| 小谜题1: PUSH stone | 1. 阅读字条 "PUSH the stone" 2. 走向场景中唯一的大石头 3. 按交互键 | 石头移动 → 露出钥匙 → 钥匙可拾取 |
| 小谜题2: LIGHT torch | 1. 收集咒语碎片 LIGHT 2. 走向熄灭的火炬 3. 从咒语书选择 LIGHT 4. 施放 | 火炬点燃 → 隐藏暗门出现 |
| 主谜题: 符文门 | 1. 阅读墙上诗歌 2. 理解三个符文顺序 3. 收集三个咒语碎片 4. 按正确顺序放入符文槽 | 门打开 → Owly 出现 → 对话触发 → 楼梯解锁 |

### 4.3 谜题穷举测试

对每个谜题的合法输入空间做穷举：

| 谜题类型 | 穷举策略 |
|---|---|
| 排序谜题（N 个元素排列） | N≤5 时穷举所有排列，验证只有正确排列通过 |
| 匹配谜题（M 个物品→N 个槽） | 穷举所有匹配组合，验证正确匹配唯一 |
| 咒语选择谜题（K 个咒语→1 个目标） | 测试所有已收集咒语，验证仅正确咒语生效 |
| 序列谜题（操作序列） | 测试随机序列，验证仅正确序列通过 |

---

## 5. English Difficulty Validation（英语难度验证）

### 5.1 文本审查流程

```
所有游戏内英文文本
        │
        ▼
   ┌──────────────┐
   │ 词汇分级标注  │  → 标注每个单词的 CEFR 级别
   └──────┬───────┘
          ▼
   ┌──────────────┐
   │ 可读性评分    │  → Flesch-Kincaid / 自动可读性工具
   └──────┬───────┘
          ▼
   ┌──────────────┐
   │ 目标玩家试读  │  → A1–B1 水平 3 人独立阅读 + 反馈
   └──────┬───────┘
          ▼
   ┌──────────────┐
   │ 调整 & 再验证 │
   └──────────────┘
```

### 5.2 每层词汇检查表

| 楼层 | 目标 CEFR | 生词上限 | 句子最长词数 | 检查工具 |
|---|---|---|---|---|
| 1F | A1 | 15 个 unique words | 5 词 | Oxford 3000 对照 |
| 2F | A1 | 20 个 | 6 词 | Oxford 3000 |
| 3F | A1+ | 25 个 | 8 词 | Oxford 3000 |
| 4F | A2 | 30 个 | 12 词 | Oxford 3000 + 5000 |
| 5F | A2 | 30 个 | 12 词 | Oxford 5000 |
| 6F | A2+ | 35 个 | 15 词 | Oxford 5000 |
| 7F | B1 | 40 个 | 20 词 | Oxford 5000 |

### 5.3 可读性指标

| 指标 | 目标值 | 工具 |
|---|---|---|
| Flesch Reading Ease | ≥80（1-4F）/ ≥70（5-7F） | textstat / online tool |
| 超纲词占比 | ≤10%（每层） | 对照 Oxford 3000/5000 |
| 句子平均长度 | ≤8 词（1-3F）/ ≤12 词（4-7F） | 手工统计 |

### 5.4 玩家理解度测试

每层完成后，邀请 3 名目标水平玩家做：

1. **关键词回顾**: 展示该层 5 个关键词，问"这个词在游戏里让你做了什么？"
2. **线索复述**: "那个谜题为什么要用 BURN 而不是 WATER？"
3. **难度自评**: 1–5 分，"这层的英文有多难？"

通过标准：≥2/3 玩家能正确解释关键词在游戏中的作用。

---

## 6. Playtest Protocol（真人试玩方案）

### 6.1 试玩阶段

| 阶段 | 时机 | 人数 | 时长 | 目标 |
|---|---|---|---|---|
| **Alpha** | Week 4（MVP 完成） | 3–5 人 | 30 min | 验证核心循环；发现致命 Bug |
| **Beta-1** | Week 8（4 层完成） | 5–8 人 | 90 min | 验证难度曲线；收集谜题反馈 |
| **Beta-2** | Week 10（7 层完成） | 5–8 人 | 3 hours | 完整通关测试；性能/存档 |
| **RC** | Week 12（发布前） | 3–5 人 | 2 hours | 最终 Bug 修复验证；中英切换 |

### 6.2 试玩观察表

```
┌─ 试玩观察表 ──────────────────────────────────┐
│ 试玩人: _____ 英语水平: _____ 日期: _____      │
│                                                │
│ 【不解提示的自发行为】                          │
│ - 玩家首先尝试做什么？                          │
│ - 在哪里停留/徘徊超过 10 秒？                   │
│ - 有没有反复尝试同一错误操作？                  │
│                                                │
│ 【英语理解】                                    │
│ - 有没有跳过阅读直接乱试？                      │
│ - 有没有口头念出英文？                          │
│ - 有没有问"这个词什么意思"？                    │
│                                                │
│ 【谜题通过情况】                                │
│ - 每个谜题尝试次数：                            │
│ - 卡关位置 & 时长：                             │
│ - 是否使用了 Owly 提示？                        │
│                                                │
│ 【主观评价】                                    │
│ - 好玩程度 1-5: __                              │
│ - "像做题"程度 1-5: __ (1=完全不像)             │
│ - 英语难度 1-5: __ (1=太简单 5=太难)            │
│ - 最喜欢的谜题: _____                           │
│ - 最困惑的地方: _____                           │
└────────────────────────────────────────────────┘
```

### 6.3 试玩后访谈（5 分钟）

1. "你有没有觉得在'做题'？哪个瞬间有？"
2. "有没有哪个英文你看不懂但是猜出来了？怎么猜的？"
3. "如果推荐给朋友，你会怎么描述这个游戏？"
4. "哪个谜题你想跳过？为什么？"

---

## 7. Technical QA

### 7.1 性能测试

| 测试项 | 方法 | 通过标准 |
|---|---|---|
| FPS 稳定性 | 每层场景运行 5 分钟，Godot Debugger 监控 | 全程 ≥55 FPS |
| 内存泄漏 | 楼层间反复切换 20 次，观察内存 | 内存增长 ≤10MB |
| 场景加载时间 | 测量 `change_scene_to_file()` 耗时 | ≤1 秒 |
| Web 导出加载 | Web 版首次加载时间（Chrome 模拟 3G） | ≤15 秒 |
| 粒子特效性能 | 同时播放 50 个像素粒子 | FPS 下降 ≤5 |

### 7.2 平台兼容性测试

| 平台 | 测试内容 | 通过标准 |
|---|---|---|
| Windows 10/11 | 完整通关 | 无崩溃，存档正常 |
| macOS (Intel + Apple Silicon) | 完整通关 | 无崩溃，存档正常 |
| Linux (Ubuntu 22.04+) | 启动 + 1F 通关 | 无崩溃，输入正常 |
| Web (Chrome/Firefox/Safari) | 完整通关 | 存档（localStorage），音效正常 |

### 7.3 中英切换测试

| 测试项 | 操作 | 通过标准 |
|---|---|---|
| 主菜单语言切换 | 设置 → 切换语言 | 所有 UI 立即更新 |
| 游戏中热切换 | 游戏中途 Esc → 切换语言 | UI 更新，游戏内英文内容不变 |
| 咒语书翻译 | 中文模式下打开咒语书 | 显示中文释义 |
| 物品栏翻译 | 中文模式下打开物品栏 | 物品名显示中文 |
| 设置持久化 | 切换中文 → 重启游戏 | 语言设置保持中文 |

### 7.4 边界条件测试

| 测试项 | 操作 | 预期 |
|---|---|---|
| 空存档启动 | 首次运行，无任何存档文件 | 正常进入主菜单，"继续"按钮灰色 |
| 存档文件损坏 | 手动破坏存档 JSON → 读档 | 提示"存档损坏"，不崩溃 |
| 磁盘空间不足 | 存档时磁盘满 | 提示"存档失败"，不崩溃 |
| 分辨率切换 | 游戏中切换全屏/窗口 | 像素完美缩放保持 |
| Alt+Tab | 游戏中途切到桌面再回来 | 状态不变，音效恢复 |
| 长时间运行 | 游戏运行 4 小时不退出 | 无内存泄漏，FPS 稳定 |

---

## 8. Test Schedule（测试排期）

```
Week 1–2  │ 搭建 GUT 框架 + 编写核心 autoload 单测
          │ test_spell_book, test_inventory, test_save_manager
          │
Week 3–4  │ 编写玩家/交互单测 + 1F 集成测试
          │ test_player, test_interactable + 1F 谜题验证
          │ → Alpha Playtest (Week 4 末)
          │
Week 5–6  │ 2F/3F 谜题验证 + 合成系统测试
          │ test_recipe + 2F/3F 穷举验证
          │
Week 7–8  │ 4F 谜题验证 + 存档集成测试 + 英语难度审查(1-4F)
          │ → Beta-1 Playtest (Week 8 末)
          │
Week 9–10 │ 5F/6F/7F 谜题验证 + 全流程集成测试
          │ test_floor_transition + 英语难度审查(5-7F)
          │ → Beta-2 Playtest (Week 10 末)
          │
Week 11   │ 性能测试 + 平台兼容性测试 + 中英切换测试
          │ 边界条件全覆盖
          │
Week 12   │ Bug 修复验证 + RC Playtest + 最终导出测试
          │ → v1.0 发布
```

---

## 9. Bug Severity Classification

| 等级 | 定义 | 示例 | 响应 |
|---|---|---|---|
| **P0 - Blocker** | 游戏无法继续 | 主谜题无法解开；存档损坏导致进度丢失 | 立即修复，阻塞发布 |
| **P1 - Critical** | 核心功能异常 | 咒语书打不开；对话跳过导致线索丢失 | 24h 内修复 |
| **P2 - Major** | 影响体验但不阻塞 | 动画卡顿；音效缺失；UI 错位 | 当前阶段修复 |
| **P3 - Minor** | 小瑕疵 | 像素错位；英文拼写错误；颜色偏差 | 可延后修复 |
| **P4 - Suggestion** | 改进建议 | "这个提示可以更明显" | 记录，择机处理 |

---

## 10. Test Deliverables（测试交付物）

| 交付物 | 格式 | 时机 |
|---|---|---|
| GUT 测试套件（≥50 条单测） | `tests/unit/` 目录 | Week 4 |
| 集成测试套件（≥10 条） | `tests/integration/` 目录 | Week 8 |
| 1F 谜题验证报告 | Markdown | Week 4 |
| Alpha 试玩报告 | Markdown + 观察表扫描 | Week 4 |
| 英语难度审查报告（1-4F） | Markdown + 词汇表 | Week 8 |
| Beta-1 试玩报告 | Markdown | Week 8 |
| 全层谜题验证报告 | Markdown | Week 10 |
| Beta-2 试玩报告 | Markdown | Week 10 |
| 性能测试报告 | Markdown | Week 11 |
| 平台兼容性测试报告 | Markdown | Week 11 |
| RC 试玩报告 | Markdown | Week 12 |
| Release Checklist | Checklist | Week 12 |

---

*Document version: 1.0 | Last updated: 2025-07-17*
