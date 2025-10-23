

## 📱 项目简介

这是一个基于SwiftUI开发的一个简洁的iOS带本地存储功能的基础表单应用，支持创建、编辑、管理多条内容，所有数据安全存储在本地。

### 核心特性

-  **文本编辑** - 支持多行文本输入，实时字数统计
-  **本地存储** - 使用UserDefaults安全存储数据
-  **多内容管理** - 保存多条内容，支持查看、编辑和删除
-  **时间记录** - 自动记录创建和修改时间
-  **自动暂存** - 输入内容自动保存，防止数据丢失
-  **多屏幕导航** - 主界面、列表、详情、设置、关于

### 主要界面
- **主编辑界面** - 创建新内容
- **内容列表** - 浏览所有已保存的内容
- **内容详情** - 查看和编辑单条内容
- **关于界面** - 应用信息和功能介绍

## 技术栈

- **开发语言**: Swift 5.0+
- **UI框架**: SwiftUI
- **架构模式**: MVVM (Model-View-ViewModel)
- **数据存储**: UserDefaults
- **开发工具**: Xcode
- **最低系统**: iOS 15.0+

## 项目结构

```
NoteApp/
├── Models/                           # 数据模型层
│   ├── Note.swift                   # 笔记数据结构
│   └── NoteManager.swift            # 数据管理和业务逻辑
├── Views/                            # 视图层
│   ├── ContentView.swift            # 主编辑界面
│   ├── NotesListView.swift          # 笔记列表界面
│   ├── NoteDetailView.swift         # 笔记详情界面
│   ├── SettingsView.swift           # 设置界面
│   └── AboutView.swift              # 关于界面
└── SimpleNoteAppApp.swift           # 应用入口
```

## 快速开始

### 环境要求

- macOS 12.0 或更高版本
- Xcode 14.0 或更高版本
- iOS 15.0+ 模拟器或真机

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/yourusername/SimpleNoteApp](https://github.com/erath-rise/cit634-note-app.git
   cd NoteApp
   ```

2. **打开项目**
   ```bash
   open NoteApp.xcodeproj
   ```
   或者直接双击 `NoteApp.xcodeproj` 文件

3. **选择目标设备**
   - 在Xcode顶部工具栏选择模拟器（推荐iPhone 15 Pro）
   - 或连接真机并选择你的设备

4. **运行应用**
   - 按 `Command + R` 快捷键
   - 或点击左上角的运行按钮

## 使用说明

### 创建文本内容

1. 在主界面的文本框中输入内容
2. 内容会自动暂存，不用担心丢失
3. 点击"保存"按钮保存
4. 保存成功后会有提示和触觉反馈

### 查看文本内容

1. 点击顶部的"查看全部"或右上角齿轮图标进入列表
2. 列表显示所有已保存的内容
3. 每条内容显示预览文本、时间和字数
4. 点击任意一条查看完整内容

### 编辑文本内容

1. 在详情页点击"编辑"按钮
2. 修改内容后点击"保存"
3. 修改时间会自动更新

### 删除文本内容

**删除单条：**
- 在列表中左滑，点击删除按钮
- 或在详情页点击底部的"删除"按钮

### 查看统计

在设置界面可以查看：
- 已保存数量
- 总字符数统计
- 数据存储位置

## 架构设计

### MVVM模式

应用采用MVVM架构模式，实现了清晰的职责分离：

**Model层 (数据模型)**
- `Note`: 定义note的数据结构
- 包含id、内容、创建时间、修改时间等属性
- 遵循Codable协议，支持JSON序列化

**ViewModel层 (数据管理)**
- `NoteManager`: 管理所有数据
- 处理增删改查操作
- 负责与UserDefaults交互
- 遵循ObservableObject，支持响应式更新

**View层 (用户界面)**
- 各个SwiftUI视图组件
- 只负责界面显示和用户交互
- 通过@EnvironmentObject访问NoteManager


## 数据存储

### UserDefaults

应用使用iOS系统提供的UserDefaults进行数据持久化：

- **存储位置**: `~/Library/Preferences/[Bundle ID].plist`
- **存储格式**: JSON (通过Codable序列化)
- **存储内容**: 数组、当前编辑文本

### 数据模型

```swift
struct Note: Identifiable, Codable {
    var id: UUID                // 唯一标识符
    var content: String         // 内容
    var createdAt: Date        // 创建时间
    var updatedAt: Date        // 修改时间
}
```

### 持久化策略

- 每次保存操作后立即同步到磁盘
- 应用启动时自动加载所有数据
- 输入内容实时暂存，防止意外丢失

## 核心功能实现

### 响应式更新

使用SwiftUI的响应式机制实现自动更新：

```swift
class NoteManager: ObservableObject {
    @Published var notes: [Note] = []
    // notes变化时，所有订阅的视图自动更新
}
```

### 数据序列化

使用Codable协议实现类型安全的序列化：

```swift
// 保存
let encoded = try? JSONEncoder().encode(notes)
UserDefaults.standard.set(encoded, forKey: "savedNotes")

// 读取
let data = UserDefaults.standard.data(forKey: "savedNotes")
let notes = try? JSONDecoder().decode([Note].self, from: data)
```

### 自动暂存

监听文本变化，实时保存到临时存储：

```swift
TextEditor(text: $noteText)
    .onChange(of: noteText) { oldValue, newValue in
        noteManager.saveCurrentText(newValue)
    }
```

## 打包和分发

### 模拟器测试

1. 在Xcode中选择任意iOS模拟器
2. 运行应用进行测试
3. 录制屏幕演示视频（Command + Shift + 5）

### 真机调试

1. 连接iPhone到Mac
2. 在Xcode中选择你的设备
3. 信任开发证书
4. 运行应用

### 生成IPA（需要开发者账号）

1. 选择 **Product → Archive**
2. 等待编译完成
3. 在Organizer中选择Archive
4. 点击 **Distribute App**
5. 选择导出方式（Development/Ad Hoc）
6. 导出IPA文件

