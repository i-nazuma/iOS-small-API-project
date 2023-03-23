//
//  RecipeDetailView.swift
//  kompensationsprojekt
//
//  Created by Ibrahim Adouni on 19.03.23.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let imageURL = recipe.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image): //if internet connection is stable, photo is downloaded
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:            //if offline, add placeholder
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        @unknown default:
                            fatalError()
                        }
                    }
                    .frame(height: 200)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.title ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 16) {
                        Image(systemName: "alarm")
                            .foregroundColor(.gray)
                        Text("\(recipe.readyInMinutes) min")
                        
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.gray)
                        Text("\(recipe.servings) servings")
                        
                        Button(action: {
                                recipe.isLiked.toggle()
                            viewModel.saveLike()
                            }) {
                                Image(systemName: recipe.isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(recipe.isLiked ? .red : .primary)
                            }
                    }
                    
                    Text("Instructions:")
                        .font(.headline)
                        .padding(.top, 16)
                    
                    Text(recipe.instructions ?? "")
                        .padding(.top, 8)
                }
                .padding()
            }
        }
        .navigationBarTitle(Text(recipe.title ?? ""), displayMode: .inline)
    }
}
