#!/bin/bash
# =============================================================================
# 海底龙宫 (openclaw-sync) - OpenClaw 配置同步工具
# =============================================================================
# 版本：1.0.0
# 作者：LceAn
# 许可：MIT
# 仓库：https://github.com/LceAn/openclaw-sync
#
# 功能：
#   智能同步 OpenClaw 工作区配置到 GitHub 仓库
#
# 用法：
#   ./openclaw-sync.sh [选项]
#
# 选项：
#   -p, --push        推送到 GitHub
#   -f, --pull        先从远程拉取更新
#   -n, --dry-run     预览模式
#   -s, --status      仅显示状态
#   -v, --verbose     详细输出
#   -c, --config      指定配置文件
#   -w, --workspace   指定工作区路径
#   -h, --help        显示帮助
#
# 示例：
#   ./openclaw-sync.sh -p              # 提交并推送
#   ./openclaw-sync.sh -fp             # 拉取 + 提交 + 推送
#   ./openclaw-sync.sh -n -p           # 预览推送
#   ./openclaw-sync.sh -w ~/my-config  # 指定工作区
# =============================================================================

set -e

# =============================================================================
# 版本信息
# =============================================================================
readonly VERSION="1.0.0"
readonly TOOL_NAME="海底龙宫"
readonly REPO_URL="https://github.com/LceAn/openclaw-sync"

# =============================================================================
# 默认配置
# =============================================================================
DEFAULT_GITHUB_REPO="LceAn/openclaw-config"
DEFAULT_GITHUB_BRANCH="main"
DEFAULT_WORKSPACE="./Config"
DEFAULT_GIT_USER_NAME="OpenClaw Sync Bot"
DEFAULT_GIT_USER_EMAIL="openclaw-sync@local"

# =============================================================================
# 全局变量
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR=""
GITHUB_REPO=""
GITHUB_BRANCH=""
GIT_USER_NAME=""
GIT_USER_EMAIL=""
CONFIG_FILE=""

# 标志位
DO_PUSH=false
DO_PULL=false
DRY_RUN=false
STATUS_ONLY=false
VERBOSE=false

# 日志文件
LOG_DIR=""
LOG_FILE=""

# =============================================================================
# 颜色定义
# =============================================================================
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    MAGENTA='\033[0;35m'
    WHITE='\033[0;37m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    MAGENTA=''
    WHITE=''
    BOLD=''
    NC=''
fi

# =============================================================================
# 日志函数
# =============================================================================

log() {
    local level="$1"
    local color="$2"
    shift 2
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # 输出到终端
    echo -e "[$timestamp] [${color}${level}${NC}] $message"
    
    # 输出到日志文件
    if [[ -n "$LOG_FILE" ]]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    fi
}

info() { log "INFO" "$CYAN" "$@"; }
success() { log "SUCCESS" "$GREEN" "$@"; }
warn() { log "WARN" "$YELLOW" "$@"; }
error() { log "ERROR" "$RED" "$@"; }
debug() {
    if [[ "$VERBOSE" == true ]]; then
        log "DEBUG" "$MAGENTA" "$@"
    fi
}

print_header() {
    local text="$1"
    local width=50
    local line=$(printf '=%.0s' $(seq 1 $width))
    
    echo -e "${CYAN}${line}${NC}"
    echo -e "${CYAN}${BOLD}$text${NC}"
    echo -e "${CYAN}${line}${NC}"
}

print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║                                              ║"
    echo "║          🐉  海底龙宫 (openclaw-sync)        ║"
    echo "║                                              ║"
    echo "║              OpenClaw 同步工具 v${VERSION}           ║"
    echo "║                                              ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# =============================================================================
# 工具函数
# =============================================================================

cleanup() {
    debug "清理临时资源..."
    # 可以在这里添加清理逻辑
}

trap cleanup EXIT

init_log() {
    local workspace_name=$(basename "$WORKSPACE_DIR")
    LOG_DIR="$SCRIPT_DIR/logs"
    mkdir -p "$LOG_DIR"
    LOG_FILE="$LOG_DIR/sync-${workspace_name}-$(date +%Y%m%d_%H%M%S).log"
    touch "$LOG_FILE"
    debug "日志文件：$LOG_FILE"
}

# =============================================================================
# 配置加载
# =============================================================================

