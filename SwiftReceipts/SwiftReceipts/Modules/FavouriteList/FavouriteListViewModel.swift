//
//  FavouriteListViewModel.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 15/10/20.
//

import Foundation
import RxSwift
import RxCocoa

class FavouriteListViewModel {
    
    private let disposeBag = DisposeBag()

    let coreDataService = CoreDataService()
    
    private let _meals = BehaviorRelay<[Meal]>(value: [])
    private let _mealDetails = BehaviorRelay<Meal?>(value: nil)

    init(){        
    }
    
    var meals: Driver<[Meal]> {
        return _meals.asDriver()
    }
    
    var mealsCount: Int {
        return _meals.value.count
    }
    
    var mealDetails: Driver<Meal?> {
        return _mealDetails.asDriver()
    }
    
    func viewModelForIndex(index: Int) -> MealViewModel? {
        
        if(index < _meals.value.count){
            return MealViewModel(meal: _meals.value[index])
        }
        
        return nil
    }
    
    func fetchFavouriteMeals(){
        
        if let meals = coreDataService.readMeals(){            
            _meals.accept(meals)
        }
    }
    
    func fetchMealDetails(for index: Int){
        
        if(index < _meals.value.count){
            
            self._mealDetails.accept(_meals.value[index])
        }
    }
}
