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
    
    
    
    // MARK: - Variables
    var chedHistory = ChedHistoryController.shared.myChedHistory
    
    
    
    // MARK: - Functions
    func updateView() {
        
    }
}
