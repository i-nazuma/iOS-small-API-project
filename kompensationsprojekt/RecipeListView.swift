//
//  RecipeListView.swift
//  kompensationsprojekt
//
//  Created by Ibrahim Adouni on 19.03.23.
//

import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
            NavigationView {
                Group {
                    if viewModel.isLoading { //shows loading animation if data is fetched
                        ProgressView() //not really visible if internet connection is fairly good
                    } else if viewModel.hasError {
                            Text("Something went wrong, check console for more information.").foregroundColor( .red)
                    } else if viewModel.recipes.isEmpty {
                        Text("No recipes found. Please reload.")
                    } else {
                        List(viewModel.recipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe, viewModel: viewModel)) {
                                RecipeCell(recipe: recipe)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.fetchRecipes()
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }.navigationTitle("Recipes")
    }
}


struct RecipeCell: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: recipe.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray)
            }
            .frame(height: 200)
            Text(recipe.title ?? "")
                .font(.headline)
            HStack {
                Image(systemName: "clock")
                Text("\(recipe.readyInMinutes) mins")
                Spacer()
                Image(systemName: "person")
                Text("\(recipe.servings) servings")
                Button(action: {
                                recipe.isLiked.toggle()
                            }) {
                                Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(recipe.isLiked ? .red : .primary)
                            }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
