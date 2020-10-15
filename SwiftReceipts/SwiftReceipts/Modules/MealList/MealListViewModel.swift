//
//  MealListViewModel.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 13/10/20.
//

import Foundation
import RxSwift
import RxCocoa

class MealListViewModel {
    
    private var apiService: APIServiceProtocol
    private let disposeBag = DisposeBag()
    
    private let _meals = BehaviorRelay<[Meal]>(value: [])
    private let _loading = BehaviorRelay<Bool>(value: false)
    private let _errorMessage = BehaviorRelay<String?>(value: nil)
    private let _mealDetails = BehaviorRelay<Meal?>(value: nil)

    private var _areas: [Area] = []
    
    private var lastSelectedArea: String!
    
    init(area: Driver<String>, search: Driver<String>, apiService: APIServiceProtocol = APIService()){
       
        self.apiService = apiService
        
        area.drive(onNext: { [weak self] (area) in
            self?.lastSelectedArea = area
            self?.fetchMeals(area: area)
        }).disposed(by: disposeBag)
        
        search.debounce(.milliseconds(500))
            .drive(onNext: { [weak self] (query) in
                
                if(!query.isEmpty){
                    self?.fetchMeals(search: query)
                }else{
                    self?.fetchMeals(area: self!.lastSelectedArea)
                }
                
            }).disposed(by: disposeBag)
        
        fetchAreas()
    }
        
    var isLoading: Driver<Bool> {
        return _loading.asDriver()
    }
    
    var meals: Driver<[Meal]> {
        return _meals.asDriver()
    }
    
    var errorMessage: Driver<String?> {
        return _errorMessage.asDriver()
    }
    
    var mealsCount: Int {
        return _meals.value.count
    }
    
    var areas: [String] {
                
        return _areas.map { $0.strArea ?? "" }
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
    
    func fetchMeals(area: String){
        
        self._meals.accept([])
        self._loading.accept(true)
        self._errorMessage.accept(nil)
        
        apiService.getMealsByArea(area: area) {
            (errorMessage, meals) in
            
            self._loading.accept(false)
            
            if let meals = meals{
                
                self._meals.accept(meals)
            }else{
                
                self._errorMessage.accept(errorMessage)
            }
        }
    }
    
    func fetchAreas(){
        
        apiService.getAreas {
            (errorMessage, areas) in
            
            if let areas = areas{
                
                self._areas = areas
            }else{
                self._errorMessage.accept(errorMessage)
            }
        }
    }
    
    func fetchMeals(search: String){

        self._meals.accept([])
        self._loading.accept(true)
        self._errorMessage.accept(nil)
        
        apiService.searchMealsByName(name: search) {
            (errorMessage, meals) in
            
            self._loading.accept(false)
            
            if let meals = meals{
                
                self._meals.accept(meals)
            }else{
                
                self._errorMessage.accept(errorMessage)
            }
        }
    }
    
    func fetchMealDetails(for index: Int){
        
        if(index < _meals.value.count){
            
            apiService.getMealDetails(id: _meals.value[index].idMeal!) { (errorMessage, meal) in
                
                if(meal != nil){
                    self._mealDetails.accept(meal)
                }else{
                    self._errorMessage.accept(errorMessage)
                }
            }
        }
    }
}
