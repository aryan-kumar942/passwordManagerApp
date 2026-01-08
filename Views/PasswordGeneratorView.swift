//
//  PasswordGeneratorView.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//
import SwiftUI

struct PasswordGeneratorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var generatedPassword: String
    
    @State private var password = ""
    @State private var length: Double = 16
    @State private var includeUppercase = true
    @State private var includeLowercase = true
    @State private var includeNumbers = true
    @State private var includeSpecial = true
    @State private var isCopied = false
    
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
                        // Generated Password Display
                        VStack(spacing: 12) {
                            HStack {
                                Text(password.isEmpty ? "Generated password will appear here" : password)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundColor(password.isEmpty ? .secondary : .primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if !password.isEmpty {
                                    Button {
                                        UIPasteboard.general.string = password
                                        isCopied = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            isCopied = false
                                        }
                                    } label: {
                                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                            
                            if !password.isEmpty {
                                PasswordStrengthMeter(strength: passwordStrength)
                            }
                        }
                        
                        // Length Slider
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Length")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(Int(length))")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            
                            Slider(value: $length, in: 8...32, step: 1)
                                .tint(.blue)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                        
                        // Options
                        VStack(spacing: 0) {
                            ToggleRow(title: "Uppercase (A-Z)", isOn: $includeUppercase)
                            Divider().padding(.leading, 16)
                            ToggleRow(title: "Lowercase (a-z)", isOn: $includeLowercase)
                            Divider().padding(.leading, 16)
                            ToggleRow(title: "Numbers (0-9)", isOn: $includeNumbers)
                            Divider().padding(.leading, 16)
                            ToggleRow(title: "Special Characters (!@#$)", isOn: $includeSpecial)
                        }
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                        
                        // Generate Button
                        Button {
                            generatePassword()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Generate Password")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(28)
                        }
                        
                        // Use Password Button
                        if !password.isEmpty {
                            Button {
                                generatedPassword = password
                                dismiss()
                            } label: {
                                Text("Use This Password")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color.black)
                                    .cornerRadius(28)
                            }
                        }
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Password Generator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                generatePassword()
            }
        }
    }
    
    private func generatePassword() {
        password = PasswordValidator.generatePassword(
            length: Int(length),
            includeUppercase: includeUppercase,
            includeLowercase: includeLowercase,
            includeNumbers: includeNumbers,
            includeSpecial: includeSpecial
        )
    }
}

// MARK: - Toggle Row
struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    PasswordGeneratorView(generatedPassword: .constant(""))
}
