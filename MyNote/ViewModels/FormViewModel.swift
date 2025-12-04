//
//  FormView.swift
//  MyNote
//
//  Created by YINGLIAN DENG on 15/11/2025.
//

import Foundation
import SwiftUI
import Combine

/// 表单视图模型
class FormViewModel: ObservableObject {
    // 当前编辑的笔记
    @Published var currentNote: FormData?
    
    // 表单字段
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var notes: String = ""
    
    // 所有历史记录
    @Published var allNotes: [FormData] = []
    
    // UI状态
    @Published var showSuccessAlert = false
    @Published var showClearAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    private let manager = UserDefaultsManager.shared
    
    init() {
        loadAllNotes()
    }
    
    /// 加载所有笔记
    func loadAllNotes() {
        allNotes = manager.loadAllNotes()
    }
    
    /// 保存数据（创建新记录或更新现有记录）
    func saveData() {
        // 验证数据
        if !validateData() {
            return
        }
        
        let note: FormData
        if let current = currentNote {
            // 更新现有记录
            note = FormData(
                id: current.id,
                name: name,
                email: email,
                phone: phone,
                notes: notes,
                lastSaved: Date()
            )
        } else {
            // 创建新记录
            note = FormData(
                name: name,
                email: email,
                phone: phone,
                notes: notes,
                lastSaved: Date()
            )
        }
        
        manager.saveNote(note)
        loadAllNotes()
        showSuccessAlert = true
        
        // 保存后清空表单
        clearData()
    }
    
    /// 加载笔记到表单（用于编辑）
    func loadNote(_ note: FormData) {
        currentNote = note
        name = note.name
        email = note.email
        phone = note.phone
        notes = note.notes
    }
    
    /// 删除笔记
    func deleteNote(id: UUID) {
        manager.deleteNote(id: id)
        loadAllNotes()
    }
    
    /// 清空当前表单
    func clearData() {
        currentNote = nil
        name = ""
        email = ""
        phone = ""
        notes = ""
    }
    
    /// 清空所有保存的数据
    func clearAllSavedData() {
        manager.clearAllData()
        loadAllNotes()
        clearData()
    }
    
    /// 验证所有输入数据
    private func validateData() -> Bool {
        // 验证姓名
        if !Validator.isValidName(name) {
            errorMessage = "姓名长度应在2-20个字符之间"
            showErrorAlert = true
            return false
        }
        
        // 验证邮箱
        if !Validator.isValidEmail(email) {
            errorMessage = "请输入有效的邮箱地址"
            showErrorAlert = true
            return false
        }
        
        // 验证手机号
        if !Validator.isValidPhone(phone) {
            errorMessage = "请输入有效的手机号（11位数字）"
            showErrorAlert = true
            return false
        }
        
        return true
    }
    
    /// 检查是否有数据
    var hasData: Bool {
        return !name.isEmpty || !email.isEmpty || !phone.isEmpty || !notes.isEmpty
    }
    
    /// 是否是编辑模式
    var isEditMode: Bool {
        return currentNote != nil
    }
}
