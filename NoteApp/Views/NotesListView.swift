//
//  NotesListView.swift
//  NoteApp
//
//  Created by Yinglian Deng on 20/10/2025.
//

import SwiftUI

struct NotesListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var noteManager: NoteManager
    @State private var selectedNote: Note?
    @State private var showingDeleteAlert = false
    @State private var noteToDelete: Note?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if noteManager.notes.isEmpty {
                    // 空状态
                    VStack(spacing: 20) {
                        Text("还没有保存的内容")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("在主界面创建并保存内容后\n就可以在这里查看啦")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(noteManager.notes) { note in
                            Button(action: {
                                selectedNote = note
                            }) {
                                NoteRowView(note: note)
                            }
                            .listRowBackground(Color.white)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    noteToDelete = note
                                    showingDeleteAlert = true
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("已保存内容 (\(noteManager.notes.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note)
                    .environmentObject(noteManager)
            }
            .alert("确认删除", isPresented: $showingDeleteAlert) {
                Button("取消", role: .cancel) { }
                Button("删除", role: .destructive) {
                    if let note = noteToDelete {
                        withAnimation {
                            noteManager.deleteNote(note)
                        }
                    }
                }
            } message: {
                Text("删除后无法恢复")
            }
        }
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        HStack(spacing: 15) {
            // 左侧图标
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.white)
                    .font(.title3)
            }
            
            // 内容
            VStack(alignment: .leading, spacing: 5) {
                Text(note.preview)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack(spacing: 10) {
                    Label(note.formattedDate, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(note.content.count) 字")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NotesListView()
        .environmentObject(NoteManager())
}
