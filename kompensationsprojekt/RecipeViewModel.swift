//
//  RecipeViewModel.swift
//  kompensationsprojekt
//
//  Created by Ibrahim Adouni on 19.03.23.
//

import Foundation
import CoreData

class RecipeViewModel : ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var hasError = false
    private let context = PersistenceController.shared.container.viewContext

    init() { // when app is started, data from DB is loaded first
        self.loadRecipesFromPersistentStorage()
    }
    
    func fetchRecipes() {
        isLoading = true
        hasError = false
        
        let apiKey = "2e94ef502e2347e99e5ab48132f788b9" //this API needed an API Key, I hope it still works when you test it, otherwise please write me or you may create one throught the url below
        
        let url = "https://api.spoonacular.com/recipes/random?number=10&apiKey=\(apiKey)"
        guard let apiUrl = URL(string: url) else {
            isLoading = false
            hasError = true
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RecipeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.recipes = response.recipes.map { recipe in
                            let newRecipe = Recipe(context: self.context)
                            newRecipe.id = Int64(recipe.id)
                            newRecipe.title = recipe.title
                            newRecipe.imageURL = recipe.image
                            newRecipe.readyInMinutes = Int16(recipe.readyInMinutes)
                            newRecipe.servings = Int16(recipe.servings)
                            newRecipe.instructions = recipe.instructions
                            newRecipe.isLiked = false

                            return newRecipe
                        }
                       try? self.context.save()
                   }
               } catch let error {
                   DispatchQueue.main.async {
                       self.hasError = true
                   }
                   print("Error decoding JSON: \(error)")
               }
           } else if let error = error {
               DispatchQueue.main.async {
                   self.hasError = true
               }
               print("Error fetching recipes: \(error)")
           }
       }
        self.isLoading = false
        task.resume()
   }
    
    private func loadRecipesFromPersistentStorage() {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        do {
            let loadedRecipes = try self.context.fetch(request)
            self.recipes = loadedRecipes
        } catch {
            print("Error loading recipes from persistent storage: \(error)")
        }
    }
    
    func saveLike() {
        try? self.context.save()
        self.objectWillChange.send() // Notify the view that the data has changed
    }

}
