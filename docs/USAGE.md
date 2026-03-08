# 使用手册

本文档详细介绍 **海底龙宫 (openclaw-sync)** 的使用方法和场景。

## 📖 快速开始

### 基础用法

```bash
# 1. 进入脚本目录
cd /path/to/openclaw-sync

# 2. 预览变更（推荐先执行）
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -n -p

# 3. 执行同步
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -p

# 4. 验证结果
# 访问：https://github.com/LceAn/openclaw-config
```

---

## 🎯 命令行参数

### 基本参数

| 参数 | 简写 | 说明 | 默认值 |
|------|------|------|--------|
| `--push` | `-p` | 推送到 GitHub | ❌ |
| `--pull` | `-f` | 先拉取远程更新 | ❌ |
| `--dry-run` | `-n` | 预览模式 | ❌ |
| `--status` | `-s` | 仅显示状态 | ❌ |
| `--verbose` | `-v` | 详细输出 | ❌ |
| `--workspace` | `-w` | 指定工作区路径 | `./Config` |
| `--config` | `-c` | 指定配置文件 | 无 |
| `--help` | `-h` | 显示帮助 | - |
| `--version` | `-V` | 显示版本号 | - |

---

## 🔄 同步模式

### 模式 1: 本地提交

```bash
./openclaw-sync.sh -w ~/Desktop/openclaw/Config
```

**执行流程：**
1. ✅ 检测工作区变更
2. ✅ 添加变更到 Git 暂存区
3. ✅ 创建本地提交
4. ❌ 不推送到远程仓库

**适用场景：**
- 本地备份
- 审查变更后再推送
- 网络不可用时

---

### 模式 2: 完整同步

```bash
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -p
```

**执行流程：**
1. ✅ 检测工作区变更
2. ✅ 添加变更
3. ✅ 创建提交
4. ✅ 推送到 GitHub

**适用场景：**
- 日常同步
- 工作结束后备份
- 单设备使用

---

### 模式 3: 双向同步

```bash
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -fp
```

**执行流程：**
1. ✅ 从远程拉取最新变更
2. ✅ 自动合并（如有冲突会提示）
3. ✅ 添加本地变更
4. ✅ 创建提交
5. ✅ 推送到 GitHub

**适用场景：**
- 多设备协作
- 长时间未同步后
- 团队共同维护配置

---

### 模式 4: 预览模式

```bash
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -n -p
```

**执行流程：**
1. ✅ 检测工作区变更
2. ✅ 显示将要同步的文件
3. ✅ 显示变更类型（新增/修改/删除）
4. ❌ 不执行实际操作

**适用场景：**
- 审查变更内容
- 确认没有敏感文件
- 首次同步前检查

**输出示例：**
```
============================================
预览变更
============================================

=== 将要同步的变更 ===

新文件（将添加）:
  + .gitignore
  + MEMORY.md
  + SOUL.md

修改的文件:
  ~ AGENTS.md
  ~ TODO.md

如果执行同步，将提交上述变更到：LceAn/openclaw-config
```

---

### 模式 5: 状态检查

```bash
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -s
```

**输出内容：**
- Git 状态（未跟踪/已修改/已删除的文件）
- 最近 5 条提交历史
- 远程仓库信息
- 本地与远程的差异

**适用场景：**
- 快速检查同步状态
- 故障排查
- 日常查看

---

## 📊 典型使用场景

### 场景 1: 每日工作备份

**时间：** 每天工作结束时

```bash
# 快速同步到 GitHub
./openclaw-sync.sh -p
```

**说明：** 假设已配置环境变量 `OPENCLAW_SYNC_WORKSPACE`

---

### 场景 2: 多设备协作

**设备 A（办公室）：**
```bash
# 下班前推送变更
./openclaw-sync.sh -p
```

**设备 B（家中）：**
```bash
# 开始工作前拉取最新变更
./openclaw-sync.sh -fp
```

**说明：** `-f` 参数确保先拉取远程更新，避免冲突

---

### 场景 3: 重大变更前

```bash
# 1. 预览变更
./openclaw-sync.sh -n -p

# 2. 确认无误后同步
./openclaw-sync.sh -p
```

**说明：** 预览模式避免误同步敏感文件

---

### 场景 4: 长时间未同步

