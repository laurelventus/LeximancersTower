# PRD: Leximancer's Tower（语法师之塔）

> **版本**: v1.0 | **状态**: Draft | **作者**: — | **日期**: 2025-07-17
> 
> 2D 像素风格 · 交互解密 · 英语学习融合 · Godot 4.6 单机游戏

---

## 1. Executive Summary

### Problem Statement

市面上的"教育游戏"大多把学习内容生硬地嵌入选择题/填空题，打断游戏心流，导致玩家要么跳过学习内容，要么放弃游戏。英语初学者（A1–B1）缺乏一款**真正好玩、英语作为工具而非考题**的沉浸式游戏。

### Proposed Solution

**Leximancer's Tower** 是一款 2D 俯视像素解谜游戏。玩家扮演冒险家 Luna，在魔法塔中逐层攀登，通过**阅读英文线索、理解 NPC 对话、组合咒语**来破解机关谜题。英语不是"题目"，而是推进游戏的唯一钥匙——就像在真实世界中读懂路标才能前进。

### Success Criteria

| # | KPI | Target | Measurement |
|---|---|---|---|
| 1 | **完成率** | ≥60% 玩家通关（到达 7F 并解开最终谜题） | 内置遥测 / 玩家反馈 |
| 2 | **谜题通过率** | 每层主谜题 ≥85% 玩家在 3 次尝试内通过 | 关卡内置计数 |
| 3 | **无需外部翻译** | ≥50% 玩家报告"没有查字典/翻译工具" | 通关后问卷 |
| 4 | **核心循环时长** | 首次通关 2–4 小时 | 游戏内计时器 |
| 5 | **沉浸感评分** | ≥4/5 "不像在做题" 评价 | 通关后问卷 |

---

## 2. User Experience & Functionality

### 2.1 User Personas

| Persona | 描述 | 核心需求 |
|---|---|---|
| **英语初学者** (CEFR A1–A2) | 中国初中/高中生，词汇量 500–1500，对英语有畏难情绪 | 无压力的英语接触环境；通过上下文和视觉猜词；成就感驱动 |
| **休闲解谜玩家** | 喜欢《The Room》《纪念碑谷》类解谜游戏，不一定是英语学习者 | 有趣的谜题设计；不因"教育标签"而劝退；像素美术有吸引力 |
| **语言学习爱好者** | 主动寻找英语学习工具，尝试过 Duolingo/多邻国但觉得枯燥 | 真实语境使用英语；不像刷题；有故事驱动 |

### 2.2 User Stories

| ID | Story | Priority |
|---|---|---|
| US-01 | 作为玩家，我希望通过**探索环境**发现英文线索，而不是被弹出窗口打断 | P0 |
| US-02 | 作为玩家，我希望有一个**随时可翻阅的咒语书**，收集的单词自动存入，不需要我记忆 | P0 |
| US-03 | 作为玩家，我选错咒语时希望**没有惩罚**，可以无限重试 | P0 |
| US-04 | 作为玩家，我希望**视觉元素辅助理解英文**（关键词用颜色/图标标注），降低挫败感 | P0 |
| US-05 | 作为英语初学者，我希望在**不理解英文时也能通过视觉线索**推断出大致意思 | P1 |
| US-06 | 作为玩家，我希望谜题有多种类型（操作机关、物品匹配、排序组合、方位探索），不单调 | P1 |
| US-07 | 作为玩家，我希望有**中英双语 UI 切换**选项 | P2 |
| US-08 | 作为玩家，我希望游戏**自动保存进度**，随时可以退出继续 | P0 |
| US-09 | 作为玩家，我希望通关后能看到**收集的词库统计**（学到了多少单词） | P2 |

### 2.3 Acceptance Criteria (核心 AC)

