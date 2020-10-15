//
//  SwiftReceiptsTests.swift
//  SwiftReceiptsTests
//
//  Created by Elder Santos on 13/10/20.
//

import XCTest
import RxCocoa
import RxSwift

@testable import SwiftReceipts

class SwiftReceiptsTests: XCTestCase {

    let coreDataService = CoreDataService()
    var mealListViewModel: MealListViewModel!
    var apiService: MockAPIService!
    let disposeBag = DisposeBag()
    var meals: [Meal]?
    var mealDetail: Meal?
    var errorMessage: String?
    
    override func setUp() {
        super.setUp()
        
        meals = nil
        mealDetail = nil
        errorMessage = nil
        
        let _area = BehaviorRelay<String>(value: "French")
        let _search = BehaviorRelay<String>(value: "")

        self.apiService = MockAPIService()
        
        self.mealListViewModel = MealListViewModel(area: _area.asDriver(), search: _search.asDriver(), apiService: self.apiService)
        
        self.mealListViewModel.meals.drive(onNext: { (meals) in
            self.meals = meals
        }).disposed(by: disposeBag)
        
        self.mealListViewModel.errorMessage.drive(onNext: { (errorMessage) in
            self.errorMessage = errorMessage
        }).disposed(by: disposeBag)
        
        self.mealListViewModel.mealDetails.drive(onNext: { (mealDetails) in
            self.mealDetail = mealDetails
        }).disposed(by: disposeBag)
    }

    override func tearDown() {        
        meals = nil
        errorMessage = nil
        super.tearDown()
    }

    func testAddMealToDatabase() {
        
        var meal = Meal()
        meal.idMeal = "1234"
        
        _ = coreDataService.createMeal(meal: meal)
        
        XCTAssertNotNil(coreDataService.readMeal(id: "1234"))
    }
    
    func testDeleteAllMeals() {
        
        var meal = Meal()
        meal.idMeal = "1234"
        
        _ = coreDataService.createMeal(meal: meal)
        
        _ = coreDataService.deleteMeals()
        
        XCTAssertEqual(coreDataService.readMeals()?.count, 0)
    }
    
    
    func testGetMealsSuccess(){
        
        mealListViewModel.fetchMeals(area: "Italian")
        XCTAssertTrue(apiService.didStartRequest)
        apiService.mockSuccess()
        
        XCTAssertNotNil(meals)
        XCTAssertNil(errorMessage)
    }
    
    func testGetMealsError(){
        
        mealListViewModel.fetchMeals(area: "Italian")
        XCTAssertTrue(apiService.didStartRequest)
        apiService.mockError(errorMessage: "Mocked error!")
        
        XCTAssertNotNil(self.errorMessage)
    }
}
