//
//  RecipeResponse.swift
//  kompensationsprojekt
//
//  Created by Ibrahim Adouni on 19.03.23.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [RecipeResult]
}

struct RecipeResult: Codable {
    let id: Int
    let title: String
    let image: String?
    let readyInMinutes: Int
    let servings: Int
    let instructions: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, readyInMinutes, servings, instructions
    }
}
