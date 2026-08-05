#!/usr/bin/env bash
# =============================================================================
# 海底龙宫 - GitHub 仓库初始化脚本
# =============================================================================
# 用法：./init-github-repo.sh
# 功能：创建并初始化 GitHub 仓库
# =============================================================================

set -euo pipefail

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║  海底龙宫 - GitHub 仓库初始化                ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

info() { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# 配置
REPO_NAME="openclaw-sync"
REPO_DESC="🐉 海底龙宫 - OpenClaw 配置同步神器"
REPO_VISIBILITY="public"  # 或 "private"

print_header

info "这将帮助你创建 GitHub 仓库：$REPO_NAME"
echo ""

# 检查 gh CLI
if ! command -v gh &> /dev/null; then
    warn "GitHub CLI (gh) 未安装"
    echo ""
    echo "请安装 GitHub CLI:"
    echo "  macOS:  brew install gh"
    echo "  Linux:  sudo apt install gh"
    echo ""
    echo "或者手动创建仓库："
    echo "  1. 访问 https://github.com/new"
    echo "  2. 仓库名：$REPO_NAME"
    echo "  3. 描述：$REPO_DESC"
    echo "  4. 可见性：$REPO_VISIBILITY"
    echo "  5. 勾选 'Add a README file'"
    echo "  6. 点击 'Create repository'"
    echo ""
    exit 0
fi

# 检查登录状态
if ! gh auth status &> /dev/null; then
    info "请先登录 GitHub..."
    gh auth login
fi

# 检查仓库是否已存在
if gh repo view "$REPO_NAME" &> /dev/null; then
    warn "仓库已存在：$REPO_NAME"
    info "为避免误删远端数据，初始化脚本不会删除或重建现有仓库。"
    exit 1
fi

# 创建仓库
info "创建仓库：$REPO_NAME"
gh repo create "$REPO_NAME" \
    --description "$REPO_DESC" \
    --$REPO_VISIBILITY \
    --source=. \
    --remote=origin \
    --push

success "仓库创建成功！"
echo ""
info "仓库 URL: https://github.com/LceAn/$REPO_NAME"
info "下一步："
echo "  1. 完善 README.md"
echo "  2. 添加许可证"
echo "  3. 配置 GitHub Actions（可选）"
echo "  4. 发布第一个版本"
echo ""
