//
//  UserDefaultsManager.swift
//  MyNote
//
//  Created by YINGLIAN DENG on 15/11/2025.

import Foundation

/// UserDefaults 数据管理器
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    // 存储键
    private enum Keys {
        static let allNotes = "all_notes"
        static let isDarkMode = "is_dark_mode"
    }
    
    private init() {}
    
    /// 保存单条笔记
    func saveNote(_ note: FormData) {
        var notes = loadAllNotes()
        
        // 检查是否已存在，如果存在则更新
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.insert(note, at: 0) // 新记录插入到最前面
        }
        
        saveAllNotes(notes)
    }
    /// 保存所有笔记
    func saveAllNotes(_ notes: [FormData]) {
        if let encoded = try? JSONEncoder().encode(notes) {
            defaults.set(encoded, forKey: Keys.allNotes)
        }
    }
    /// 读取所有笔记
    func loadAllNotes() -> [FormData] {
        guard let data = defaults.data(forKey: Keys.allNotes),
              let notes = try? JSONDecoder().decode([FormData].self, from: data) else {
            return []
        }
        return notes
    }
    /// 删除单条笔记
    func deleteNote(id: UUID) {
        var notes = loadAllNotes()
        notes.removeAll { $0.id == id }
        saveAllNotes(notes)
    }
    
    /// 清除所有数据
    func clearAllData() {
        defaults.removeObject(forKey: Keys.allNotes)
    }
    
    // MARK: - 设置数据
    
    /// 保存深色模式设置
    func saveDarkMode(_ isDark: Bool) {
        defaults.set(isDark, forKey: Keys.isDarkMode)
    }
    
    /// 读取深色模式设置
    func loadDarkMode() -> Bool {
        return defaults.bool(forKey: Keys.isDarkMode)
    }
}
