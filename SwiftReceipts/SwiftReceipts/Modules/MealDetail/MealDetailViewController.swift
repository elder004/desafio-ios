//
//  MealDetailViewController.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 14/10/20.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class MealDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageMeal: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelArea: UILabel!
    @IBOutlet weak var labelIngredients: UILabel!
    @IBOutlet weak var labelInstructions: UILabel!
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonFavourite: UIButton!
    
    var mealDetailViewModel: MealDetailViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.alpha = 0
        
        if let _ = mealDetailViewModel {
            configureView()
        }
        
        mealDetailViewModel?.isFavourite.drive(onNext: { [unowned self] (favourite) in
                        
            if(favourite){
                self.buttonFavourite.setImage(UIImage.init(systemName: "star.fill"), for: .normal)
            }else{
                self.buttonFavourite.setImage(UIImage.init(systemName: "star"), for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func configureView(){
                
        self.navigationItem.title = mealDetailViewModel?.name
        self.imageMeal.kf.setImage(with: mealDetailViewModel?.thumbUrl)
        self.labelName.text = mealDetailViewModel?.name
        self.labelCategory.text = mealDetailViewModel?.category
        self.labelArea.text = mealDetailViewModel?.area
        self.labelIngredients.text = mealDetailViewModel?.ingredients
        self.labelInstructions.text = mealDetailViewModel?.instructions
        
        self.buttonFavourite.rx.tap.bind {
            self.mealDetailViewModel?.toggleFavourite()
        }.disposed(by: disposeBag)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func share(_ sender: Any) {
        
        if let url = mealDetailViewModel?.shareUrl {
            
            let activityIntent = UIActivityViewController(activityItems: ["Share this Meal", url], applicationActivities: nil)

            activityIntent.popoverPresentationController?.sourceView = sender as? UIView
            activityIntent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityIntent.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
                
            activityIntent.activityItemsConfiguration = [
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.copyToPasteboard
                ] as? UIActivityItemsConfigurationReading
            
            activityIntent.isModalInPresentation = true
            self.present(activityIntent, animated: true, completion: nil)
        }else{
            
            self.showAlert(title: "Oops...", message: "Nothing to share in this meal.", completion: nil)
        }
    }
}

extension MealDetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var offset = max(scrollView.contentOffset.y, 0)
        offset /= 100.0
        offset = min(offset, 1.0)
        
        self.navigationController?.navigationBar.alpha = offset
        self.buttonBack.alpha = 1.0 - offset
        self.buttonShare.alpha = 1.0 - offset
    }
}
