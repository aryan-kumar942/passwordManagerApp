//
//  PasswordDetailsView.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//

import SwiftUI
import CoreData

struct PasswordDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PasswordViewModel
    let password: Password
    
    @State private var isEditing = false
    @State private var accountType: String
    @State private var username: String
    @State private var passwordText: String
    @State private var isPasswordVisible = false
    @State private var showDeleteAlert = false
    @State private var showPasswordGenerator = false
    
    init(viewModel: PasswordViewModel, password: Password) {
        self.viewModel = viewModel
        self.password = password
        _accountType = State(initialValue: password.accountType)
        _username = State(initialValue: password.username)
        _passwordText = State(initialValue: password.password)
    }
    
    var passwordStrength: PasswordStrength {
        PasswordValidator.calculateStrength(password: passwordText)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        Text("Account Details")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Account Type
                        DetailFieldView(
                            label: "Account Type",
                            text: $accountType,
                            isEditing: isEditing
                        )
                        
                        // Username/Email
                        DetailFieldView(
                            label: "Username/ Email",
                            text: $username,
                            isEditing: isEditing
                        )
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if isEditing {
                                HStack {
                                    if isPasswordVisible {
                                        TextField("Password", text: $passwordText)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                    } else {
                                        SecureField("Password", text: $passwordText)
                                    }
                                    
                                    Button {
                                        isPasswordVisible.toggle()
                                    } label: {
                                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Button {
                                        showPasswordGenerator = true
                                    } label: {
                                        Image(systemName: "arrow.clockwise")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(10)
                            } else {
                                HStack {
                                    Text(isPasswordVisible ? passwordText : String(repeating: "•", count: 8))
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Button {
                                        isPasswordVisible.toggle()
                                    } label: {
                                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(10)
                            }
                        }
                        
                        // Password Strength Meter (only when editing)
                        if isEditing && !passwordText.isEmpty {
                            PasswordStrengthMeter(strength: passwordStrength)
                        }
                        
                        Spacer()
                        
                        // Action Buttons
                        if isEditing {
                            HStack(spacing: 12) {
                                Button {
                                    cancelEditing()
                                } label: {
                                    Text("Cancel")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(Color.gray)
                                        .cornerRadius(28)
                                }
                                
                                Button {
                                    saveChanges()
                                } label: {
                                    Text("Save")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(Color.black)
                                        .cornerRadius(28)
                                }
                                .disabled(accountType.isEmpty || username.isEmpty || passwordText.isEmpty)
                            }
                        } else {
                            HStack(spacing: 12) {
                                Button {
                                    isEditing = true
                                } label: {
                                    Text("Edit")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(Color.black)
                                        .cornerRadius(28)
                                }
                                
                                Button {
                                    showDeleteAlert = true
                                } label: {
                                    Text("Delete")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(Color.red)
                                        .cornerRadius(28)
                                }
                            }
                        }
                    }
                    .padding(24)
                }
            }
            .navigationTitle(isEditing ? "Edit Password" : "Password Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Cancel" : "Close") {
                        if isEditing {
                            cancelEditing()
                        } else {
                            dismiss()
                        }
                    }
                }
            }
            .alert("Delete Password", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deletePassword()
                }
            } message: {
                Text("Are you sure you want to delete this password? This action cannot be undone.")
            }
            .sheet(isPresented: $showPasswordGenerator) {
                PasswordGeneratorView(generatedPassword: $passwordText)
            }
        }
    }
    
    private func saveChanges() {
        viewModel.updatePassword(
            id: password.id,
            accountType: accountType,
            username: username,
            password: passwordText
        )
        
        if !viewModel.showError {
            isEditing = false
            dismiss()
        }
    }
    
    private func cancelEditing() {
        accountType = password.accountType
        username = password.username
        passwordText = password.password
        isEditing = false
        isPasswordVisible = false
    }
    
    private func deletePassword() {
        viewModel.deletePassword(id: password.id)
        dismiss()
    }
}

// MARK: - Detail Field View
struct DetailFieldView: View {
    let label: String
    @Binding var text: String
    let isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if isEditing {
                TextField(label, text: $text)
                    .textFieldStyle(CustomTextFieldStyle())
                    .autocapitalization(label == "Account Type" ? .words : .none)
            } else {
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    PasswordDetailView(
        viewModel: PasswordViewModel(context: PersistenceController.preview.container.viewContext),
        password: Password(accountType: "Facebook", username: "Amitshah165@maill.com", password: "********")
    )
}

