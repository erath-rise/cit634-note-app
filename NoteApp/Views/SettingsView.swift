//
//  SettingsView.swift
//  NoteApp
//
//  Created by Yinglian Deng on 20/10/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var noteManager: NoteManager
    @State private var showingClearAlert = false
    @State private var showingStoragePath = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                List {
                    // 数据统计
                    Section(header: Text("数据统计")) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text("已保存笔记")
                            Spacer()
                            Text("\(noteManager.notes.count) 条")
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: { showingStoragePath = true }) {
                            HStack {
                                Image(systemName: "folder")
                                    .foregroundColor(.orange)
                                    .frame(width: 30)
                                Text("存储位置")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    // 数据管理
                    Section(header: Text("数据管理")) {
                        Button(action: { showingClearAlert = true }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                    .frame(width: 30)
                                Text("清除所有数据")
                                    .foregroundColor(.red)
                            }
                        }
                        .disabled(noteManager.notes.isEmpty)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
            .alert("存储位置", isPresented: $showingStoragePath) {
                Button("确定", role: .cancel) { }
            } message: {
                Text("数据存储在 UserDefaults 中：\n\n\(noteManager.getStoragePath())/Preferences/\n\n所有笔记以JSON格式保存")
            }
            .alert("确认清除", isPresented: $showingClearAlert) {
                Button("取消", role: .cancel) { }
                Button("清除", role: .destructive) {
                    noteManager.clearAllNotes()
                }
            } message: {
                Text("这将删除所有 \(noteManager.notes.count) 条笔记，此操作无法撤销。")
            }
        }
    }
    
    private var totalCharacters: Int {
        noteManager.notes.reduce(0) { $0 + $1.content.count }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            Text(text)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SettingsView()
        .environmentObject(NoteManager())
};