**咒语书系统**
- [ ] 探索中触碰咒语碎片 → 自动存入咒语书，播放收集动画
- [ ] 打开咒语书：显示已收集单词列表，每个单词附带一个简单图标/emoji
- [ ] 面对可交互对象时，从咒语书选择咒语施放
- [ ] 正确咒语：播放成功动画 + 推进游戏
- [ ] 错误咒语：播放无效果动画（摇晃/暗淡），不扣分不锁死
- [ ] 咒语书支持分类浏览（动作类 / 物品类 / 自然类）

**NPC 对话系统**
- [ ] 接触 NPC → 显示像素对话框，英文短句逐字打印效果
- [ ] 关键词高亮（如颜色词用对应颜色、动词用闪烁效果）
- [ ] 玩家可反复对话（内容不变或轻微变化）
- [ ] 对话历史可回顾（可选功能）

**谜题系统**
- [ ] 至少 5 种谜题类型：环境操作、物品匹配、排序组合、方位探索、对话推理
- [ ] 每层 2–4 个小谜题 + 1 个主谜题（Boss Puzzle）
- [ ] 主谜题通过后解锁通往上一层的楼梯
- [ ] 所有谜题可无限重试，无死亡/卡死状态

**关卡进度**
- [ ] 7 层魔法塔，每层独立场景
- [ ] 楼梯间过渡动画
- [ ] 自动保存：进入新楼层时自动存档
- [ ] 手动保存：菜单中随时存档，共 3 个存档位

### 2.4 Non-Goals（明确不做）

- ❌ 不弹出选择题/填空题/拼写测试
- ❌ 不做语法纠错和"正确答案"评判
- ❌ 不做战斗系统（HP/攻击/敌人）
- ❌ 不做多人在线/联机
- ❌ 不做语音识别和发音评分
- ❌ 不做关卡编辑器/UGC
- ❌ 不做移动端适配（第一阶段仅 PC+Web）
- ❌ 不做成就/排行榜（第一阶段）
- ❌ 不做复杂的 RPG 数值系统（等级/经验/技能树）

---

## 3. Game Design Specification

### 3.1 世界观设定

> 暴风雨夜，年轻的冒险家 **Luna** 闯入一座废弃的魔法塔。塔的主人——传说中的"语法师"（Leximancer）——已失踪多年。塔中的机关仍在运转，但它们只响应一种力量：**语言**。
> 
> 一只会说简单英语的魔法猫头鹰 **Owly** 成了你的向导。你必须一层层向上攀登，阅读散落的日记、破解环境谜题、收集"咒语碎片"（英语单词/短语）、解开语法师失踪的真相。

### 3.2 核心循环（Core Loop）

```
探索场景 → 发现线索(英文) → 理解线索 → 操作/施咒 → 解开谜题 → 获得新区域/新能力
    ↑                                                                              ↓
    └────────────────────────── 新线索 & 新咒语碎片 ←────────────────────────────────┘
```

### 3.3 关卡详细设计

#### 1F — The Entrance Hall（门厅）

| 要素 | 内容 |
|---|---|
| **场景** | 昏暗的石质大厅，中央有熄灭的魔法火炬，一扇锁着的门通向楼上 |
| **色调** | 暖灰 + 暗金 |
| **目标词汇** | OPEN, CLOSE, PUSH, PULL, LIGHT, KEY, DOOR, TORCH |
| **小谜题 1** | 地上有字条 `"PUSH the stone"` → 推开石头发现钥匙 |
| **小谜题 2** | 墙上文字 `"LIGHT the TORCH to reveal the path"` → 用火咒语点燃火炬 → 照亮隐藏的暗门 |
| **主谜题** | 一扇门上有 3 个符文槽，需要按照墙上诗歌的英文提示放入正确顺序的咒语碎片 → 门打开，Owly 出现 |
| **收集品** | 咒语碎片: OPEN, LIGHT, KEY；日记碎片 #1 |

#### 2F — The Kitchen（厨房）

