//
//  MealViewModel.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 13/10/20.
//

import Foundation
 
class MealViewModel {
    
    private var meal: Meal
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    var strMeal: String {
        return self.meal.strMeal ?? ""
    }
    
    var thumbUrl: URL? {
        
        if let urlString = self.meal.strMealThumb {
            
            return URL(string: urlString)
        }
        
        return nil
    }
}
