//
//  ContentView.swift
//  kompensationsprojekt
//
//  Created by Ibrahim Adouni on 19.03.23.
//

import SwiftUI
import CoreData

import SwiftUI

struct ContentView: View {
    @StateObject var recipeViewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            RecipeListView(viewModel: recipeViewModel)
        }
    }
}
