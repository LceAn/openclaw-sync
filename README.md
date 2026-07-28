# 🐉 海底龙宫 (Dragon Palace)

> 🔄 跨设备 OpenClaw 同步管理工具 - 实现 Mac、Windows、Linux 多设备间的 OpenClaw 配置同步和协同工作

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/LceAn/openclaw-sync)
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)

---

## 📖 项目简介

**海底龙宫** 是一个专为 OpenClaw 设计的跨设备配置同步工具，得名于《西游记》中孙悟空获取金箍棒的神秘宝殿。正如龙宫收藏着无数珍宝，这个工具帮助你安全、智能地同步 OpenClaw 的珍贵配置到 GitHub 宝库。

通过海底龙宫，你可以轻松实现：
- 🏠 **局域网协同** - 同一网络下的多台设备共享配置
- 🌐 **异地组网** - 不同地点的设备也能保持配置一致
- 🔄 **自动同步** - 配置变更自动推送到云端
- 🛡️ **安全保障** - 敏感信息自动过滤，绝不泄露

---

## 🐉 角色设定

### 🏰 龙宫（控制台）
- **定位**：中央控制中心
- **功能**：配置管理、同步调度、状态监控
- **部署**：建议部署在稳定的服务器上

### 🦞 龙虾（OpenClaw 客户端）
- **定位**：执行终端
- **功能**：接收配置、执行同步、上报状态
- **部署**：每台运行 OpenClaw 的设备

### 🌊 海域（网络适配）
- **定位**：通信桥梁
- **功能**：网络穿透、数据传输、加密通信
- **支持**：局域网、互联网、混合网络

---

## 💡 核心理念

1. **配置即代码** - 所有配置版本化、可追溯
2. **安全优先** - 敏感信息自动过滤，绝不上传
3. **简单易用** - 一键同步，无需复杂配置
4. **跨平台** - Mac、Windows、Linux 全支持

---

## 🌊 使用场景

### 场景一：🏠 局域网协同

**场景描述：**
家里有多台设备（MacBook、iMac、Linux 服务器），希望共享 OpenClaw 配置。

**解决方案：**
```bash
# 主设备配置
./openclaw-sync.sh -p  # 推送到 GitHub

# 其他设备配置
./openclaw-sync.sh -fp  # 拉取 + 推送（双向同步）
```

**效果：**
- ✅ 所有设备配置一致
- ✅ 修改一处，处处生效
- ✅ 无需手动复制配置文件

---

### 场景二：🌐 异地组网

**场景描述：**
公司和家里的设备需要同步 OpenClaw 配置，但网络环境不同。

**解决方案：**
```bash
# 公司设备
export OPENCLAW_SYNC_REPO="your-username/openclaw-config"
./openclaw-sync.sh -p

# 家里设备
export OPENCLAW_SYNC_REPO="your-username/openclaw-config"
./openclaw-sync.sh -fp
```

**效果：**
- ✅ 跨地域配置同步
- ✅ 自动解决冲突
- ✅ 完整审计日志

---

## ✨ 核心功能

### 1. 🏰 龙宫（控制台）

**功能列表：**
- ✅ 工作区管理 - 添加/删除/切换工作区
- ✅ 同步配置 - GitHub 仓库、分支、排除规则
- ✅ 状态监控 - 实时查看同步状态
- ✅ 日志审计 - 完整的操作记录

**使用示例：**
```bash
# 查看状态
./openclaw-sync.sh -s

# 预览变更
./openclaw-sync.sh -n -p

# 执行同步
./openclaw-sync.sh -p
```

---

### 2. 🦞 龙虾（OpenClaw 客户端）

**功能列表：**
- ✅ 配置加载 - 从 GitHub 拉取最新配置
- ✅ 本地应用 - 将配置应用到 OpenClaw
- ✅ 状态上报 - 同步状态反馈到控制台
- ✅ 冲突处理 - 智能合并配置冲突

**使用示例：**
```bash
# 拉取并应用配置
./openclaw-sync.sh -fp

# 仅查看差异
./openclaw-sync.sh -n
```

---

### 3. 🌊 海域（网络适配）

**功能列表：**
- ✅ 局域网发现 - 自动发现同一网络的设备
- ✅ 互联网同步 - 通过 GitHub 中转同步
- ✅ 加密传输 - 所有数据传输均加密
- ✅ 断点续传 - 网络中断后自动恢复

**网络场景：**
| 场景 | 方案 | 延迟 | 安全性 |
|------|------|------|--------|
| 局域网 | 直连 | <10ms | 高 |
| 互联网 | GitHub 中转 | <1s | 极高 |
| 混合网络 | 智能选择 | 自适应 | 高 |

---

## 🏗️ 技术架构

```
┌─────────────────────────────────────────────────┐
│                   海底龙宫架构                   │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌─────────────┐      ┌─────────────┐         │
│  │   龙宫      │      │   龙虾 1     │         │
│  │  (控制台)   │◄────►│ (MacBook)   │         │
│  │             │      │             │         │
│  └──────┬──────┘      └─────────────┘         │
│         │                                     │
│         ├──────────────────────────┐          │
│         │                          │          │
│  ┌──────▼──────┐      ┌─────────────┐         │
│  │   GitHub    │      │   龙虾 2     │         │
│  │   (云端)    │◄────►│ (iMac)      │         │
│  │             │      │             │         │
│  └─────────────┘      └─────────────┘         │
│                              │                 │
│                    ┌─────────▼──────┐         │
│                    │    龙虾 3       │         │
│                    │  (Linux Server) │         │
│                    │                 │         │
│                    └─────────────────┘         │
│                                                 │
└─────────────────────────────────────────────────┘
```