| 要素 | 内容 |
|---|---|
| **场景** | 魔法厨房，大锅、橱柜、食材架、幽灵厨师 NPC |
| **色调** | 暖黄 + 木棕 |
| **目标词汇** | MIX, BAKE, POUR, CHOP, MILK, EGG, FLOUR, SUGAR, SALT, CAKE, FIRST, THEN, FINALLY |
| **小谜题 1** | 橱柜标签全是英文 → 找出正确的食材 |
| **小谜题 2** | 配方卡 `"Mix RED liquid + BLUE powder → PURPLE potion"` → 合成紫色药水打开上锁的储藏室 |
| **主谜题** | 幽灵厨师要蛋糕，口述顺序 `"first MILK, then EGG, then FLOUR"` → 按正确顺序放入锅中 → 获得楼梯钥匙 |
| **收集品** | 咒语碎片: MIX, POUR, BAKE；配方卡 ×2；日记碎片 #2 |

#### 3F — The Greenhouse（温室）

| 要素 | 内容 |
|---|---|
| **场景** | 玻璃穹顶温室，奇异植物、干涸的喷泉、藤蔓缠绕的楼梯 |
| **色调** | 翠绿 + 天蓝 |
| **目标词汇** | GROW, BLOOM, WATER, SUN, RAIN, SEED, ROOT, LEAF, TALL, SHORT, ABOVE, BELOW |
| **小谜题 1** | 枯萎植物旁标牌 `"I need WATER and SUNLIGHT"` → 依次用水咒语和光咒语 → 植物开花露出钥匙 |
| **小谜题 2** | 四盆植物分别标注 `"Tallest"` `"Shortest"` `"Above"` `"Below"` → 按英文描述的物理位置排序 |
| **主谜题** | 喷泉干涸，石碑刻着 `"RAIN falls when the THREE SEEDS are planted in the correct soil"` → 找到3颗种子种到对应土壤（土壤用英文描述）→ 下雨 → 喷泉涌出 → 楼梯解锁 |
| **收集品** | 咒语碎片: GROW, WATER, RAIN, BLOOM；种子 ×3；日记碎片 #3 |

#### 4F — The Library（图书馆）

| 要素 | 内容 |
|---|---|
| **场景** | 巨大环形图书馆，书架高耸，中央有星空投影仪，幽灵图书管理员 NPC |
| **色调** | 深棕 + 暗蓝 |
| **目标词汇** | READ, FIND, SEARCH, INDEX, BOOK, PAGE, STORY, TRUE, FALSE, HIDDEN, SECRET, BETWEEN |
| **小谜题 1** | 图书管理员说 `"Find the book with a RED cover, BETWEEN the TALL shelf and the WINDOW"` → 按方位描述找到书 |
| **小谜题 2** | 书中内容描述了一个密码 `"The FIRST letter of each COLOR word"` → 理解后提取密码 |
| **主谜题** | 星空投影仪显示星座，每颗星标注英文单词 → 需要选出一句话 `"THE KEY IS HIDDEN UNDER THE OLD CLOCK"` → 回到之前场景找到钥匙 |
| **收集品** | 咒语碎片: READ, FIND, HIDDEN, TRUE；书籍 ×3；日记碎片 #4 |

#### 5F — The Workshop（工坊）

| 要素 | 内容 |
|---|---|
| **场景** | 齿轮机械工坊，传送带、杠杆、按钮、管道 |
| **色调** | 铜棕 + 铁灰 |
| **目标词汇** | TURN, PULL, PUSH, ROTATE, LEFT, RIGHT, UP, DOWN, FORWARD, BACKWARD, STOP, START |
| **小谜题 1** | 三根杠杆标注 `"PULL the LEFT one"` `"TURN the RIGHT one"` `"PUSH the CENTER one"` → 按英文操作 |
| **小谜题 2** | 传送带方向控制面板写着 `"FORWARD → BACKWARD → STOP → FORWARD"` → 按序列操作使物品到达正确位置 |
| **主谜题** | 大型齿轮机构停止运转，墙上操作手册（英文段落）描述重启步骤 → 按步骤操作 → 齿轮重新转动 → 升降平台启动 |
| **收集品** | 咒语碎片: TURN, ROTATE, FORWARD, START；齿轮零件 ×4；日记碎片 #5 |

