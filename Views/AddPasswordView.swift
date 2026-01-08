//
//  AddPasswordView.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//

import SwiftUI
import CoreData

struct AddPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PasswordViewModel
    
    @State private var accountType = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showPasswordGenerator = false
    @State private var isPasswordVisible = false
    
    var passwordStrength: PasswordStrength {
        PasswordValidator.calculateStrength(password: password)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Account Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Account Name")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("e.g., Google, Facebook, Instagram", text: $accountType)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.words)
                        }
                        
                        // Username/Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username/ Email")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter username or email", text: $username)
                                .textFieldStyle(CustomTextFieldStyle())
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                if isPasswordVisible {
                                    TextField("Enter password", text: $password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                } else {
                                    SecureField("Enter password", text: $password)
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
                        }
                        
                        // Password Strength Meter
                        if !password.isEmpty {
                            PasswordStrengthMeter(strength: passwordStrength)
                        }
                        
                        Spacer()
                        
                        // Add Button
                        Button {
                            addPassword()
                        } label: {
                            Text("Add New Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.black)
                                .cornerRadius(28)
                        }
                        .disabled(accountType.isEmpty || username.isEmpty || password.isEmpty)
                        .opacity((accountType.isEmpty || username.isEmpty || password.isEmpty) ? 0.5 : 1.0)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Add New Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showPasswordGenerator) {
                PasswordGeneratorView(generatedPassword: $password)
            }
        }
    }
    
    private func addPassword() {
        viewModel.addPassword(accountType: accountType, username: username, password: password)
        
        if !viewModel.showError {
            dismiss()
        }
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(10)
    }
}

// MARK: - Password Strength Meter
struct PasswordStrengthMeter: View {
    let strength: PasswordStrength
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Password Strength:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(strength.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(strengthColor)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(strengthColor)
                        .frame(width: geometry.size.width * strength.progress, height: 8)
                        .animation(.easeInOut, value: strength)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 8)
    }
    
    private var strengthColor: Color {
        switch strength {
        case .weak:
            return .red
        case .medium:
            return .orange
        case .strong:
            return .green
        }
    }
}

#Preview {
    AddPasswordView(viewModel: PasswordViewModel(context: PersistenceController.preview.container.viewContext))
}