**技术栈：**
- **前端：** Bash 脚本 + 可选 GUI（Tauri + React）
- **后端：** Git + GitHub API
- **安全：** .gitignore 过滤 + 加密传输
- **跨平台：** Mac、Windows、Linux 全支持

---

## ⚙️ 配置系统

### 🎛️ 懒人模式（默认配置）

**适用人群：** 不想折腾配置的用户

**配置方式：**
```bash
# 只需设置环境变量
export OPENCLAW_SYNC_REPO="your-username/openclaw-config"

# 然后直接运行
./openclaw-sync.sh -p
```

**默认配置：**
- 仓库：`your-username/openclaw-config`
- 分支：`main`
- 排除规则：内置默认规则

---

### 🔧 极客模式（完全自定义）

**适用人群：** 需要精细控制的用户

**配置方式：**
```bash
# 创建配置文件 ~/.openclaw-sync/config.json
cat > ~/.openclaw-sync/config.json << EOF
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
      "*.env",
      "*.token",
      "*.key"
    ]
  },
  "sync": {
    "autoPull": true,
    "dryRun": false,
    "verbose": false
  }
}
EOF

# 使用配置文件
./openclaw-sync.sh -c ~/.openclaw-sync/config.json -p
```

---

## 🚀 快速开始

### 方式一：懒人模式

```bash
# 1. 克隆仓库
git clone https://github.com/LceAn/openclaw-sync.git
cd openclaw-sync

# 2. 添加执行权限
chmod +x openclaw-sync.sh

# 3. 设置环境变量
export OPENCLAW_SYNC_REPO="your-username/openclaw-config"

# 4. 同步配置
./openclaw-sync.sh -p
```

---

### 方式二：极客模式

```bash
# 1. 克隆仓库
git clone https://github.com/LceAn/openclaw-sync.git
cd openclaw-sync

# 2. 创建配置文件
mkdir -p ~/.openclaw-sync
cat > ~/.openclaw-sync/config.json << EOF
{
  "github": {
    "repo": "your-username/openclaw-config",
    "branch": "main"
  },
  "workspace": {
    "path": "~/Desktop/openclaw/Config"
  }
}
EOF

# 3. 同步配置
./openclaw-sync.sh -c ~/.openclaw-sync/config.json -p
```

---

## 📊 网络场景对比

| 场景 | 设备数量 | 网络环境 | 推荐方案 | 同步频率 |
|------|---------|---------|---------|---------|
| 个人使用 | 1-2 | 单一网络 | 懒人模式 | 每天 1 次 |
| 家庭协同 | 2-5 | 局域网 | 极客模式 | 实时 |
| 团队协作 | 5+ | 混合网络 | 极客模式 + 定时任务 | 每小时 |
| 跨地域 | 2+ | 互联网 | GitHub 中转 | 每天 2 次 |

---

## 🛡️ 安全设计

### 三层保护机制

**1. 预览模式**
```bash
# 执行前强制审查
./openclaw-sync.sh -n -p
```

**2. .gitignore 过滤**
```
# 自动排除的敏感文件
.openclaw/          # OpenClaw 运行状态
*.token             # API 令牌
*.key               # 密钥文件
*.secret            # 机密文件
*.env               # 环境变量
*.log               # 日志文件
.DS_Store           # 系统文件
```

**3. 日志审计**
```
# 每次同步生成独立日志
logs/sync-20260308_153045.log
```

### 加密传输

- ✅ HTTPS 传输
- ✅ GitHub OAuth 认证
- ✅ 本地密钥存储（Keychain/Secret Service）

---

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

---

## 🎨 命令行参数

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

---

## 📝 使用示例

### 日常同步

```bash
# 工作结束前，一键备份
./openclaw-sync.sh -p
```

### 多设备协作

```bash
# 设备 A：推送
./openclaw-sync.sh -p

# 设备 B：拉取 + 推送
./openclaw-sync.sh -fp
```

### 重大变更前

```bash
# 1. 预览变更
./openclaw-sync.sh -n -p

# 2. 确认无误后同步
./openclaw-sync.sh -p
```

### 故障排查

```bash
# 查看详细状态
./openclaw-sync.sh -s -v

# 查看日志
cat logs/sync-*.log | tail -50
```

---

## 🤝 贡献指南

欢迎贡献代码、报告问题或提出建议！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交变更 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 🙏 致谢

- [OpenClaw](https://github.com/openclaw/openclaw) - 强大的 AI 助手框架
- [Git](https://git-scm.com/) - 版本控制工具
- 所有贡献者和用户

---

## 📬 联系方式

- **作者:** LceAn
- **GitHub:** [@LceAn](https://github.com/LceAn)
- **Issues:** [GitHub Issues](https://github.com/LceAn/openclaw-sync/issues)

---

<div align="center">

**🐉 海底龙宫 - 守护你的 OpenClaw 珍宝**

[⭐ Star 这个仓库](https://github.com/LceAn/openclaw-sync) | [📖 查看文档](docs/) | [🐛 报告问题](https://github.com/LceAn/openclaw-sync/issues)

</div>

---

## 仓库结构

- `.gitignore`
- `LICENSE`
- `PROJECT-PLAN.md`
- `README.md`
- `TaskBoard/`
- `docs/`
- `init-github-repo.sh`
- `openclaw-sync.sh`
- `quick-start.sh`

<!-- repo-readme-standard:v1 -->
## 仓库维护信息

- 项目类型：产品/工具
- 当前状态：待复盘
- 可见性：public
- 维护节奏：每月只选 1-2 个小更新
- 相关仓库：无已确认的重复仓库关系；如需合并请先核对功能边界。
- 维护边界：普通文档和代码更新可直接提交；归档、删除、历史重写或强制推送需单独确认。
