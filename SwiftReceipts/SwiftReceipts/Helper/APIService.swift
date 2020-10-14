//
//  APIService.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 13/10/20.
//

import Foundation
import Alamofire

struct APIService{
    
    let baseUrl = "https://www.themealdb.com/api/json/v1/1/"
    
    init() {
    }
    
    func getAreas(completion: @escaping(_ errorMessage: String?, _ areas: [Area]?) -> ()){
        
        AF.request("\(baseUrl)list.php?a=list", method: .get).responseData {
            response in
            
            if(response.error != nil){
                
                completion(response.error!.localizedDescription, nil)
            }else if(response.response?.statusCode == 200 && response.data != nil){
                
                do {
                    let result = try JSONDecoder().decode(AreasResult.self, from: response.data!)
                    completion(nil, result.meals)
                    
                } catch let error {
                    print(error.localizedDescription)
                    completion(error.localizedDescription, nil)
                }
            }else{
                completion("Error! Please try again later.", nil)
            }
        }
    }
    
    func getMealsByArea(area: String, completion: @escaping(_ errorMessage: String?, _ meals: [Meal]?) -> ()){
        
        AF.request("\(baseUrl)filter.php?a=\(area)", method: .get).responseJSON {
            response in
            
            if(response.error != nil){
                
                completion(response.error!.localizedDescription, nil)
            }else if(response.response?.statusCode == 200){
                
                do {
                    let result = try JSONDecoder().decode(MealsResult.self, from: response.data!)
                    completion(nil, result.meals)
                    
                } catch let error {
                    print(error.localizedDescription)
                    completion(error.localizedDescription, nil)
                }
                
            }else{
                completion("Error! Please try again later.", nil)
            }
        }
    }
    
    func searchMealsByName(name: String, completion: @escaping(_ errorMessage: String?, _ meals: [Meal]?) -> ()){
        
        AF.request("\(baseUrl)search.php?s=\(name.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? name)", method: .get).responseJSON {
            response in
            
            if(response.error != nil){
                
                completion(response.error!.localizedDescription, nil)
            }else if(response.response?.statusCode == 200){
                
                do {
                    let result = try JSONDecoder().decode(MealsResult.self, from: response.data!)
                    completion(nil, result.meals)
                    
                } catch let error {
                    print(error.localizedDescription)
                    completion(error.localizedDescription, nil)
                }
                
            }else{
                completion("Error! Please try again later.", nil)
            }
        }
    }
    
    func getMealDetails(id: String, completion: @escaping(_ errorMessage: String?, _ meal: Meal?) -> ()){
        
        AF.request("\(baseUrl)lookup.php?i=\(id)", method: .get).responseJSON {
            response in
            
            if(response.error != nil){
                
                completion(response.error!.localizedDescription, nil)
            }else if(response.response?.statusCode == 200){
                
                do {
                    let result = try JSONDecoder().decode(MealsResult.self, from: response.data!)
                    if let meals = result.meals{
                        
                        if(meals.count > 0){
                            completion(nil, meals[0])
                        }else{
                            completion("Meal not found!", nil)
                        }
                        
                    }else{
                        completion("Error! Please try again later.", nil)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                    completion(error.localizedDescription, nil)
                }
                
            }else{
                completion("Error! Please try again later.", nil)
            }
        }
    }
}
