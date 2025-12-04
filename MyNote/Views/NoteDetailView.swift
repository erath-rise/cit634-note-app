//
//  NoteDetailView.swift
//  MyNote
//
//  Created by 阿邓 on 15/11/2025.

import SwiftUI

/// 记录详情视图
struct NoteDetailView: View {
    @EnvironmentObject var viewModel: FormViewModel
    @Environment(\.dismiss) var dismiss
    
    let note: FormData
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 详情卡片
                detailCard
                
                // 操作按钮
                actionButtons
            }
            .padding()
        }
        .navigationTitle("记录详情")
        .navigationBarTitleDisplayMode(.inline)
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                viewModel.deleteNote(id: note.id)
                dismiss()
            }
        } message: {
            Text("确定要删除这条记录吗？此操作无法撤销！")
        }
    }
    
    // MARK: - 视图组件
    
    /// 详情卡片
    private var detailCard: some View {
        VStack(spacing: 20) {
            
            // 姓名
            DetailRow(
                icon: "person.fill",
                iconColor: .blue,
                title: "姓名",
                content: note.name
            )
            
            // 邮箱
            if !note.email.isEmpty {
                DetailRow(
                    icon: "envelope.fill",
                    iconColor: .green,
                    title: "邮箱",
                    content: note.email
                )
            }
            
            // 电话
            if !note.phone.isEmpty {
                DetailRow(
                    icon: "phone.fill",
                    iconColor: .orange,
                    title: "电话",
                    content: note.phone
                )
            }
            
            // 备注
            if !note.notes.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(.purple)
                        Text("备注")
                            .font(.headline)
                    }
                    
                    Text(note.notes)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
            
            Divider()
            
            // 保存时间
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.secondary)
                Text("保存时间：")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(note.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    /// 操作按钮
    private var actionButtons: some View {
        VStack(spacing: 15) {
            // 编辑按钮
            Button(action: {
                viewModel.loadNote(note)
                dismiss()
            }) {
                HStack {
                    Image(systemName: "pencil.circle.fill")
                    Text("编辑记录")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            
            // 删除按钮
            Button(role: .destructive, action: {
                showDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash.circle.fill")
                    Text("删除记录")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.red, .red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
    }
}

/// 详情行组件
struct DetailRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.headline)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: FormData(
            name: "张三",
            email: "zhangsan@example.com",
            phone: "13800138000",
            notes: "这是一条测试备注"
        ))
        .environmentObject(FormViewModel())
    }
}
