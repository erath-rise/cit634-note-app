//
//  NoteDetailView.swift
//  NoteApp
//
//  Created by Yinglian Deng on 20/10/2025.
//

import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var noteManager: NoteManager
    
    let note: Note
    @State private var showingDeleteAlert = false
    @State private var isEditing = false
    @State private var editedContent: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 信息卡片
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                                Text("创建时间")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(note.formattedDate)
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "textformat.size")
                                    .foregroundColor(.blue)
                                Text("字数统计")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(note.content.count) 字符")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "number")
                                    .foregroundColor(.blue)
                                Text("ID")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(note.id.uuidString.prefix(8) + "...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        
                        // 内容区域
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("内容")
                                    .font(.headline)
                                Spacer()
                                if isEditing {
                                    Button("保存") {
                                        saveEdits()
                                    }
                                    .foregroundColor(.blue)
                                    .fontWeight(.semibold)
                                } else {
                                    Button(action: { startEditing() }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "pencil")
                                            Text("编辑")
                                        }
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                    }
                                }
                            }
                            
                            if isEditing {
                                TextEditor(text: $editedContent)
                                    .frame(minHeight: 300)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            } else {
                                Text(note.content)
                                    .font(.body)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // 删除按钮
                        Button(action: { showingDeleteAlert = true }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("删除")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
            .alert("确认删除", isPresented: $showingDeleteAlert) {
                Button("取消", role: .cancel) { }
                Button("删除", role: .destructive) {
                    noteManager.deleteNote(note)
                    dismiss()
                }
            } message: {
                Text("删除后无法恢复")
            }
        }
    }
    
    private func startEditing() {
        isEditing = true
        editedContent = note.content
    }
    
    private func saveEdits() {
        noteManager.updateNote(note, with: editedContent)
        isEditing = false
        
        // 触觉反馈
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    NoteDetailView(note: Note(content: "这是一条测试，用于预览界面效果。"))
        .environmentObject(NoteManager())
}
