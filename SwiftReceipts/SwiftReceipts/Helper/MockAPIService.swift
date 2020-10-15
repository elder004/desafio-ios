//
//  MockAPIService.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 15/10/20.
//

import Foundation
import Alamofire

class MockAPIService: APIServiceProtocol{
    
    var completionAreas: ((String?, [Area]?) -> ())?
    var completionMeals: ((String?, [Meal]?) -> ())?
    var completionMeal: ((String?, Meal?) -> ())?
    
    var didStartRequest = false
        
    init() {
        
    }
    
    func getAreas(completion: @escaping (String?, [Area]?) -> ()) {
        didStartRequest = true
        completionAreas = completion
    }
    
    func getMealsByArea(area: String, completion: @escaping (String?, [Meal]?) -> ()) {
        didStartRequest = true
        print(completion)
        completionMeals = completion
    }
    
    func searchMealsByName(name: String, completion: @escaping (String?, [Meal]?) -> ()) {
        didStartRequest = true
        completionMeals = completion
    }
    
    func getMealDetails(id: String, completion: @escaping (String?, Meal?) -> ()) {
        didStartRequest = true
        completionMeal = completion
    }
    
    
    func mockSuccess(){
        completionAreas?(nil, [])
        completionMeals?(nil, [])
        completionMeal?(nil, Meal())
    }
    
    func mockError(errorMessage: String){
        completionMeals?(errorMessage, nil)
        completionAreas?(errorMessage, nil)
        completionMeal?(errorMessage, nil)
    }
}
