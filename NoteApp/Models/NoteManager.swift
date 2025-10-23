//
//  NoteManager.swift
//  NoteApp
//
//  Created by Yinglian Deng on 20/10/2025.
//

import Foundation
import SwiftUI

class NoteManager: ObservableObject {
    @Published var notes: [Note] = []
    
    private let notesKey = "savedNotes"
    private let currentNoteKey = "currentNote"
    private let defaults = UserDefaults.standard
    
    init() {
        loadNotes()
    }
    
    // 保存
    func saveNewNote(_ text: String) {
        guard !text.isEmpty else { return }
        
        let newNote = Note(content: text)
        notes.insert(newNote, at: 0) // 插入到列表开头
        saveNotes()
        
        print("✅ 已保存，共 \(notes.count) 条")
    }
    
    // 更新现有内容
    func updateNote(_ note: Note, with text: String) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].content = text
            notes[index].updatedAt = Date()
            saveNotes()
        }
    }
    
    // 删除内容
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    // 删除所有内容
    func clearAllNotes() {
        notes.removeAll()
        defaults.removeObject(forKey: notesKey)
        defaults.removeObject(forKey: currentNoteKey)
        defaults.synchronize()
        print("🗑️ 所有内容已清除")
    }
    
    // 保存当前编辑中的文本（不创建新笔记）
    func saveCurrentText(_ text: String) {
        defaults.set(text, forKey: currentNoteKey)
        defaults.synchronize()
    }
    
    // 加载当前编辑中的文本
    func loadCurrentText() -> String {
        return defaults.string(forKey: currentNoteKey) ?? ""
    }
    
    // 清除当前文本
    func clearCurrentText() {
        defaults.removeObject(forKey: currentNoteKey)
        defaults.synchronize()
    }
    
    // 保存列表到UserDefaults
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            defaults.set(encoded, forKey: notesKey)
            defaults.synchronize()
        }
    }
    
    // 从UserDefaults加载笔记列表
    private func loadNotes() {
        if let data = defaults.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
            print("📖 加载了 \(notes.count) 条笔记")
        }
    }
    
    // 获取存储路径（用于调试）
    func getStoragePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return paths.first ?? "未知路径"
    }
}
