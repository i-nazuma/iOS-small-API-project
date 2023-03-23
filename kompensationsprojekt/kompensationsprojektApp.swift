//
//  kompensationsprojektApp.swift
//  kompensationsprojekt
//
//  Created by Ibrahim Adouni on 19.03.23.
//

import SwiftUI

@main
struct kompensationsprojektApp: App {
    let persistenceController = PersistenceController.shared
    let viewModel = RecipeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .environmentObject(viewModel)
        }
    }
}
