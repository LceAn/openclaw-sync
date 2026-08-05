#!/usr/bin/env bash
set -euo pipefail

test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT
original_exit_trap=$(trap -p EXIT)

# shellcheck source=openclaw-sync.sh
source "$(dirname "$0")/../openclaw-sync.sh"
test "$(trap -p EXIT)" = "$original_exit_trap"

remote_matches_repo "https://github.com/example/config.git" "example/config"
remote_matches_repo "git@github.com:example/config.git" "example/config"
if remote_matches_repo "https://github.com/example/other.git" "example/config"; then
  echo "不匹配的远端不应通过核对" >&2
  exit 1
fi
test "$(redact_remote_url 'https://user:token@github.com/example/config.git')" = "https://***@github.com/example/config.git"

is_sensitive_path ".env"
is_sensitive_path "keys/client.PEM"
if is_sensitive_path ".env.example" || is_sensitive_path "config/settings.json"; then
  echo "公开示例或普通配置不应被误报" >&2
  exit 1
fi

(
  DO_PULL=false
  DO_PUSH=false
  parse_args -fp
  test "$DO_PULL" = true
  test "$DO_PUSH" = true
)

if (parse_args --config config.json >/dev/null 2>&1); then
  echo "未实现的配置文件参数不应被静默接受" >&2
  exit 1
fi
if (parse_args --workspace >/dev/null 2>&1); then
  echo "缺少工作区路径的参数不应被接受" >&2
  exit 1
fi

workspace="$test_root/workspace"
git init -q -b main "$workspace"
git -C "$workspace" config user.name "Test User"
git -C "$workspace" config user.email "test@example.com"
printf '%s\n' safe > "$workspace/config.txt"
git -C "$workspace" add config.txt
git -C "$workspace" commit -qm "initial"
git -C "$workspace" remote add origin "https://github.com/example/config.git"

WORKSPACE_DIR="$workspace"
GITHUB_REPO="example/config"
GITHUB_BRANCH="main"
DO_PULL=false
DO_PUSH=false
check_prerequisites >/dev/null

printf '%s\n' secret > "$workspace/.env"
git -C "$workspace" add -f .env
(
  cd "$workspace"
  if check_staged_sensitive_paths >/dev/null 2>&1; then
    echo "敏感文件名应阻止自动提交" >&2
    exit 1
  fi
)

test ! -e "$test_root/deleted"
if rg -q 'gh repo delete' "$(dirname "$0")/../init-github-repo.sh"; then
  echo "初始化脚本不应删除远端仓库" >&2
  exit 1
fi

printf '%s\n' "同步边界测试通过"
