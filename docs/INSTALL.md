# 安装指南

本文档介绍如何安装和配置 **海底龙宫 (openclaw-sync)**。

## 📋 系统要求

- **操作系统:** macOS, Linux, WSL
- **Git:** 2.0 或更高版本
- **Bash:** 4.0 或更高版本
- **网络:** 能够访问 GitHub

## 🚀 安装方式

### 方式 1: Git 克隆（推荐）

适合需要最新功能和贡献代码的用户。

```bash
# 1. 克隆仓库
git clone https://github.com/LceAn/openclaw-sync.git
cd openclaw-sync

# 2. 添加执行权限
chmod +x openclaw-sync.sh

# 3. 验证安装
./openclaw-sync.sh --version
```

**输出示例：**
```
海底龙宫 (openclaw-sync) v1.0.0
```

---

### 方式 2: 直接下载

适合快速使用，不需要 Git 仓库。

```bash
# 1. 下载脚本
curl -fsSL https://raw.githubusercontent.com/LceAn/openclaw-sync/main/openclaw-sync.sh -o openclaw-sync.sh

# 2. 添加执行权限
chmod +x openclaw-sync.sh

# 3. 验证安装
./openclaw-sync.sh --version
```

---

### 方式 3: Homebrew（待发布）

```bash
# 添加 tap
brew tap LceAn/openclaw

# 安装
brew install openclaw-sync

# 验证
openclaw-sync --version
```

---

## ⚙️ 配置

### 方式 1: 命令行参数（临时）

```bash
# 指定工作区
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -p

# 指定 GitHub 仓库（需要修改脚本或使用环境变量）
OPENCLAW_SYNC_REPO="my-username/my-config" ./openclaw-sync.sh -p
```

---

### 方式 2: 环境变量（推荐）

在 `~/.bashrc` 或 `~/.zshrc` 中添加：

```bash
# 海底龙宫配置
export OPENCLAW_SYNC_WORKSPACE=~/Desktop/openclaw/Config
export OPENCLAW_SYNC_REPO="LceAn/openclaw-config"
export OPENCLAW_SYNC_BRANCH="main"
```

然后重新加载配置：

```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

---

### 方式 3: 配置文件（计划中）

创建 `~/.openclaw-sync/config.json`:

```json
{
  "github": {
    "repo": "LceAn/openclaw-config",
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

使用配置文件：

```bash
./openclaw-sync.sh -c ~/.openclaw-sync/config.json -p
```

---

## 🔐 GitHub 认证配置

### 方式 1: HTTPS + 凭证缓存（推荐）

```bash
# 启用凭证缓存
git config --global credential.helper cache

# 或者永久存储（macOS）
git config --global credential.helper osxkeychain

# 或者永久存储（Linux）
git config --global credential.helper store
```

第一次推送时会提示输入 GitHub 用户名和密码（或个人访问令牌）。

---

### 方式 2: SSH 密钥（更安全）

```bash
# 1. 生成 SSH 密钥
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. 添加公钥到 GitHub
# 访问：https://github.com/settings/keys
# 复制 ~/.ssh/id_ed25519.pub 的内容

# 3. 测试连接
ssh -T git@github.com

# 4. 修改脚本中的仓库 URL 为 SSH 格式
# git remote set-url origin git@github.com:LceAn/openclaw-config.git
```

---

### 方式 3: 个人访问令牌（推荐用于 CI/CD）

```bash
# 1. 创建令牌
# 访问：https://github.com/settings/tokens
# 勾选：repo, workflow

# 2. 使用令牌
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"

# 3. 在 URL 中使用
# https://GITHUB_TOKEN@github.com/LceAn/openclaw-config.git
```

---

## ✅ 验证安装

### 1. 检查版本

```bash
./openclaw-sync.sh --version
```

**预期输出：**
```
海底龙宫 (openclaw-sync) v1.0.0
```

---

### 2. 查看帮助

```bash
./openclaw-sync.sh --help
```

**预期输出：** 完整的帮助信息

---

### 3. 检查状态

```bash
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -s
```

**预期输出：**
```
╔══════════════════════════════════════════════╗
║          🐉  海底龙宫 (openclaw-sync)        ║
║                                              ║
║              OpenClaw 同步工具 v1.0.0        ║
║                                              ║
╚══════════════════════════════════════════════╝

============================================
前置检查
============================================
[SUCCESS] Git 已安装：git version 2.39.5
[SUCCESS] 工作区目录存在：/Users/macmini/Desktop/openclaw/Config
[SUCCESS] GitHub 仓库可访问：LceAn/openclaw-config

============================================
同步状态检查
============================================
...
```

---

### 4. 预览同步

```bash
./openclaw-sync.sh -w ~/Desktop/openclaw/Config -n -p
```

**预期输出：** 将要同步的文件列表

---

## 🔧 故障排除

### 问题 1: 权限被拒绝

**症状：** `Permission denied (publickey).`

**解决方案：**
```bash
# 添加执行权限
chmod +x openclaw-sync.sh

# 或者配置 SSH 密钥（见上方）
```

---

### 问题 2: Git 未安装

**症状：** `Git 未安装，请先安装 Git`

**解决方案：**

**macOS:**
```bash
brew install git
```

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install git
```

**CentOS/RHEL:**
```bash
sudo yum install git
```

---

### 问题 3: GitHub 认证失败

**症状：** `Authentication failed`

**解决方案：**

1. 检查凭证：
```bash
git config --global --unset credential.helper
git credential-cache exit
```

2. 重新配置：
```bash
git config --global credential.helper osxkeychain
```

3. 使用个人访问令牌替代密码

---

### 问题 4: 工作区目录不存在

**症状：** `工作区目录不存在：./Config`

**解决方案：**

```bash
# 指定正确的工作区路径
./openclaw-sync.sh -w /path/to/your/openclaw/Config -p

# 或者设置环境变量
export OPENCLAW_SYNC_WORKSPACE=/path/to/your/openclaw/Config
```

---

## 📝 下一步

安装完成后，请查看：

- [使用手册](USAGE.md) - 学习如何使用海底龙宫
- [配置说明](CONFIG.md) - 了解详细配置选项
- [故障排除](TROUBLESHOOTING.md) - 解决常见问题

---

*最后更新：2026-03-08*  
*版本：1.0.0*
