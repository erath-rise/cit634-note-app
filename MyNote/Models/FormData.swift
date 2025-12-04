//
//  FormData.swift
//  MyNote
//
//  Created by YINGLIAN DENG on 15/11/2025.
//

import Foundation

/// 表单数据模型
struct FormData: Codable, Identifiable {
    var id: UUID
    var name: String
    var email: String
    var phone: String
    var notes: String
    var lastSaved: Date
    
    /// 初始化
    init(id: UUID = UUID(), name: String = "", email: String = "", phone: String = "", notes: String = "", lastSaved: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.notes = notes
        self.lastSaved = lastSaved
    }
    
    /// 检查是否为空
    var isEmpty: Bool {
        return name.isEmpty && email.isEmpty && phone.isEmpty && notes.isEmpty
    }
    
    /// 格式化日期
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: lastSaved)
    }
}
