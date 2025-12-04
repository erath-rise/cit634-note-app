//
//  validator.swift
//  MyNote
//
//  Created by YINGLIAN DENG on 15/11/2025.
//

import Foundation

/// 输入验证工具类
class Validator {
    /// 验证邮箱的格式
    static func isValidEmail(_ email: String) -> Bool {
        if email.isEmpty {
            return true
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    /// 验证手机号格式
    static func isValidPhone(_ phone: String) -> Bool {
        if phone.isEmpty {
            return true
        }
        // 手机号验证：11位数字
        let phoneRegex = "^1[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    /// 验证姓名
    static func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.count >= 2 && trimmedName.count <= 20
    }
    /// 获取错误提示信息
    static func getErrorMessage(for field: String, value: String) -> String? {
        switch field {
        case "email":
            return isValidEmail(value) ? nil : "请输入有效的邮箱地址"
        case "phone":
            return isValidPhone(value) ? nil : "请输入有效的手机号（11位数字）"
        case "name":
            return isValidName(value) ? nil : "姓名长度应在2-20个字符之间"
        default:
            return nil
        }
    }
}