#### 6F — The Observatory（天文台）

| 要素 | 内容 |
|---|---|
| **场景** | 圆形穹顶天文台，望远镜、星图、棱镜、光束 |
| **色调** | 深蓝 + 银白 |
| **目标词汇** | STAR, MOON, SUN, NORTH, SOUTH, EAST, WEST, CIRCLE, TRIANGLE, SQUARE, REFLECT, SHINE |
| **小谜题 1** | 望远镜需要对准特定方向 → 星图谱上写着 `"Point to the BRIGHTEST star in the EAST"` |
| **小谜题 2** | 棱镜折射谜题：`"Reflect the RED beam to the TRIANGLE, the BLUE beam to the SQUARE"` |
| **主谜题** | 星座拼图：收集星图碎片，每片有英文描述 → 拼出完整星座 → 光束指向隐藏楼梯 |
| **收集品** | 咒语碎片: REFLECT, SHINE, CIRCLE, STAR；星图碎片 ×5；日记碎片 #6 |

#### 7F — The Leximancer's Chamber（语法师的房间）

| 要素 | 内容 |
|---|---|
| **场景** | 塔顶密室，语法师的工作台、巨大水晶、失踪真相的线索 |
| **色调** | 金 + 白 |
| **目标词汇** | 综合运用前 6 层所有词汇 |
| **主谜题** | 最终大门上的封印需要将 7 个咒语碎片按语法师日记中隐藏的顺序排列成一整句英文 → 封印解开 → 揭示真相 |
| **剧情** | 语法师留下了最后一段英文信息解释一切（难度相当于 B1 阅读） → 玩家理解后完成游戏 |

### 3.4 谜题类型总结

| 类型 | 英文使用 | 示例 | 出现楼层 |
|---|---|---|---|
| **环境操作** | 阅读英文提示 → 操作机关 | `"PULL the RED lever"` | 1F, 5F |
| **物品匹配** | 物品与英文描述配对 | 三座台座标注"Gift of Earth/Sky/Sea" | 3F |
| **排序组合** | 单词碎片排成有意义的句子 | 拼出 `"THE DOOR WILL OPEN"` | 7F |
| **方位探索** | 根据英文方位词找隐藏物品 | `"UNDER the clock, BEHIND the painting"` | 4F |
| **对话推理** | 理解 NPC 话语推断行动 | NPC: `"I'm so COLD... the FIRE went out..."` | 2F |
| **合成/配方** | 阅读英文配方卡组合材料 | `"Mix BLUE HERB + SPRING WATER"` | 2F, 3F |
| **操作序列** | 按英文描述的步骤执行 | `"FORWARD → BACKWARD → STOP"` | 5F |
| **光线/方向** | 理解方位词汇调整光束 | `"Reflect RED beam to the TRIANGLE"` | 6F |

### 3.5 避"做题感"设计清单

| 原则 | 实现 |
|---|---|
| 英语 = 获取信息的手段 | 不读提示 → 不知道怎么做；读了 → 知道方向 |
| 谜题本身有趣 | 即使去掉英语，谜题也是好玩的机关/探索挑战 |
| 零惩罚 | 选错咒语 → 无效果动画 → 再试，不扣血不扣分 |
| 视觉辅助 | 颜色词用对应颜色渲染；方位词旁有箭头图标；动词用动画暗示 |
| 咒语书不考记忆 | 收集过的单词始终可查，不需要背诵 |
| 渐进难度 | 1F 单词 → 3F 短句 → 5F 段落 → 7F 综合 |
| 自然融入 | 所有文字都在世界物体上（标牌、日记、涂鸦），没有弹窗 |

---

## 4. Technical Specifications

### 4.1 技术栈

