# 🐉 海底龙宫 GUI - 综合设计方案

> 基于 openclaw-manager 架构 + 同步工具特性

---

## 🎯 项目定位

**海底龙宫 GUI** = **openclaw-manager 架构** × **同步工具特性**

- 🎯 **专注领域：** OpenClaw 配置同步到 GitHub
- 🛠️ **技术栈：** Tauri 2.0 + React + TypeScript + Rust
- 🎨 **设计理念：** 简洁、现代、高效
- 📦 **目标平台：** macOS / Windows / Linux

---

## 🏗️ 项目结构（最终版）

```
openclaw-sync-gui/
├── 📁 src-tauri/                    # Rust 后端
│   ├── 📁 src/
│   │   ├── main.rs                  # 应用入口
│   │   ├── 📁 commands/             # Tauri 命令
│   │   │   ├── sync.rs              # 同步操作
│   │   │   ├── git.rs               # Git 操作
│   │   │   ├── workspace.rs         # 工作区管理
│   │   │   └── config.rs            # 配置管理
│   │   ├── 📁 models/               # 数据模型
│   │   │   ├── sync_result.rs
│   │   │   └── workspace.rs
│   │   └── 📁 utils/                # 工具函数
│   ├── Cargo.toml                   # Rust 依赖
│   └── tauri.conf.json              # Tauri 配置
│
├── 📁 src/                          # React 前端
│   ├── 📁 components/
│   │   ├── 📁 Layout/               # 布局组件
│   │   │   ├── AppLayout.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   └── Header.tsx
│   │   ├── 📁 Dashboard/            # 仪表盘
│   │   │   ├── WorkspaceCard.tsx
│   │   │   ├── SyncStatus.tsx
│   │   │   └── QuickActions.tsx
│   │   ├── 📁 Sync/                 # 同步功能
│   │   │   ├── ChangePreview.tsx
│   │   │   ├── SyncButton.tsx
│   │   │   └── SyncProgress.tsx
│   │   ├── 📁 History/              # 同步历史
│   │   │   ├── Timeline.tsx
│   │   │   └── RecordDetail.tsx
│   │   └── 📁 Settings/             # 设置
│   │       ├── GitHubConfig.tsx
│   │       ├── ExcludeRules.tsx
│   │       └── AutoSync.tsx
│   ├── 📁 pages/
│   │   ├── Home.tsx
│   │   ├── History.tsx
│   │   └── Settings.tsx
│   ├── 📁 store/                    # 状态管理 (Zustand)
│   │   ├── syncStore.ts
│   │   └── configStore.ts
│   ├── 📁 hooks/                    # 自定义 Hooks
│   │   ├── useSync.ts
│   │   └── useWorkspace.ts
│   ├── 📁 utils/                    # 工具函数
│   ├── 📁 styles/                   # 全局样式
│   │   └── globals.css
│   ├── App.tsx
│   └── main.tsx
│
├── 📁 public/                       # 静态资源
│   ├── 📁 icons/                    # 应用图标
│   │   ├── icon.icns                # macOS
│   │   ├── icon.ico                 # Windows
│   │   └── icon.png                 # Linux
│   └── 📁 images/
│
├── 📄 package.json                  # 前端依赖
├── 📄 vite.config.ts                # Vite 配置
├── 📄 tailwind.config.js            # Tailwind 配置
├── 📄 tsconfig.json                 # TypeScript 配置
├── 📄 README.md                     # 项目说明
└── 📄 LICENSE                       # MIT 许可证
```

---

## 🎨 UI 设计

### 主界面布局

```
┌─────────────────────────────────────────────────────────────┐
│  🐉 海底龙宫                                  [-][□][×]     │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│  侧边栏   │              主内容区域                           │
│          │                                                  │
│  🏠 首页  │  ┌────────────────────────────────────────┐    │
│  📜 历史  │  │  工作区状态                              │    │
│  ⚙️ 设置  │  │  ~/Desktop/openclaw/Config              │    │
│          │  │  最后同步：5 分钟前                        │    │
│          │  │  GitHub: LceAn/openclaw-config           │    │
│          │  └────────────────────────────────────────┘    │
│          │                                                  │
│          │  ┌────────────────────────────────────────┐    │
│          │  │  待同步变更 (3)                          │    │
│          │  │  + MEMORY.md                           │    │
│          │  │  ~ AGENTS.md                           │    │
│          │  │  ~ TODO.md                             │    │
│          │  └────────────────────────────────────────┘    │
│          │                                                  │
│          │  ┌────────────────────────────────────────┐    │
│          │  │  最近同步记录                            │    │
│          │  │  🕐 15:30  ✅ 成功 (3 文件)              │    │
│          │  │  🕐 昨天    ✅ 成功 (5 文件)              │    │
│          │  └────────────────────────────────────────┘    │
│          │                                                  │
│          │         [👁️ 预览] [🔄 同步] [⬆️ 推送]            │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

---

### 配色方案

```css
/* 主色调 - 海洋蓝 */
--primary: #0077BE;
--primary-hover: #005F99;
--primary-light: #3399CC;

