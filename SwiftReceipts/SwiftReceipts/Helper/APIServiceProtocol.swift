//
//  APIServiceProtocol.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 15/10/20.
//

import Foundation

protocol APIServiceProtocol{
    
    func getAreas(completion: @escaping(_ errorMessage: String?, _ areas: [Area]?) -> ())
    
    func getMealsByArea(area: String, completion: @escaping(_ errorMessage: String?, _ meals: [Meal]?) -> ())
    
    func searchMealsByName(name: String, completion: @escaping(_ errorMessage: String?, _ meals: [Meal]?) -> ())
    
    func getMealDetails(id: String, completion: @escaping(_ errorMessage: String?, _ meal: Meal?) -> ())
}