| 层 | 选型 | 版本 | 理由 |
|---|---|---|---|
| **引擎** | Godot | 4.6 | 2D 原生支持优秀，像素完美渲染，GDScript 学习成本低 |
| **脚本** | GDScript | — | 与引擎深度集成，性能满足需求 |
| **像素美术** | Aseprite / LibreSprite | — | 标准像素画工具，导出 spritesheet |
| **素材来源** | itch.io 像素素材包 | — | 缩短制作周期，适度修改统一风格 |
| **音效** | freesound / OpenGameArt | — | 免费可商用音效 |
| **字体** | 像素 TTF（如 m3x6 / Press Start 2P） | — | 免费商用像素字体 |
| **版本控制** | Git | — | 代码 + 场景文件版本管理 |
| **导出目标** | Windows / macOS / Linux / Web | — | Godot 一键导出 |

### 4.2 项目目录结构

```
leximancers-tower/
├── project.godot                  # Godot 项目配置
├── assets/
│   ├── sprites/                   # 像素精灵图
│   │   ├── player/                # Luna 角色 spritesheet
│   │   ├── npc/                   # Owly + 其他 NPC
│   │   ├── environment/           # 场景物件（家具/植物/机械等）
│   │   ├── items/                 # 可收集物品图标
│   │   └── ui/                    # UI 元素（按钮/边框/图标）
│   ├── tilesets/                  # 瓦片地图
│   │   ├── floor1_entrance.tres
│   │   ├── floor2_kitchen.tres
│   │   └── ...
│   ├── fonts/                     # 像素字体
│   ├── audio/                     # 音效 & 音乐
│   │   ├── sfx/                   # 音效（开门、施咒、收集等）
│   │   └── music/                 # 背景音乐（每层一曲）
│   └── data/                      # 数据文件
│       ├── spells.json            # 咒语数据
│       ├── items.json             # 物品数据
│       ├── recipes.json           # 合成配方
│       ├── puzzles/               # 每层谜题配置
│       │   ├── floor1.json
│       │   └── ...
│       └── dialogue/              # NPC 对话
│           ├── owly.json
│           └── ...
├── scenes/
│   ├── core/                      # 全局系统场景
│   │   ├── game.tscn              # 游戏主场景（Game Manager）
│   │   ├── ui.tscn                # UI 层（咒语书/物品栏/对话框）
│   │   └── main_menu.tscn         # 主菜单
│   ├── levels/                    # 关卡场景
│   │   ├── floor1_entrance.tscn
│   │   ├── floor2_kitchen.tscn
│   │   ├── floor3_greenhouse.tscn
│   │   ├── floor4_library.tscn
│   │   ├── floor5_workshop.tscn
│   │   ├── floor6_observatory.tscn
│   │   └── floor7_chamber.tscn
│   └── props/                     # 可复用物件
│       ├── interactive_object.tscn
│       ├── spell_fragment.tscn
│       └── door.tscn
├── scripts/
│   ├── autoload/                  # 全局单例（Autoload）
│   │   ├── game_manager.gd        # 游戏状态管理
│   │   ├── spell_book.gd          # 咒语书数据管理
│   │   ├── inventory.gd           # 物品栏管理
│   │   ├── dialogue_manager.gd    # 对话系统
│   │   ├── puzzle_manager.gd      # 谜题状态管理
│   │   ├── save_manager.gd        # 存档/读档
│   │   ├── audio_manager.gd       # 音频管理
│   │   └── localization.gd        # 中英 UI 切换
│   ├── player/
│   │   └── player.gd              # 玩家移动 & 交互
│   ├── npc/
│   │   ├── npc_base.gd            # NPC 基类
│   │   └── owly.gd                # Owly 特殊行为
│   ├── interactables/
│   │   ├── interactable_base.gd   # 可交互对象基类
│   │   ├── spell_target.gd        # 咒语响应对象
│   │   ├── puzzle_object.gd       # 谜题机关
│   │   └── collectible.gd         # 可收集物品
│   ├── puzzles/
│   │   ├── puzzle_base.gd         # 谜题基类
│   │   ├── puzzle_sequence.gd     # 排序谜题
│   │   ├── puzzle_matching.gd     # 匹配谜题
│   │   └── puzzle_recipe.gd       # 合成/配方谜题
│   └── ui/
│       ├── spell_book_ui.gd       # 咒语书 UI
│       ├── inventory_ui.gd        # 物品栏 UI
│       ├── dialogue_box.gd        # 对话框 UI
│       ├── pause_menu.gd          # 暂停菜单
│       └── settings_menu.gd       # 设置菜单
└── localization/
    ├── ui_zh.csv                  # 中文 UI 文本
    └── ui_en.csv                  # 英文 UI 文本
```

