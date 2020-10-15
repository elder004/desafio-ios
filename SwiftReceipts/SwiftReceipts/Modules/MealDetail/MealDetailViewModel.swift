//
//  MealDetailViewModel.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa

class MealDetailViewModel {
    
    private var _meal: Meal
    private var _isFavourite = BehaviorRelay<Bool>(value: false)
    
    let coreDataService = CoreDataService()
    
    init(meal: Meal){
        self._meal = meal
                
        let retrievedMeal = coreDataService.readMeal(id: meal.idMeal!)
        
        _isFavourite.accept(retrievedMeal != nil)
    }
    
    var isFavourite: Driver<Bool> {
        return _isFavourite.asDriver()
    }
    
    var name: String? {
        return _meal.strMeal
    }
    
    var drinkAlternate: String? {
        return _meal.strDrinkAlternate
    }
    
    var category: String? {
        return _meal.strCategory
    }
    
    var area: String? {
        return _meal.strArea
    }
    
    var instructions: String? {
        return _meal.strInstructions
    }
    
    var tags: [String] {
        return _meal.strTags?.components(separatedBy: ",") ?? []
    }
    
    var thumbUrl: URL? {
        
        if let urlString = _meal.strMealThumb {
            
            return URL(string: urlString)
        }
        
        return nil
    }
    
    var shareUrl: URL? {
        
        if let urlString = _meal.strSource {
            return URL(string: urlString)
        }
        
        if let urlString = _meal.strYoutube {
            return URL(string: urlString)
        }
        
        if let urlString = _meal.strMealThumb {
            return URL(string: urlString)
        }
        
        return nil
    }
    
    var ingredients: String {
        
        var list = ""
        
        _meal.strIngredient1?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient1!) - \(_meal.strMeasure1 ?? "")\n") : nil
        _meal.strIngredient2?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient2!) - \(_meal.strMeasure2 ?? "")\n") : nil
        _meal.strIngredient3?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient3!) - \(_meal.strMeasure3 ?? "")\n") : nil
        _meal.strIngredient4?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient4!) - \(_meal.strMeasure4 ?? "")\n") : nil
        _meal.strIngredient5?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient5!) - \(_meal.strMeasure5 ?? "")\n") : nil
        _meal.strIngredient6?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient6!) - \(_meal.strMeasure6 ?? "")\n") : nil
        _meal.strIngredient7?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient7!) - \(_meal.strMeasure7 ?? "")\n") : nil
        _meal.strIngredient8?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient8!) - \(_meal.strMeasure8 ?? "")\n") : nil
        _meal.strIngredient9?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient9!) - \(_meal.strMeasure9 ?? "")\n") : nil
        _meal.strIngredient10?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient10!) - \(_meal.strMeasure10 ?? "")\n") : nil
        _meal.strIngredient11?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient11!) - \(_meal.strMeasure11 ?? "")\n") : nil
        _meal.strIngredient12?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient12!) - \(_meal.strMeasure12 ?? "")\n") : nil
        _meal.strIngredient13?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient13!) - \(_meal.strMeasure13 ?? "")\n") : nil
        _meal.strIngredient14?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient14!) - \(_meal.strMeasure14 ?? "")\n") : nil
        _meal.strIngredient15?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient15!) - \(_meal.strMeasure15 ?? "")\n") : nil
        _meal.strIngredient16?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient16!) - \(_meal.strMeasure16 ?? "")\n") : nil
        _meal.strIngredient17?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient17!) - \(_meal.strMeasure17 ?? "")\n") : nil
        _meal.strIngredient18?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient18!) - \(_meal.strMeasure18 ?? "")\n") : nil
        _meal.strIngredient19?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient19!) - \(_meal.strMeasure19 ?? "")\n") : nil
        _meal.strIngredient20?.count ?? 0 > 0 ? list.append("\(_meal.strIngredient20!) - \(_meal.strMeasure20 ?? "")\n") : nil
        
        return list
    }
    
    func toggleFavourite(){
        
        if(_isFavourite.value){
            
            _ = coreDataService.deleteMeal(id: _meal.idMeal!)
        }else{
            _ = coreDataService.createMeal(meal: _meal)
        }
        
        _isFavourite.accept(!_isFavourite.value)
    }
}
