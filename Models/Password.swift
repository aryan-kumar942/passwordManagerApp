//
//  Password.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//
import Foundation

struct Password: Identifiable, Equatable {
    let id: UUID
    var accountType: String
    var username: String
    var password: String
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(), accountType: String, username: String, password: String, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.accountType = accountType
        self.username = username
        self.password = password
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // Password strength calculation
    var passwordStrength: PasswordStrength {
        return PasswordValidator.calculateStrength(password: password)
    }
}

enum PasswordStrength: String {
    case weak = "Weak"
    case medium = "Medium"
    case strong = "Strong"
    
    var color: String {
        switch self {
        case .weak: return "red"
        case .medium: return "orange"
        case .strong: return "green"
        }
    }
    
    var progress: Double {
        switch self {
        case .weak: return 0.33
        case .medium: return 0.66
        case .strong: return 1.0
        }
    }
}

class PasswordValidator {
    static func calculateStrength(password: String) -> PasswordStrength {
        var score = 0
        
        // Length check
        if password.count >= 8 {
            score += 1
        }
        if password.count >= 12 {
            score += 1
        }
        
        // Contains lowercase
        if password.range(of: "[a-z]", options: .regularExpression) != nil {
            score += 1
        }
        
        // Contains uppercase
        if password.range(of: "[A-Z]", options: .regularExpression) != nil {
            score += 1
        }
        
        // Contains digit
        if password.range(of: "[0-9]", options: .regularExpression) != nil {
            score += 1
        }
        
        // Contains special character
        if password.range(of: "[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]", options: .regularExpression) != nil {
            score += 1
        }
        
        // Determine strength based on score
        if score >= 5 {
            return .strong
        } else if score >= 3 {
            return .medium
        } else {
            return .weak
        }
    }
    
    static func generatePassword(length: Int = 16, includeUppercase: Bool = true, includeLowercase: Bool = true, includeNumbers: Bool = true, includeSpecial: Bool = true) -> String {
        var characters = ""
        
        if includeUppercase {
            characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        if includeLowercase {
            characters += "abcdefghijklmnopqrstuvwxyz"
        }
        if includeNumbers {
            characters += "0123456789"
        }
        if includeSpecial {
            characters += "!@#$%^&*()_+-=[]{}|;:,.<>?"
        }
        
        guard !characters.isEmpty else {
            return ""
        }
        
        var password = ""
        for _ in 0..<length {
            if let randomChar = characters.randomElement() {
                password.append(randomChar)
            }
        }
        
        return password
    }
}