### 4.3 核心系统架构

```
┌──────────────────────────────────────────────────────────┐
│                    Game Manager (Autoload)                │
│  全局状态: 当前楼层 · 已收集咒语 · 已解开谜题 · 游戏时间    │
└──────┬───────┬─────────┬──────────┬──────────┬───────────┘
       │       │         │          │          │
       ▼       ▼         ▼          ▼          ▼
┌──────────┐ ┌──────┐ ┌──────┐ ┌──────────┐ ┌──────────┐
│SpellBook │ │Inv.  │ │Dial. │ │Puzzle    │ │Save      │
│Manager   │ │Mgr   │ │Mgr   │ │Manager   │ │Manager   │
│          │ │      │ │      │ │          │ │          │
│· spells  │ │·items│ │·curr │ │·state per│ │·3 slots  │
│· cast()  │ │·use()│ │·hist │ │ floor    │ │·auto+man │
└──────────┘ └──────┘ └──────┘ └──────────┘ └──────────┘
       │          │         │          │
       └──────────┴─────────┴──────────┘
                      │
                      ▼
              ┌──────────────┐
              │  Scene Tree  │
              │  (当前楼层)   │
              │              │
              │ · TileMap    │
              │ · Player     │
              │ · NPCs       │
              │ · Interact.. │
              │ · Puzzle obj │
              └──────────────┘
```

### 4.4 关键数据结构

```gdscript
# 咒语碎片
class SpellFragment:
    var id: String           # "spell_burn"
    var word: String         # "BURN"
    var category: String     # "action" / "element" / "nature"
    var icon: Texture2D      # 小图标
    var description: String  # 简短中文提示

# 物品
class InventoryItem:
    var id: String
    var name_en: String      # 英文名
    var name_zh: String      # 中文名（仅 UI 显示用）
    var icon: Texture2D
    var is_consumable: bool
    var can_combine: bool

# 配方
class Recipe:
    var id: String
    var ingredients: Array[String]  # 所需物品 ID 列表
    var result_item: String         # 产物 ID
    var description_en: String      # 英文配方描述（游戏内显示）
    var description_zh: String      # 中文（仅 UI 辅助）

# 谜题
class PuzzleState:
    var id: String
    var floor: int
    var is_solved: bool
    var attempts: int
    var required_spells: Array[String]  # 需要的咒语 ID
    var required_items: Array[String]   # 需要的物品 ID

# 存档
class SaveData:
    var slot: int
    var current_floor: int
    var player_pos: Vector2
    var collected_spells: Array[String]
    var inventory_items: Array[String]
    var solved_puzzles: Array[String]
    var game_time_seconds: float
    var timestamp: String
```

### 4.5 输入控制

| 操作 | 键盘 | 说明 |
|---|---|---|
| 移动 | WASD / 方向键 | 8 方向像素移动 |
| 交互 | E / Space | 与面前对象/NPC 互动 |
| 打开咒语书 | Tab | 切换咒语书 UI |
| 打开物品栏 | I | 切换物品栏 UI |
| 暂停菜单 | Esc | 暂停 + 设置 + 存档 |
| 对话推进 | E / Space / Enter | 逐句推进对话 |

### 4.6 渲染设置