/* 强调色 - 龙宫金 */
--accent: #FFD700;
--accent-hover: #E6C200;

/* 背景色 - 深色模式 */
--bg-dark: #1A1A2E;
--bg-card: #16213E;
--bg-hover: #1F2940;

/* 背景色 - 浅色模式 */
--bg-light: #F8F9FA;
--bg-white: #FFFFFF;

/* 文字色 */
--text-primary: #FFFFFF;
--text-secondary: #A0AEC0;
--text-dark: #1A202C;

/* 状态色 */
--success: #10B981;
--warning: #F59E0B;
--error: #EF4444;
--info: #3B82F6;
```

---

## 🔧 核心功能实现

### 1. Rust 后端命令

```rust
// src-tauri/src/commands/sync.rs

use tauri::command;
use std::process::Command;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct SyncResult {
    pub success: bool,
    pub message: String,
    pub changed_files: Vec<String>,
    pub timestamp: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct GitStatus {
    pub untracked: Vec<String>,
    pub modified: Vec<String>,
    pub deleted: Vec<String>,
}

/// 同步工作区
#[command]
pub async fn sync_workspace(
    path: String,
    push: bool,
    pull: bool,
) -> Result<SyncResult, String> {
    let sync_script = "/path/to/openclaw-sync.sh";
    
    let mut cmd = Command::new("bash");
    cmd.arg(sync_script);
    cmd.arg("-w").arg(&path);
    
    if pull {
        cmd.arg("-f");
    }
    if push {
        cmd.arg("-p");
    }
    
    let output = cmd.output()
        .map_err(|e| format!("执行失败：{}", e))?;
    
    if output.status.success() {
        let stdout = String::from_utf8_lossy(&output.stdout);
        Ok(SyncResult {
            success: true,
            message: stdout.to_string(),
            changed_files: parse_changed_files(&stdout),
            timestamp: chrono::Local::now().format("%Y-%m-%d %H:%M:%S").to_string(),
        })
    } else {
        Err(String::from_utf8_lossy(&output.stderr).to_string())
    }
}

/// 检查 Git 状态
#[command]
pub async fn check_git_status(path: String) -> Result<GitStatus, String> {
    let mut cmd = Command::new("git");
    cmd.arg("status").arg("--porcelain");
    cmd.current_dir(&path);
    
    let output = cmd.output()
        .map_err(|e| e.to_string())?;
    
    let stdout = String::from_utf8_lossy(&output.stdout);
    parse_git_status(&stdout)
}

/// 获取同步历史
#[command]
pub async fn get_sync_history(path: String) -> Result<Vec<SyncResult>, String> {
    // 从日志文件读取历史
    let log_dir = format!("{}/logs", path);
    // 解析日志文件...
    Ok(vec![])
}
```

---

### 2. React 前端组件

```typescript
// src/components/Dashboard/WorkspaceCard.tsx

import { useState } from 'react';
import { invoke } from '@tauri-apps/api/tauri';
import { useSyncStore } from '../../store/syncStore';

interface WorkspaceCardProps {
  path: string;
  name: string;
}

export function WorkspaceCard({ path, name }: WorkspaceCardProps) {
  const [syncing, setSyncing] = useState(false);
  const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle');
  const { addSyncRecord } = useSyncStore();

  const handleSync = async () => {
    setSyncing(true);
    try {
      const result = await invoke<SyncResult>('sync_workspace', {
        path,
        push: true,
        pull: false,
      });
      
      addSyncRecord({
        workspace: name,
        timestamp: new Date(),
        success: result.success,
        files: result.changed_files,
      });
      
      setStatus('success');
      setTimeout(() => setStatus('idle'), 3000);
    } catch (error) {
      setStatus('error');
      console.error('同步失败:', error);
    } finally {
      setSyncing(false);
    }
  };

  return (
    <div className="bg-card rounded-lg p-6 shadow-lg">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-semibold text-white">{name}</h3>
        <span className="text-sm text-gray-400">{path}</span>
      </div>
      
      <div className="space-y-2 mb-4">
        <div className="flex justify-between text-sm">
          <span className="text-gray-400">最后同步:</span>
          <span className="text-gray-300">5 分钟前</span>
        </div>
        <div className="flex justify-between text-sm">
          <span className="text-gray-400">GitHub:</span>
          <span className="text-gray-300">LceAn/openclaw-config</span>
        </div>
      </div>
      
      <button
        onClick={handleSync}
        disabled={syncing}
        className={`
          w-full py-2 px-4 rounded-lg font-medium
          transition-all duration-200
          ${syncing 
            ? 'bg-gray-600 cursor-not-allowed' 
            : status === 'success'
            ? 'bg-green-600 hover:bg-green-700'
            : status === 'error'
            ? 'bg-red-600 hover:bg-red-700'
            : 'bg-primary hover:bg-primary-hover'
          }
        `}
      >
        {syncing ? '同步中...' : status === 'success' ? '✅ 成功' : '🔄 立即同步'}
      </button>
    </div>
  );
}
```

---

### 3. 状态管理 (Zustand)

```typescript
// src/store/syncStore.ts

import { create } from 'zustand';

interface SyncRecord {
  workspace: string;
  timestamp: Date;
  success: boolean;
  files: string[];
}

interface SyncState {
  // 数据
  workspaces: string[];
  currentWorkspace: string | null;
  lastSyncTime: Date | null;
  syncHistory: SyncRecord[];
  
  // 操作
  addWorkspace: (path: string) => void;
  removeWorkspace: (path: string) => void;
  setCurrentWorkspace: (path: string) => void;
  addSyncRecord: (record: SyncRecord) => void;
  clearHistory: () => void;
}

export const useSyncStore = create<SyncState>((set) => ({
  // 初始状态
  workspaces: [],
  currentWorkspace: null,
  lastSyncTime: null,
  syncHistory: [],
  
  // Actions
  addWorkspace: (path) => set((state) => ({
    workspaces: [...state.workspaces, path]
  })),
  
  removeWorkspace: (path) => set((state) => ({
    workspaces: state.workspaces.filter(p => p !== path)
  })),
  
  setCurrentWorkspace: (path) => set({ currentWorkspace: path }),
  
  addSyncRecord: (record) => set((state) => ({
    syncHistory: [record, ...state.syncHistory],
    lastSyncTime: new Date()
  })),
  
  clearHistory: () => set({ syncHistory: [] })
}));
```

---

## 📋 开发里程碑

### Week 1: 项目初始化
- [x] 技术选型（Tauri + React + TS）
- [ ] 创建 GitHub 仓库
- [ ] 项目初始化（`npm create tauri-app`）
- [ ] 基础布局组件
- [ ] 路由配置

### Week 2-3: 核心功能
- [ ] Rust 后端命令（sync、git、config）
- [ ] 工作区管理界面
- [ ] 同步配置界面
- [ ] 调用 shell 脚本同步
- [ ] 状态显示

### Week 4-5: 完善优化
- [ ] 同步历史时间线
- [ ] 设置界面（GitHub、排除规则）
- [ ] 通知系统
- [ ] 深色模式
- [ ] 错误处理

### Week 6-7: 测试发布
- [ ] Beta 测试
- [ ] Bug 修复
- [ ] 文档完善
- [ ] 正式发布 v1.0

---

## 🚀 快速启动

### 1. 环境准备

```bash
# 安装 Node.js 18+
# https://nodejs.org/

# 安装 Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 验证
node -v
rustc --version
```

### 2. 创建项目

```bash
# 使用 npm 创建 Tauri 项目
npm create tauri-app@latest openclaw-sync-gui
# 选择：react-ts 模板

cd openclaw-sync-gui

# 安装依赖
npm install

# 安装额外依赖
npm install zustand framer-motion lucide-react
npm install -D @tauri-apps/cli
```

### 3. 运行开发

```bash
# 开发模式（热重载）
npm run tauri:dev

# 仅运行前端
npm run dev

# 构建发布版本
npm run tauri:build
```

---

## 📊 与 openclaw-manager 对比

| 维度 | openclaw-manager | 海底龙宫 GUI |
|------|------------------|-------------|
| **定位** | OpenClaw 服务管理 | 配置同步工具 |
| **核心功能** | 服务启停、AI 配置、渠道管理 | Git 同步、版本管理、备份 |
| **后端操作** | 进程管理、API 调用 | Git 操作、文件同步 |
| **用户场景** | 日常使用 OpenClaw | 定期同步配置 |
| **界面重点** | 仪表盘、实时监控 | 变更预览、历史记录 |
| **技术栈** | Tauri 2.0 + React + TS | Tauri 2.0 + React + TS ✅ |
| **项目结构** | 模块化清晰 ✅ | 借鉴相同结构 ✅ |
| **UI 设计** | 暗色主题、现代感 | 暗色主题、海洋风格 |

---

## 🎯 差异化特色

### 1. 专注同步
- 不做服务管理
- 专注 Git 同步功能
- 极致的同步体验

### 2. 海洋主题
- 海洋蓝主色调
- 龙宫金强调色
- 流动动画效果

### 3. 智能预览
- 变更文件高亮
- Diff 对比查看
- 选择性同步

### 4. 历史追溯
- 时间线展示
- 版本对比
- 一键回滚

---

## 📝 下一步行动

### 立即执行（今天）
1. ✅ 完成综合设计方案
2. ⏳ 创建 GitHub 仓库 `openclaw-sync-gui`
3. ⏳ 初始化项目
4. ⏳ 设计 UI 原型（Figma）

### 本周完成
1. 基础框架搭建
2. 核心组件开发
3. Rust 命令实现

### 两周内完成
1. MVP 版本
2. 内部测试
3. 反馈收集

---

<div align="center">

**🐉 海底龙宫 GUI - 站在巨人肩膀上创新！**

*设计完成时间：2026-03-08*  
*参考架构：openclaw-manager (930⭐)*  
*技术栈：Tauri 2.0 + React + TypeScript + Rust*  
*预计周期：7 周*

</div>