load_config() {
    debug "加载配置..."
    
    # 默认配置
    WORKSPACE_DIR="${WORKSPACE_DIR:-$DEFAULT_WORKSPACE}"
    GITHUB_REPO="${GITHUB_REPO:-$DEFAULT_GITHUB_REPO}"
    GITHUB_BRANCH="${GITHUB_BRANCH:-$DEFAULT_GITHUB_BRANCH}"
    GIT_USER_NAME="${GIT_USER_NAME:-$DEFAULT_GIT_USER_NAME}"
    GIT_USER_EMAIL="${GIT_USER_EMAIL:-$DEFAULT_GIT_USER_EMAIL}"
    
    # 从配置文件加载（如果指定）
    if [[ -n "$CONFIG_FILE" && -f "$CONFIG_FILE" ]]; then
        debug "从配置文件加载：$CONFIG_FILE"
        # 这里可以解析 JSON 配置文件
        # 暂时简化处理
    fi
    
    # 从环境变量加载（优先级最高）
    WORKSPACE_DIR="${OPENCLAW_SYNC_WORKSPACE:-$WORKSPACE_DIR}"
    GITHUB_REPO="${OPENCLAW_SYNC_REPO:-$GITHUB_REPO}"
    GITHUB_BRANCH="${OPENCLAW_SYNC_BRANCH:-$GITHUB_BRANCH}"
    
    debug "工作区：$WORKSPACE_DIR"
    debug "GitHub 仓库：$GITHUB_REPO"
    debug "分支：$GITHUB_BRANCH"
}

# =============================================================================
# 参数解析
# =============================================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--push)
                DO_PUSH=true
                shift
                ;;
            -f|--pull)
                DO_PULL=true
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -s|--status)
                STATUS_ONLY=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -w|--workspace)
                WORKSPACE_DIR="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -V|--version)
                echo "海底龙宫 (openclaw-sync) v$VERSION"
                exit 0
                ;;
            *)
                error "未知参数：$1"
                echo "使用 -h 或 --help 查看帮助"
                exit 1
                ;;
        esac
    done
}

show_help() {
    cat << EOF
${BOLD}海底龙宫 (openclaw-sync) v${VERSION}${NC}

${BOLD}用法:${NC}
  $0 [选项]

${BOLD}选项:${NC}
  -p, --push        推送到 GitHub 仓库
  -f, --pull        先从远程拉取更新（双向同步）
  -n, --dry-run     预览模式，不执行实际操作
  -s, --status      仅显示同步状态
  -v, --verbose     详细输出模式
  -c, --config      指定配置文件路径
  -w, --workspace   指定工作区路径
  -h, --help        显示此帮助信息
  -V, --version     显示版本号

${BOLD}示例:${NC}
  $0 -p                         # 提交并推送
  $0 -fp                        # 拉取 + 提交 + 推送
  $0 -n -p                      # 预览推送操作
  $0 -w ~/my-config -p          # 指定工作区并推送
  $0 -c ~/.config.json -p       # 使用配置文件

${BOLD}环境变量:${NC}
  OPENCLAW_SYNC_WORKSPACE       工作区路径
  OPENCLAW_SYNC_REPO            GitHub 仓库（格式：user/repo）
  OPENCLAW_SYNC_BRANCH          分支名称（默认：main）

${BOLD}配置示例:${NC}
  {
    "github": {
      "repo": "your-username/openclaw-config",
      "branch": "main"
    },
    "workspace": {
      "path": "~/Desktop/openclaw/Config",
      "exclude": [".openclaw/", "*.log"]
    }
  }

${BOLD}仓库:${NC}
  $REPO_URL

EOF
}

# =============================================================================
# 前置检查
# =============================================================================

check_prerequisites() {
    print_header "前置检查"
    
    local has_error=false
    
    # 检查 Git
    if ! command -v git &> /dev/null; then
        error "Git 未安装，请先安装 Git"
        has_error=true
    else
        success "Git 已安装：$(git --version)"
    fi
    
    # 检查工作区目录
    if [[ ! -d "$WORKSPACE_DIR" ]]; then
        error "工作区目录不存在：$WORKSPACE_DIR"
        has_error=true
    else
        success "工作区目录存在：$(realpath "$WORKSPACE_DIR")"
    fi
    
    # 检查 GitHub 连接
    if ! git ls-remote "https://github.com/$GITHUB_REPO.git" &> /dev/null; then
        warn "无法访问 GitHub 仓库：$GITHUB_REPO"
        if [[ "$DO_PULL" == true || "$DO_PUSH" == true ]]; then
            error "需要 GitHub 认证才能执行拉取/推送操作"
            has_error=true
        fi
    else
        success "GitHub 仓库可访问：$GITHUB_REPO"
    fi
    
    if [[ "$has_error" == true ]]; then
        error "前置检查失败"
        exit 1
    fi
}

# =============================================================================
# 状态检查
# =============================================================================

