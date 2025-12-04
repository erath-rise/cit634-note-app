//
//  SettingsView.swift
//  MyNote
//
//  Created by YINGLIAN DENG on 15/11/2025.
//

import SwiftUI

/// 设置视图
struct SettingsView: View {
    @EnvironmentObject var viewModel: FormViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showClearAllAlert = false
    
    var body: some View {
        Form {
            // 外观设置
            Section {
                Toggle(isOn: $isDarkMode) {
                    Label("深色模式", systemImage: "moon.fill")
                }
                .tint(.blue)
            } header: {
                Text("外观设置")
            } footer: {
                Text("开启深色模式以保护您的眼睛")
            }
            
            // 数据管理
            Section {
                Button(role: .destructive) {
                    showClearAllAlert = true
                } label: {
                    Label("清除所有保存的数据", systemImage: "trash.fill")
                }
            } header: {
                Text("数据管理")
            } footer: {
                Text("此操作将删除所有本地保存的表单数据，且无法恢复")
            }
            
            // 应用信息
            Section {
                HStack {
                    Text("版本")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("开发者")
                    Spacer()
                    Text("MyNote Team")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("应用信息")
            }
        }
        .navigationTitle("⚙️ 设置")
        .navigationBarTitleDisplayMode(.large)
        .alert("确认清除", isPresented: $showClearAllAlert) {
            Button("取消", role: .cancel) { }
            Button("清除", role: .destructive) {
                viewModel.clearAllSavedData()
            }
        } message: {
            Text("确定要清除所有保存的数据吗？此操作无法撤销！")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(FormViewModel())
    }
}
