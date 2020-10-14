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
import JGProgressHUD

class MealListTableViewController: UITableViewController {
    
    @IBOutlet weak var buttonFilter: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    private var _area = BehaviorRelay<String>(value: "French")
    
    var mealListViewModel: MealListViewModel!
    var selectedAreaIndex = 0
    
    let progress = JGProgressHUD(style: .dark)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mealListViewModel = MealListViewModel(area: _area.asDriver(), search: searchBar.rx.text.orEmpty.asDriver())
        
        mealListViewModel.meals.drive(onNext: { [unowned self] (_) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] (_) in
                searchBar?.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] (_) in
                searchBar?.resignFirstResponder()
                searchBar?.text = nil
            }).disposed(by: disposeBag)
        
        searchBar.rx.text.asDriver().drive(onNext: { [unowned searchBar] (_) in
            
            if(searchBar?.text?.count == 0){
                searchBar?.resignFirstResponder()
                searchBar?.showsCancelButton = false
            }else{
                searchBar?.showsCancelButton = true
            }
        }).disposed(by: disposeBag)
        
        mealListViewModel.isLoading.drive(onNext: { [unowned self] (isLoading) in
            
            if(isLoading){
                self.progress.show(in: self.view)
            }else{
                self.progress.dismiss(animated: true)
            }
            
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
