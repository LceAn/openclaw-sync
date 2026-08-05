# openclaw-sync

使用 Git 提交和同步 OpenClaw 配置工作区的 Bash 工具。它适合已经把配置目录初始化为独立 Git 仓库，并明确知道要同步到哪个 GitHub 仓库的场景。

## 使用前提

- Bash 3.2+、Git 2.x
- 配置工作区本身必须是 Git 仓库
- 当前分支必须与 `OPENCLAW_SYNC_BRANCH` 一致
- `origin` 必须精确指向 `OPENCLAW_SYNC_REPO`

```bash
git clone https://github.com/LceAn/openclaw-sync.git
cd openclaw-sync
chmod +x openclaw-sync.sh

export OPENCLAW_SYNC_WORKSPACE="$HOME/Desktop/openclaw/Config"
export OPENCLAW_SYNC_REPO="your-account/openclaw-config"
export OPENCLAW_SYNC_BRANCH="main"
```

## 操作

```bash
./openclaw-sync.sh --status
./openclaw-sync.sh --dry-run --push
./openclaw-sync.sh --push
./openclaw-sync.sh --pull --push
```

| 参数 | 行为 |
| --- | --- |
| `-s`, `--status` | 查看工作区、提交和远端差异 |
| `-n`, `--dry-run` | 只列出变化，不修改 Git 状态 |
| `-p`, `--push` | 暂存、提交并推送 |
| `-f`, `--pull` | 提交前执行 `pull --rebase --autostash` |
| `-w`, `--workspace` | 临时指定工作区 |
| `-v`, `--verbose` | 输出调试日志 |

兼容 `-fp` 和 `-pf` 组合。`--config` 目前会明确报错；JSON 配置文件尚未实现，应使用环境变量，避免出现“看似读取、实际忽略”的配置。

## 安全边界

- 执行前核对工作区、当前分支和 `origin`，不一致时停止。
- 拉取发生冲突或失败时停止，不继续提交本地内容。
- 自动提交前拦截 `.env`、私钥、证书、Token 和 credentials JSON 等敏感文件名；`.env.example` 允许提交。
- 文件名检查不能识别普通 JSON 或 Markdown 中的密钥内容，首次同步前仍应运行 `git diff --cached` 或使用专门的密钥扫描工具。
- `init-github-repo.sh` 只创建不存在的仓库。发现同名远端时直接退出，不删除或重建。
- 不执行强制推送、历史重写或远端分支删除。

同步日志写入本工具目录的 `logs/`，由 `.gitignore` 排除。状态输出会遮盖 HTTPS 远端 URL 中内嵌的凭据。

## 验证

```bash
bash -n openclaw-sync.sh quick-start.sh init-github-repo.sh tests/test_sync.sh
shellcheck -x openclaw-sync.sh quick-start.sh init-github-repo.sh tests/test_sync.sh
bash tests/test_sync.sh
```

测试使用临时本地 Git 仓库，不连接或修改真实 GitHub 仓库。

## 文档

- [安装与认证](docs/INSTALL.md)
- [使用与故障处理](docs/USAGE.md)
- `PROJECT-PLAN.md` 和 `TaskBoard/` 保存早期产品设想，不代表当前已实现功能。

## 许可

[MIT](LICENSE)

<!-- repo-readme-standard:v1 -->
## 仓库维护信息

- 项目类型：Git 配置同步工具
- 当前状态：维护中
- 可见性：public
- 维护节奏：按月检查 Git 边界、敏感文件规则和跨平台 Shell 兼容性
- 相关仓库：`openclaw-config` 是默认数据仓库，`openclaw-sync` 是同步工具，职责不同不合并
- 维护边界：归档、删除、历史重写或强制推送需单独确认
