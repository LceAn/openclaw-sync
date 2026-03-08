# 海底龙宫 (openclaw-sync)

> 🐉 任意 OpenClaw 工作区的智能同步神器

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/LceAn/openclaw-sync)
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)

## 🌊 什么是海底龙宫？

**海底龙宫** 是一个专为 OpenClaw 设计的配置同步工具，得名于《西游记》中孙悟空获取金箍棒的神秘宝殿。正如龙宫收藏着无数珍宝，这个工具帮助你安全、智能地同步 OpenClaw 的珍贵配置到 GitHub 宝库。

### ✨ 核心特性

- 🎯 **智能同步** - 自动检测变更，一键同步到 GitHub
- 🛡️ **安全防护** - 多层保护机制，敏感信息不泄露
- 🔄 **双向同步** - 支持拉取 + 推送，多设备协作无忧
- 📊 **详细日志** - 每次同步都有完整审计记录
- 🎨 **彩色输出** - 美观的终端界面，操作状态一目了然
- 🔧 **灵活配置** - 支持自定义仓库、分支、排除规则

### 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/LceAn/openclaw-sync.git
cd openclaw-sync

# 添加执行权限
chmod +x openclaw-sync.sh

# 同步你的 OpenClaw 配置
./openclaw-sync.sh -p
```

## 📖 完整文档

- [安装指南](docs/INSTALL.md)
- [使用手册](docs/USAGE.md)
- [配置说明](docs/CONFIG.md)
- [故障排除](docs/TROUBLESHOOTING.md)
- [API 参考](docs/API.md)

## 🎯 使用场景

### 场景 1: 每日备份
```bash
# 工作结束前，一键备份到 GitHub
./openclaw-sync.sh -p
```

### 场景 2: 多设备协作
```bash
# 切换到另一台设备前
./openclaw-sync.sh -p

# 在新设备上同步最新配置
./openclaw-sync.sh -fp
```

### 场景 3: 重大变更前
```bash
# 预览将要同步的内容
./openclaw-sync.sh -n -p

# 确认无误后执行
./openclaw-sync.sh -p
```

## 📦 安装方式

### 方式 1: Git 克隆（推荐）
```bash
git clone https://github.com/LceAn/openclaw-sync.git
cd openclaw-sync
chmod +x openclaw-sync.sh
```

### 方式 2: Homebrew（待发布）
```bash
brew tap LceAn/openclaw
brew install openclaw-sync
```

### 方式 3: 直接下载
```bash
curl -fsSL https://raw.githubusercontent.com/LceAn/openclaw-sync/main/openclaw-sync.sh -o openclaw-sync.sh
chmod +x openclaw-sync.sh
```

## 🎨 命令行参数

| 参数 | 简写 | 说明 |
|------|------|------|
| `--push` | `-p` | 推送到 GitHub |
| `--pull` | `-f` | 先拉取远程更新 |
| `--dry-run` | `-n` | 预览模式 |
| `--status` | `-s` | 仅显示状态 |
| `--verbose` | `-v` | 详细输出 |
| `--help` | `-h` | 显示帮助 |
| `--config` | `-c` | 指定配置文件 |
| `--workspace` | `-w` | 指定工作区路径 |

## 🔐 安全特性

### 默认排除的文件
```
.openclaw/          # OpenClaw 运行状态
*.token             # API 令牌
*.key               # 密钥文件
*.secret            # 机密文件
*.env               # 环境变量
*.log               # 日志文件
.DS_Store           # 系统文件
```

### 三层保护机制
1. **预览模式** - 执行前强制审查
2. **.gitignore** - 自动过滤敏感文件
3. **日志审计** - 完整操作记录

## 📊 同步模式

| 模式 | 命令 | 说明 |
|------|------|------|
| 本地提交 | `./openclaw-sync.sh` | 仅本地提交 |
| 完整同步 | `./openclaw-sync.sh -p` | 提交 + 推送 |
| 双向同步 | `./openclaw-sync.sh -fp` | 拉取 + 提交 + 推送 |
| 预览模式 | `./openclaw-sync.sh -n -p` | 查看变更 |
| 状态检查 | `./openclaw-sync.sh -s` | 查看状态 |

## 🛠️ 配置示例

创建 `~/.openclaw-sync/config.json`:

```json
{
  "github": {
    "repo": "your-username/openclaw-config",
    "branch": "main",
    "token": "${GITHUB_TOKEN}"
  },
  "workspace": {
    "path": "~/Desktop/openclaw/Config",
    "exclude": [
      ".openclaw/",
      "*.log",
      "*.env"
    ]
  },
  "sync": {
    "autoPull": true,
    "dryRun": false,
    "verbose": false
  }
}
```

## 📝 日志示例

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

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出建议！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交变更 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [OpenClaw](https://github.com/openclaw/openclaw) - 强大的 AI 助手框架
- [Git](https://git-scm.com/) - 版本控制工具
- 所有贡献者和用户

## 📬 联系方式

- **作者:** LceAn
- **GitHub:** [@LceAn](https://github.com/LceAn)
- **Issues:** [GitHub Issues](https://github.com/LceAn/openclaw-sync/issues)

## 🎯 路线图

### v1.0.0 (当前版本)
- ✅ 基础同步功能
- ✅ 安全过滤机制
- ✅ 彩色终端输出
- ✅ 详细日志记录

### v1.1.0 (计划中)
- [ ] 配置文件支持
- [ ] 多仓库同步
- [ ] Webhook 通知
- [ ] 自动备份功能

### v2.0.0 (未来计划)
- [ ] GUI 界面
- [ ] 增量同步优化
- [ ] 冲突自动解决
- [ ] 云端存储集成

---

<div align="center">

**🐉 海底龙宫 - 守护你的 OpenClaw 珍宝**

[⭐ Star 这个仓库](https://github.com/LceAn/openclaw-sync) | [📖 查看文档](docs/) | [🐛 报告问题](https://github.com/LceAn/openclaw-sync/issues)

</div>
