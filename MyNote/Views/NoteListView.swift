//
//  NoteListView.swift
//  MyNote
//
//  Created by 阿邓 on 15/11/2025.
//

import SwiftUI

/// 历史记录列表视图
struct NoteListView: View {
    @EnvironmentObject var viewModel: FormViewModel
    @State private var searchText = ""
    @State private var showDeleteAlert = false
    @State private var noteToDelete: FormData?
    
    var filteredNotes: [FormData] {
        if searchText.isEmpty {
            return viewModel.allNotes
        } else {
            return viewModel.allNotes.filter { note in
                note.name.localizedCaseInsensitiveContains(searchText) ||
                note.email.localizedCaseInsensitiveContains(searchText) ||
                note.phone.localizedCaseInsensitiveContains(searchText) ||
                note.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        Group {
            if viewModel.allNotes.isEmpty {
                emptyStateView
            } else {
                noteListView
            }
        }
        .navigationTitle("📋 历史记录")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "搜索记录...")
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                if let note = noteToDelete {
                    withAnimation {
                        viewModel.deleteNote(id: note.id)
                    }
                }
            }
        } message: {
            Text("确定要删除这条记录吗？此操作无法撤销！")
        }
    }
    
    // MARK: - 视图组件
    
    /// 空状态视图
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 70))
                .foregroundColor(.secondary)
            
            Text("还没有记录")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("点击下方按钮创建第一条记录")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// 记录列表视图
    private var noteListView: some View {
        List {
            if filteredNotes.isEmpty {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("未找到匹配的记录")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        Spacer()
                    }
                }
            } else {
                ForEach(filteredNotes) { note in
                    NavigationLink(destination: NoteDetailView(note: note)) {
                        NoteRowView(note: note)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            noteToDelete = note
                            showDeleteAlert = true
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                        
                        Button {
                            viewModel.loadNote(note)
                        } label: {
                            Label("编辑", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Text("共 \(viewModel.allNotes.count) 条记录")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
    }
}

/// 记录行视图
struct NoteRowView: View {
    let note: FormData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 姓名
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                    .frame(width: 20)
                Text(note.name)
                    .font(.headline)
            }
            
            // 邮箱（如果有）
            if !note.email.isEmpty {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.green)
                        .frame(width: 20)
                    Text(note.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // 电话（如果有）
            if !note.phone.isEmpty {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.orange)
                        .frame(width: 20)
                    Text(note.phone)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // 备注预览（如果有）
            if !note.notes.isEmpty {
                HStack(alignment: .top) {
                    Image(systemName: "note.text")
                        .foregroundColor(.purple)
                        .frame(width: 20)
                    Text(note.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            // 保存时间
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                Text(note.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        NoteListView()
            .environmentObject(FormViewModel())
    }
}
