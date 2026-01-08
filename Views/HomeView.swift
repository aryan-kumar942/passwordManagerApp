//
//  HomeView.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject var viewModel: PasswordViewModel
    @State private var showAddPassword = false
    @State private var selectedPassword: Password?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if viewModel.passwords.isEmpty {
                        emptyStateView
                    } else {
                        passwordListView
                    }
                }
            }
            .navigationTitle("Password Manager")
            .navigationBarTitleDisplayMode(.large)
            .overlay(alignment: .bottomTrailing) {
                addButton
            }
            .sheet(isPresented: $showAddPassword) {
                AddPasswordView(viewModel: viewModel)
            }
            .sheet(item: $selectedPassword) { password in
                PasswordDetailView(viewModel: viewModel, password: password)
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No passwords saved")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Add your first password to get started")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    // MARK: - Password List
    private var passwordListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.passwords) { password in
                    PasswordRowView(password: password)
                        .onTapGesture {
                            selectedPassword = password
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            showAddPassword = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }
}

// MARK: - Password Row View
struct PasswordRowView: View {
    let password: Password
    
    var body: some View {
        HStack(spacing: 16) {
            // Account Type
            Text(password.accountType)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Masked Password
            Text(String(repeating: "•", count: 8))
                .font(.body)
                .foregroundColor(.secondary)
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView(viewModel: PasswordViewModel(context: PersistenceController.preview.container.viewContext))
}

