#!/bin/bash
# =============================================================================
# 海底龙宫 - 快速启动脚本
# =============================================================================
# 用法：./quick-start.sh
# 功能：交互式引导完成首次同步
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYNC_SCRIPT="$SCRIPT_DIR/openclaw-sync.sh"

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║          🐉  海底龙宫快速启动                ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}步骤 $1: $2${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

check_script() {
    if [ ! -x "$SYNC_SCRIPT" ]; then
        echo -e "${RED}错误：同步脚本不存在或不可执行${NC}"
        echo "路径：$SYNC_SCRIPT"
        exit 1
    fi
}

# 主流程
print_header

echo -e "${YELLOW}欢迎使用海底龙宫快速启动向导！${NC}"
echo ""
echo "这个向导将帮助你："
echo "  1. 检查系统环境"
echo "  2. 配置工作区路径"
echo "  3. 预览同步内容"
echo "  4. 执行首次同步"
echo ""

read -p "按回车键继续..." -r
echo ""

# 步骤 1: 环境检查
print_step "1" "环境检查"

echo "检查 Git 安装..."
if command -v git &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Git 已安装：$(git --version)"
else
    echo -e "  ${RED}✗${NC} Git 未安装"
    echo ""
    echo "请先安装 Git:"
    echo "  macOS:  brew install git"
    echo "  Linux:  sudo apt install git"
    exit 1
fi

echo ""
echo "检查脚本权限..."
if [ -x "$SYNC_SCRIPT" ]; then
    echo -e "  ${GREEN}✓${NC} 脚本可执行"
else
    echo -e "  ${YELLOW}!${NC} 添加执行权限..."
    chmod +x "$SYNC_SCRIPT"
    echo -e "  ${GREEN}✓${NC} 权限已添加"
fi

read -p "按回车键继续..." -r

# 步骤 2: 配置工作区
print_step "2" "配置工作区路径"

echo "默认的 OpenClaw 工作区路径："
echo "  ~/Desktop/openclaw/Config"
echo ""
read -p "是否使用默认路径？(Y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    WORKSPACE_PATH="~/Desktop/openclaw/Config"
else
    read -p "请输入工作区路径：" WORKSPACE_PATH
fi

echo ""
echo "工作区路径：$WORKSPACE_PATH"
echo ""

# 检查路径是否存在
if [ ! -d "$WORKSPACE_PATH" ]; then
    echo -e "${RED}错误：目录不存在${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} 工作区目录存在"

read -p "按回车键继续..." -r

# 步骤 3: 预览变更
print_step "3" "预览同步内容"

echo "以下文件将被同步到 GitHub："
echo ""

"$SYNC_SCRIPT" -w "$WORKSPACE_PATH" -n -p

echo ""
read -p "确认要执行同步吗？(y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}已取消同步操作${NC}"
    exit 0
fi

# 步骤 4: 执行同步
print_step "4" "执行首次同步"

echo "开始同步到 GitHub..."
echo ""

"$SYNC_SCRIPT" -w "$WORKSPACE_PATH" -p

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ 同步完成！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "查看同步结果："
echo "  https://github.com/LceAn/openclaw-config"
echo ""
echo "后续使用："
echo "  ./openclaw-sync.sh -p          # 快速同步"
echo "  ./openclaw-sync.sh -s          # 查看状态"
echo "  ./openclaw-sync.sh -h          # 查看帮助"
echo ""
echo -e "${CYAN}感谢使用海底龙宫！🐉${NC}"
echo ""
