//
//  FormView.swift
//  MyNote
//
//  Created by YINGLIAN DENG on 15/11/2025.
//

import SwiftUI

/// 表单主视图
struct FormView: View {
    @EnvironmentObject var viewModel: FormViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 编辑模式提示
                if viewModel.isEditMode {
                    editModeHeader
                }
                
                // 表单内容
                formSection
                
                // 按钮区域
                buttonSection
                
                // 历史记录快捷入口
                historyQuickLink
            }
            .padding()
        }
        .navigationTitle("📝 我的记事本")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationButtons
            }
        }
        .alert(viewModel.isEditMode ? "更新成功" : "保存成功", isPresented: $viewModel.showSuccessAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(viewModel.isEditMode ? "记录已成功更新" : "新记录已保存")
        }
        .alert("验证失败", isPresented: $viewModel.showErrorAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .alert("确认清空", isPresented: $viewModel.showClearAlert) {
            Button("取消", role: .cancel) { }
            Button("清空", role: .destructive) {
                withAnimation {
                    viewModel.clearData()
                }
            }
        } message: {
            Text("确定要清空当前输入的所有内容吗？")
        }
    }
    
    // MARK: - 视图组件
    
    /// 编辑模式提示
    private var editModeHeader: some View {
        HStack {
            Image(systemName: "pencil.circle.fill")
                .foregroundColor(.orange)
            Text("编辑模式")
                .font(.headline)
                .foregroundColor(.orange)
            Spacer()
            Button("取消编辑") {
                viewModel.clearData()
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
    
    /// 头部说明区域
    private var headerSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("记录您的重要信息")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical)
    }
    
    /// 表单输入区域
    private var formSection: some View {
        VStack(spacing: 16) {
            // 姓名输入
            VStack(alignment: .leading, spacing: 8) {
                Label("姓名", systemImage: "person.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("请输入您的姓名", text: $viewModel.name)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.words)
            }
            
            // 邮箱输入
            VStack(alignment: .leading, spacing: 8) {
                Label("邮箱", systemImage: "envelope.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("example@email.com", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            // 电话输入
            VStack(alignment: .leading, spacing: 8) {
                Label("电话", systemImage: "phone.fill")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("请输入手机号", text: $viewModel.phone)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
            }
            
            // 备注输入
            VStack(alignment: .leading, spacing: 8) {
                Label("备注", systemImage: "note.text")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextEditor(text: $viewModel.notes)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    /// 按钮区域
    private var buttonSection: some View {
        HStack(spacing: 15) {
            // 保存按钮
            Button(action: {
                viewModel.saveData()
            }) {
                Label(viewModel.isEditMode ? "更新" : "保存", systemImage: viewModel.isEditMode ? "arrow.triangle.2.circlepath" : "square.and.arrow.down.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            
            // 清空按钮
            Button(action: {
                if viewModel.hasData {
                    viewModel.showClearAlert = true
                }
            }) {
                Label("清空", systemImage: "trash.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.red, .red.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .disabled(!viewModel.hasData)
            .opacity(viewModel.hasData ? 1.0 : 0.5)
        }
    }
    
    /// 历史记录快捷入口
    private var historyQuickLink: some View {
        NavigationLink(destination: NoteListView()) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title3)
                Text("查看历史记录")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.allNotes.count) 条")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
    
    /// 导航栏按钮
    private var navigationButtons: some View {
        HStack(spacing: 15) {
            NavigationLink(destination: NoteListView()) {
                Image(systemName: "list.bullet.rectangle")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FormView()
            .environmentObject(FormViewModel())
    }
}