```bash
# 双向同步（拉取 + 推送）
./openclaw-sync.sh -fp -v
```

**说明：** `-v` 参数显示详细信息，便于排查可能的冲突

---

### 场景 5: 故障排查

```bash
# 1. 查看详细状态
./openclaw-sync.sh -s -v

# 2. 查看日志文件
ls -lt logs/ | head -1
cat logs/sync-*.log | tail -50
```

---

## 🔧 高级用法

### 指定工作区

```bash
# 临时指定工作区
./openclaw-sync.sh -w ~/my-other-config -p

# 或者使用环境变量
export OPENCLAW_SYNC_WORKSPACE=~/my-other-config
./openclaw-sync.sh -p
```

---

### 详细输出模式

```bash
# 显示详细调试信息
./openclaw-sync.sh -v -p
```

**输出示例：**
```
[DEBUG] 加载配置...
[DEBUG] 工作区：/Users/macmini/Desktop/openclaw/Config
[DEBUG] GitHub 仓库：LceAn/openclaw-config
[DEBUG] 分支：main
[DEBUG] 日志文件：logs/sync-config-20260308_153045.log
```

---

### 使用配置文件（计划中）

```bash
# 创建配置文件
cat > ~/.openclaw-sync/config.json << EOF
{
  "github": {
    "repo": "LceAn/openclaw-config",
    "branch": "main"
  },
  "workspace": {
    "path": "~/Desktop/openclaw/Config"
  }
}
EOF

# 使用配置文件
./openclaw-sync.sh -c ~/.openclaw-sync/config.json -p
```

---

## 📝 日志管理

### 日志位置

```
/path/to/openclaw-sync/logs/sync-<工作区>-<时间戳>.log
```

### 查看最新日志

```bash
# 列出最新日志
ls -lt logs/ | head -1

# 查看日志内容
cat logs/sync-*.log | tail -100
```

### 日志格式

```
[2026-03-08 15:30:45] [INFO] ============================================
[2026-03-08 15:30:45] [INFO] 海底龙宫 - OpenClaw 同步工具 v1.0.0
[2026-03-08 15:30:46] [SUCCESS] Git 已安装：git version 2.39.5
[2026-03-08 15:30:47] [SUCCESS] GitHub 仓库可访问：LceAn/openclaw-config
[2026-03-08 15:30:48] [INFO] 检测到 3 个变更
[2026-03-08 15:30:49] [SUCCESS] 提交成功
[2026-03-08 15:30:52] [SUCCESS] 推送成功
[2026-03-08 15:30:52] [INFO] 同步完成！
```

---

## 🎨 输出颜色说明

| 颜色 | 级别 | 说明 |
|------|------|------|
| 🟢 绿色 | SUCCESS | 操作成功 |
| 🔵 蓝色 | INFO | 一般信息 |
| 🟡 黄色 | WARN | 警告信息 |
| 🔴 红色 | ERROR | 错误信息 |
| 🟣 紫色 | DEBUG | 调试信息（需 -v） |

---

## ⚠️ 注意事项

### 1. 敏感文件保护

**永远不要同步以下文件：**
- `.openclaw/` - OpenClaw 运行状态
- `*.token`, `*.key`, `*.secret` - 密钥文件
- `*.env` - 环境变量
- `*.log` - 日志文件（可能包含敏感信息）

**建议：** 始终先用 `-n` 预览模式检查变更

---

### 2. 冲突处理

如果遇到合并冲突：

```bash
# 1. 进入工作区
cd ~/Desktop/openclaw/Config

# 2. 手动解决冲突文件
# 编辑冲突文件，保留需要的内容

# 3. 标记为解决
git add <文件名>

# 4. 完成提交
git commit -m "解决合并冲突"

# 5. 推送
git push origin main
```

---

### 3. 网络问题

如果推送失败：

```bash
# 检查网络连接
ping github.com

# 检查 Git 配置
git remote -v

# 测试 GitHub 连接
git ls-remote https://github.com/LceAn/openclaw-config.git
```

---

## 📚 相关文档

- [安装指南](INSTALL.md) - 安装和配置
- [配置说明](CONFIG.md) - 详细配置选项
- [故障排除](TROUBLESHOOTING.md) - 解决常见问题
- [API 参考](API.md) - 开发者接口

---

*最后更新：2026-03-08*  
*版本：1.0.0*
