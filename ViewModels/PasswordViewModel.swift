//
//  PasswordViewModel.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class PasswordViewModel: ObservableObject {
    @Published var passwords: [Password] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let viewContext: NSManagedObjectContext
    private let encryptionService = EncryptionService.shared
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchPasswords()
    }
    
    // MARK: - Fetch Passwords
    func fetchPasswords() {
        isLoading = true
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PasswordEntity.updatedAt, ascending: false)]
        
        do {
            let entities = try viewContext.fetch(request)
            passwords = entities.compactMap { entity -> Password? in
                guard let id = entity.id,
                      let accountType = entity.accountType,
                      let username = entity.username,
                      let encryptedData = entity.encryptedPassword,
                      let createdAt = entity.createdAt,
                      let updatedAt = entity.updatedAt else {
                    return nil
                }
                
                do {
                    let decryptedPassword = try encryptionService.decrypt(data: encryptedData)
                    return Password(
                        id: id,
                        accountType: accountType,
                        username: username,
                        password: decryptedPassword,
                        createdAt: createdAt,
                        updatedAt: updatedAt
                    )
                } catch {
                    print("Failed to decrypt password: \(error)")
                    return nil
                }
            }
            isLoading = false
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Add Password
    func addPassword(accountType: String, username: String, password: String) {
        // Validation
        guard !accountType.isEmpty else {
            showErrorMessage("Account type cannot be empty")
            return
        }
        
        guard !username.isEmpty else {
            showErrorMessage("Username/Email cannot be empty")
            return
        }
        
        guard !password.isEmpty else {
            showErrorMessage("Password cannot be empty")
            return
        }
        
        isLoading = true
        
        do {
            let encryptedPassword = try encryptionService.encrypt(password: password)
            
            let entity = PasswordEntity(context: viewContext)
            entity.id = UUID()
            entity.accountType = accountType
            entity.username = username
            entity.encryptedPassword = encryptedPassword
            entity.createdAt = Date()
            entity.updatedAt = Date()
            
            try viewContext.save()
            fetchPasswords()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Update Password
    func updatePassword(id: UUID, accountType: String, username: String, password: String) {
        // Validation
        guard !accountType.isEmpty else {
            showErrorMessage("Account type cannot be empty")
            return
        }
        
        guard !username.isEmpty else {
            showErrorMessage("Username/Email cannot be empty")
            return
        }
        
        guard !password.isEmpty else {
            showErrorMessage("Password cannot be empty")
            return
        }
        
        isLoading = true
        
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try viewContext.fetch(request)
            if let entity = results.first {
                let encryptedPassword = try encryptionService.encrypt(password: password)
                
                entity.accountType = accountType
                entity.username = username
                entity.encryptedPassword = encryptedPassword
                entity.updatedAt = Date()
                
                try viewContext.save()
                fetchPasswords()
            }
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Delete Password
    func deletePassword(id: UUID) {
        isLoading = true
        
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try viewContext.fetch(request)
            if let entity = results.first {
                viewContext.delete(entity)
                try viewContext.save()
                fetchPasswords()
            }
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        isLoading = false
        showErrorMessage(error.localizedDescription)
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        isLoading = false
    }
}

