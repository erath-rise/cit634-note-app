//
//  ContentView.swift
//  NoteApp
//
//  Created by Yinglian Deng on 20/10/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var noteManager = NoteManager()
    @State private var noteText: String = ""
    @State private var showingSaveAlert = false
    @State private var showingSettings = false
    @State private var showingNotesList = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                VStack(spacing: 25) {
                    // 顶部标题卡片
                    VStack(spacing: 8) {
                        HStack(spacing: 15) {
                            Text("已保存 \(noteManager.notes.count) 条内容")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if noteManager.notes.count > 0 {
                                Button(action: { showingNotesList = true }) {
                                    HStack(spacing: 4) {
                                        Text("查看全部")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    // 文本编辑器
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                            Text("新建内容")
                                .font(.headline)
                            
                            Spacer()
                            
                            if !noteText.isEmpty {
                                Button(action: clearText) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "xmark.circle.fill")
                                        Text("清空")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            }
                        }
                        
                        TextEditor(text: $noteText)
                            .frame(height: 200)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                            .onChange(of: noteText) { oldValue, newValue in
                                // 自动保存当前输入
                                noteManager.saveCurrentText(newValue)
                            }
                        
                        HStack {
                            Text("字数: \(noteText.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if !noteText.isEmpty {
                                Text("输入内容会自动暂存")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // 保存按钮
                    Button(action: saveNote) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                            Text("保存")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            noteText.isEmpty ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray, Color.gray]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: noteText.isEmpty ? 0 : 5)
                    }
                    .disabled(noteText.isEmpty)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(noteManager)
            }
            .sheet(isPresented: $showingNotesList) {
                NotesListView()
                    .environmentObject(noteManager)
            }
            .alert("保存成功", isPresented: $showingSaveAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text("笔记已保存到列表中")
            }
            .onAppear {
                loadCurrentText()
            }
        }
    }
    
    private func saveNote() {
        guard !noteText.isEmpty else { return }
        
        noteManager.saveNewNote(noteText)
        showingSaveAlert = true
        
        // 清空输入框
        noteText = ""
        noteManager.clearCurrentText()
        
        // 添加触觉反馈
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func loadCurrentText() {
        noteText = noteManager.loadCurrentText()
    }
    
    private func clearText() {
        noteText = ""
        noteManager.clearCurrentText()
    }
}

#Preview {
    ContentView()
}
