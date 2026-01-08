//
//  PasswordManagerAppApp.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//

import SwiftUI
import CoreData

@main
struct PasswordManagerAppApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                HomeView(viewModel: PasswordViewModel(context: persistenceController.container.viewContext))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                AuthenticationView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
