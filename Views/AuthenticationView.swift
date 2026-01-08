//
//  AuthenticationView.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var isAuthenticated: Bool
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Lock Icon
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                // Title
                VStack(spacing: 8) {
                    Text("Password Manager")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Secure your passwords")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                // Authenticate Button
                Button {
                    authenticate()
                } label: {
                    HStack {
                        Image(systemName: biometricIcon)
                        Text("Authenticate")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
        .alert("Authentication Error", isPresented: $showError) {
            Button("Try Again", role: .cancel) {
                authenticate()
            }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            // Auto-trigger authentication on appear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                authenticate()
            }
        }
    }
    
    private var biometricIcon: String {
        switch BiometricAuthService.shared.biometricType() {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .none:
            return "lock.fill"
        }
    }
    
    private func authenticate() {
        BiometricAuthService.shared.authenticateUser { success, error in
            if success {
                withAnimation {
                    isAuthenticated = true
                }
            } else {
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    errorMessage = "Authentication failed. Please try again."
                }
                showError = true
            }
        }
    }
}

#Preview {
    AuthenticationView(isAuthenticated: .constant(false))
}

