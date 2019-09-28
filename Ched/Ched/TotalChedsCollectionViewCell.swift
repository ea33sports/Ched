//
//  TotalChedsCollectionViewCell.swift
//  Ched
//
//  Created by Eric Andersen on 2/8/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import UIKit

class TotalChedsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var chedsPerTimeLabel: UILabel!
    @IBOutlet weak var totalChedsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    
    func toggleCalories() {
        if caloriesLabel.isHidden == true {
            caloriesLabel.isHidden = false
//            caloMode = true
//            addChedButton.isHidden = true
//            chedsEatenLabel.text = String(updatedCalories(currentCheds: chedding))
        } else {
            caloriesLabel.isHidden = true
//            caloMode = false
//            addChedButton.isHidden = false
//            chedsEatenLabel.text = String(chedding)
        }
    }
}
