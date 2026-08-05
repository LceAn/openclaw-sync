# 安装与认证

## 安装

```bash
git clone https://github.com/LceAn/openclaw-sync.git
cd openclaw-sync
chmod +x openclaw-sync.sh quick-start.sh
./openclaw-sync.sh --version
```

支持 macOS、Linux 和 WSL，需要 Bash 3.2+ 与 Git 2.x。直接下载脚本时使用 HTTPS，并在执行前检查内容：

```bash
curl -fsSL --proto '=https' --tlsv1.2 \
  https://raw.githubusercontent.com/LceAn/openclaw-sync/main/openclaw-sync.sh \
  -o openclaw-sync.sh
```

## 工作区

同步目标必须已经是 Git 仓库，并配置正确的 `origin`：

```bash
cd "$HOME/Desktop/openclaw/Config"
git init -b main
git remote add origin git@github.com:your-account/openclaw-config.git
```

然后设置：

```bash
export OPENCLAW_SYNC_WORKSPACE="$HOME/Desktop/openclaw/Config"
export OPENCLAW_SYNC_REPO="your-account/openclaw-config"
export OPENCLAW_SYNC_BRANCH="main"
```

工具接受标准 GitHub HTTPS 或 SSH `origin`。不要把 Token 写入脚本、配置文件或远端 URL；优先使用 SSH Agent、macOS Keychain、Git Credential Manager 或系统密钥环。

## 验证

```bash
./openclaw-sync.sh --status
./openclaw-sync.sh --dry-run --push
```

只有工作区、分支和远端仓库全部核对通过后，工具才会进入同步流程。