- **分辨率**: 480×270（16:9 基础分辨率），像素完美放大到 1920×1080（×4 整数倍）
- **缩放模式**: `canvas_items` → `viewport` → stretch mode `canvas_items`
- **像素完美**: Project Settings → `rendering/2d/snap/snap_2d_transforms_to_pixel: true`
- **字体渲染**: 禁用抗锯齿，保持像素锐利
- **调色板限制**: 每层场景使用 ≤32 色的统一调色板

### 4.7 性能要求

| 指标 | 目标 |
|---|---|
| 帧率 | 稳定 60 FPS |
| 启动时间 | ≤3 秒（从点击到主菜单） |
| 场景切换 | ≤1 秒（楼梯间过渡动画期间加载） |
| 内存占用 | ≤256 MB |
| 包体大小 | ≤200 MB（含素材） |

### 4.8 中英双语方案

- UI 文本（菜单/按钮/提示）: 使用 Godot 内置 CSV 翻译（`localization/` 目录）
- 游戏内文字（线索/NPC 对话/日记）: **始终显示英文**（这是核心设计）
- 中文辅助: 菜单中可选开启「中文提示」，在咒语书和物品栏中显示中文翻译（但不显示游戏世界中的英文线索翻译）

---

## 5. Art & Audio Specification

### 5.1 美术风格

| 元素 | 规格 |
|---|---|
| 角色精灵 | 24×24 像素，4 帧步行动画（上下左右各 4 帧） |
| NPC 精灵 | 24×24 像素，2–4 帧待机动画 |
| 场景物件 | 16×16 / 32×32 像素，静态 + 少量动画帧 |
| 瓦片地图 | 16×16 像素 TileMap，每层独立 tileset |
| UI 元素 | 像素边框、像素按钮、像素图标 |
| 色调方案 | 每层统一暖/冷色调，重要交互对象用高亮对比色 |
| 粒子特效 | 简单像素粒子（火花、光点、烟雾） |

### 5.2 关键动画清单

| 动画 | 帧数 | 说明 |
|---|---|---|
| 玩家行走 | 4帧/方向 ×4方向 | 上下左右各一套 |
| 玩家交互 | 2帧 | 伸手/施咒动作 |
| Owly 飞行待机 | 4帧 | 原地扇翅膀 |
| 咒语施放 | 6帧 | 光效从角色飞向目标 |
| 咒语成功 | 4帧 | 目标闪烁/消失/变化 |
| 咒语失败 | 3帧 | 目标短暂晃动 → 恢复 |
| 门打开 | 4帧 | 像素滑动/淡出 |
| 收集物品 | 4帧 | 物品飞入背包动画 |
| 楼梯激活 | 持续 | 光柱上升循环动画 |

### 5.3 音效清单

| 类别 | 数量 | 说明 |
|---|---|---|
| UI 音效 | 5 | 菜单选择、确认、取消、翻页、存档 |
| 交互音效 | 8 | 拾取、放下、开门、关门、拉杆、按钮 |
| 咒语音效 | 4 | 施放、成功、失败、收集咒语碎片 |
| 环境音效 | 7 | 每层独特环境音（风声、火焰、水流、齿轮、书页、星尘、钟声） |
| 脚步声 | 3 | 石地、木地、草地（按楼层材质） |
| 背景音乐 | 8 | 主菜单 + 7 层各一曲（loopable） |

---

## 6. Risks & Roadmap

### 6.1 Technical Risks

| 风险 | 概率 | 影响 | 缓解策略 |
|---|---|---|---|
| **素材风格不统一** | 中 | 中 | 购买前先试用 demo；限制素材包来源 ≤2 个；统一调色板后处理 |
| **谜题设计缺乏趣味** | 中 | 高 | 先做纸质原型/流程图验证每个谜题；尽早邀请 2–3 人试玩 1F |
| **英语难度曲线不当** | 高 | 高 | 每层词汇量预先设定；邀请目标玩家（英语初学者）试读线索文本 |
| **Godot 像素渲染问题** | 低 | 中 | 项目初期配置像素完美设置并验证；使用 TextureRect + 禁用 filter |
| **包体超出 200MB** | 低 | 低 | 音频用 OGG Vorbis 压缩；精灵图用 spritesheet 合图；Web 导出用 WASM 压缩 |
| **单人开发时间不足** | 高 | 高 | 严格控制 scope；采用 MVP → 迭代策略；必要时砍掉 5F/6F 复杂度 |

