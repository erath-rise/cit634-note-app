//
//  Note.swift
//  NoteApp
//
//  Created by Yinglian Deng on 20/10/2025.
//

import Foundation

struct Note: Identifiable, Codable {
    var id: UUID
    var content: String
    var createdAt: Date
    var updatedAt: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // 格式化日期显示
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: updatedAt)
    }
    
    // 预览文本（前50个字符）
    var preview: String {
        if content.count > 50 {
            return String(content.prefix(50)) + "..."
        }
        return content
    }
}
