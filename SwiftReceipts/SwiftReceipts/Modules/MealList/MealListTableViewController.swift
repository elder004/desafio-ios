//
//  MealListTableViewController.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 13/10/20.
//

import UIKit
import RxCocoa
import RxSwift
import ActionSheetPicker_3_0

class MealListTableViewController: UITableViewController {
    
    @IBOutlet weak var buttonFilter: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    private var _area = BehaviorRelay<String>(value: "French")
    
    var mealListViewModel: MealListViewModel!
    var selectedAreaIndex = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mealListViewModel = MealListViewModel(area: _area.asDriver())
        //_area.accept("French")
        
        mealListViewModel.meals.drive(onNext: { [unowned self] (_) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mealListViewModel.mealsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealTableViewCell
        
        if let viewModel = mealListViewModel.viewModelForIndex(index: indexPath.row){
            
            cell.configure(meal: viewModel)
        }
        
        return cell
    }
    
    @IBAction func openFilter(_ sender: Any) {
            
        let areaPicker = ActionSheetStringPicker(title: "Filter Meals by Area", rows: mealListViewModel.areas, initialSelection: selectedAreaIndex, doneBlock: {
            (stringPicker, index, value) in
            self.selectedAreaIndex = index
            self._area.accept(value as! String)
        }, cancel: {
            (picker) in

        }, origin: self.buttonFilter)
        
        areaPicker?.show()
    }
}