### 6.2 Phased Roadmap

```
Phase 1: MVP (Week 1–4)
├── Godot 项目初始化，目录结构，Autoload 系统
├── 玩家移动 + 基础交互
├── 咒语书系统（收集/翻阅/施放）
├── 对话系统（逐字打印 + 关键词高亮）
├── 1F 完整可玩（含 3 个谜题 + Owly 引入）
└── 交付: 可试玩 Demo

Phase 2: Core Content (Week 5–8)
├── 2F 厨房（配方合成系统）
├── 3F 温室（植物生长谜题）
├── 4F 图书馆（阅读理解 + 长文本）
├── 物品栏 + 合成系统
├── 存档/读档系统
├── 主菜单 + 暂停菜单
└── 交付: 前 4 层可玩

Phase 3: Advanced Content (Week 9–10)
├── 5F 工坊（操作序列谜题）
├── 6F 天文台（光线折射谜题）
├── 7F 最终谜题 + 结局
├── 楼梯间过渡动画
├── 音效 + 背景音乐集成
└── 交付: 全部 7 层可玩

Phase 4: Polish & Ship (Week 11–12)
├── 中英双语 UI 切换
├── 通关后词库统计
├── Bug 修复 & 难度调整（试玩反馈）
├── 性能优化 & 包体压缩
├── 导出 Windows/macOS/Linux/Web
├── 撰写 README + 操作说明
└── 交付: v1.0 发布
```

### 6.3 MVP Minimum Viable Product

MVP 必须包含：

- [x] 1F 门厅完整可玩（3 个谜题，流程 15–20 分钟）
- [x] 玩家移动 + 交互
- [x] 咒语书系统（核心循环完成）
- [x] Owly NPC 对话（展示对话系统能力）
- [x] 场景切换（至少 1F ↔ 2F 楼梯）

MVP 验证目标：
- 至少 3 人试玩并给出反馈
- 确认"不像做题"体验成立
- 确认像素美术风格可行
- 确认英语难度合适

---

## 7. Appendix

### 7.1 参考资料

| 游戏 | 参考点 |
|---|---|
| **Hyper Light Drifter** | 像素美术风格、氛围营造、无文字叙事 |
| **The Room** 系列 | 物理解谜手感、逐步揭示的机关设计 |
| **FEZ** | 视角转换解谜、像素风格、探索感 |
| **Return of the Obra Dinn** | 推理式解谜、线索拼凑 |
| **Chicory: A Colorful Tale** | 俯视冒险 + 能力驱动解谜 |
| **Duolingo** | 不参考其机制（太像做题），但参考其词汇分级的思路 |

### 7.2 词汇分级参考

| Level | CEFR | 词汇量 | 游戏楼层 | 句型复杂度 |
|---|---|---|---|---|
| Beginner | A1 | ~500 | 1F–2F | 单词 + 简单祈使句 |
| Elementary | A2 | ~1000 | 3F–4F | 短句 + 简单复合句 |
| Intermediate | B1 | ~2000 | 5F–7F | 段落 + 复合句 + 少量从句 |

### 7.3 Glossary

| 术语 | 说明 |
|---|---|
| 咒语碎片 (Spell Fragment) | 场景中可收集的英文单词/短语，解锁后可施放 |
| 咒语书 (Spell Book) | 玩家已收集咒语的浏览和施放界面 |
| 主谜题 (Boss Puzzle) | 每层核心谜题，通过后解锁楼梯 |
| 配方卡 (Recipe Card) | 描述合成配方的英文卡片 |
| 语法师 (Leximancer) | 塔的主人，游戏中未出场但通过日记/遗留线索塑造 |

---

*Document version: 1.0 | Last updated: 2025-07-17*
