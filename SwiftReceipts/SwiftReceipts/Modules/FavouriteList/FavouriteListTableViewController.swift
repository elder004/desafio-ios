//
//  FavouriteListTableViewController.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 15/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class FavouriteListTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    let favouriteListViewModel = FavouriteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favouriteListViewModel.meals.drive(onNext: { [unowned self] (meals) in
            
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        favouriteListViewModel.mealDetails.drive(onNext: { [unowned self] (mealDetails) in
            
            if let mealDetails = mealDetails {
                self.openMealDetails(meal: mealDetails)
            }
            
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        favouriteListViewModel.fetchFavouriteMeals()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favouriteListViewModel.mealsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealTableViewCell
        
        if let viewModel = favouriteListViewModel.viewModelForIndex(index: indexPath.row){
            
            cell.configure(meal: viewModel)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        favouriteListViewModel.fetchMealDetails(for: indexPath.row)
    }
    
    func openMealDetails(meal: Meal){
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "MealDetailViewController") as? MealDetailViewController
        vc?.mealDetailViewModel = MealDetailViewModel(meal: meal)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