check_status() {
    print_header "同步状态检查"
    
    cd "$WORKSPACE_DIR"
    
    # 检查是否是 Git 仓库
    if [[ ! -d ".git" ]]; then
        warn "工作区目录不是 Git 仓库"
        info "文件列表："
        ls -la
        return
    fi
    
    # Git 状态
    echo -e "\n${BLUE}${BOLD}=== Git 状态 ===${NC}"
    git status --short
    
    # 提交历史
    echo -e "\n${BLUE}${BOLD}=== 最近提交 ===${NC}"
    git log --oneline -5
    
    # 远程信息
    echo -e "\n${BLUE}${BOLD}=== 远程仓库 ===${NC}"
    git remote -v
    
    # 与远程的差异
    echo -e "\n${BLUE}${BOLD}=== 与远程差异 ===${NC}"
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    if git rev-parse --verify "origin/$current_branch" &> /dev/null; then
        local ahead=$(git rev-list --count "HEAD..origin/$current_branch" 2>/dev/null || echo "0")
        local behind=$(git rev-list --count "origin/$current_branch..HEAD" 2>/dev/null || echo "0")
        
        if [[ "$ahead" != "0" || "$behind" != "0" ]]; then
            info "本地领先远程：$behind 个提交"
            info "远程领先本地：$ahead 个提交"
        else
            success "本地与远程同步"
        fi
    else
        warn "远程分支不存在"
    fi
}

# =============================================================================
# 预览变更
# =============================================================================

preview_changes() {
    print_header "预览变更"
    
    cd "$WORKSPACE_DIR"
    
    echo -e "\n${YELLOW}${BOLD}=== 将要同步的变更 ===${NC}"
    
    local has_changes=false
    
    # 未跟踪的文件
    local untracked=$(git ls-files --others --exclude-standard)
    if [[ -n "$untracked" ]]; then
        echo -e "\n${BLUE}新文件（将添加）:${NC}"
        echo "$untracked" | sed 's/^/  + /'
        has_changes=true
    fi
    
    # 修改的文件
    local modified=$(git diff --name-only)
    if [[ -n "$modified" ]]; then
        echo -e "\n${BLUE}修改的文件:${NC}"
        echo "$modified" | sed 's/^/  ~ /'
        has_changes=true
    fi
    
    # 删除的文件
    local deleted=$(git diff --name-only --diff-filter=D)
    if [[ -n "$deleted" ]]; then
        echo -e "\n${BLUE}删除的文件:${NC}"
        echo "$deleted" | sed 's/^/  - /'
        has_changes=true
    fi
    
    if [[ "$has_changes" == false ]]; then
        success "没有变更需要同步"
    else
        info "\n如果执行同步，将提交上述变更到：$GITHUB_REPO"
    fi
}

# =============================================================================
# 执行同步
# =============================================================================

execute_sync() {
    cd "$WORKSPACE_DIR"
    
    # 步骤 1: 拉取远程更新
    if [[ "$DO_PULL" == true ]]; then
        print_header "步骤 1: 拉取远程更新"
        
        if [[ "$DRY_RUN" == true ]]; then
            info "[预览] git pull origin $GITHUB_BRANCH --rebase"
        else
            if git pull origin "$GITHUB_BRANCH" --rebase; then
                success "拉取成功"
            else
                warn "拉取失败，可能存在冲突"
            fi
        fi
    fi
    
    # 步骤 2: 添加变更
    print_header "步骤 2: 添加变更"
    
    local changes=$(git status --porcelain)
    if [[ -z "$changes" ]]; then
        success "没有变更，跳过提交"
        return
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        info "[预览] git add ."
        info "[预览] 变更内容："
        echo "$changes" | sed 's/^/  /'
    else
        git add .
        local change_count=$(echo "$changes" | wc -l | tr -d ' ')
        info "已添加 $change_count 个变更"
    fi
    
    # 步骤 3: 提交变更
    print_header "步骤 3: 提交变更"
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local commit_msg="🐉 Auto-sync: $timestamp"
    
    if [[ "$DRY_RUN" == true ]]; then
        info "[预览] git commit -m \"$commit_msg\""
    else
        if git commit -m "$commit_msg"; then
            success "提交成功"
        else
            warn "提交失败，可能没有变更"
            return
        fi
    fi
    
    # 步骤 4: 推送
    if [[ "$DO_PUSH" == true ]]; then
        print_header "步骤 4: 推送到 GitHub"
        
        if [[ "$DRY_RUN" == true ]]; then
            info "[预览] git push origin $GITHUB_BRANCH"
        else
            if git push origin "$GITHUB_BRANCH"; then
                success "推送成功到 $GITHUB_REPO"
                info "查看：https://github.com/$GITHUB_REPO"
            else
                error "推送失败，请检查网络和认证"
                exit 1
            fi
        fi
    fi
    
    # 完成
    print_header "同步完成"
    success "🐉 海底龙宫 - OpenClaw 配置已同步"
    if [[ -n "$LOG_FILE" ]]; then
        info "日志：$LOG_FILE"
    fi
}

# =============================================================================
# 主流程
# =============================================================================

main() {
    parse_args "$@"
    load_config
    init_log
    
    print_banner
    
    check_prerequisites
    
    # 选择执行模式
    if [[ "$STATUS_ONLY" == true ]]; then
        check_status
    elif [[ "$DRY_RUN" == true ]]; then
        info "${YELLOW}🔍 预览模式 - 不会执行实际同步${NC}"
        preview_changes
    else
        execute_sync
    fi
    
    echo ""
    info "同步会话结束"
}

# 执行主流程
main "$@"
