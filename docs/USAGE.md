# 使用与故障处理

## 推荐流程

```bash
./openclaw-sync.sh --status
./openclaw-sync.sh --dry-run --push
./openclaw-sync.sh --pull --push
```

`--dry-run` 不执行拉取、暂存、提交或推送。正式同步使用 `git add -A`，因此新增、修改和删除都会进入提交。

## 多设备同步

每台设备都应使用同一个仓库与分支，并在修改前先拉取：

```bash
./openclaw-sync.sh -fp
```

拉取使用 rebase 与 autostash。发生冲突时工具停止，需在工作区中使用标准 Git 命令检查和处理；它不会自动选择冲突一方。

## 敏感文件

工具在暂存后检查高风险文件名。若被拦截：

```bash
git status --short
git restore --staged path/to/file
printf '%s\n' 'path/to/file' >> .gitignore
```

如果文件已经进入历史，仅修改 `.gitignore` 不会删除旧提交中的内容。应先轮换凭据，再单独评估历史清理。

## 常见错误

- `origin 与目标仓库不一致`：核对 `git remote get-url origin` 与 `OPENCLAW_SYNC_REPO`。
- `当前分支...预期分支...`：切换正确分支，或修改 `OPENCLAW_SYNC_BRANCH`。
- `无法通过 origin 访问`：检查 SSH Agent、凭据管理器和仓库权限。
- `拉取失败，停止同步`：进入工作区运行 `git status`，处理 rebase 或冲突后重试。

日志位于工具仓库的 `logs/`。日志用于记录流程，不应依赖它保存凭据或完整文件内容。
