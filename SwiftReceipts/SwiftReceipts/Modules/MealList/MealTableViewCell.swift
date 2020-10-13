//
//  MealTableViewCell.swift
//  SwiftReceipts
//
//  Created by Elder Santos on 13/10/20.
//

import UIKit
import Kingfisher

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var labelMeal: UILabel!
    
    
    func configure(meal: MealViewModel){
        
        if let url = meal.thumbUrl {
            self.imageThumb.kf.setImage(with: url)
        }
        
        self.labelMeal.text = meal.strMeal
    }

}
