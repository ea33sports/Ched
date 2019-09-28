//
//  MyChedSessionsTableViewCell.swift
//  Ched
//
//  Created by Eric Andersen on 2/13/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import UIKit

class MyChedSessionsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chedsEatenLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    
    // MARK: - Variables
    var session: ChedSession? {
        didSet {
            updateViews()
        }
    }
    
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    // MARK: - Functions
    func updateViews() {
        
        guard let session = session else { fatalError() }
        
//        let calendar = Calendar.current
//        
//        let hour = calendar.component(.hour, from: date)
//        let minute = calendar.component(.minute, from: date)
        
        dateLabel.text = session.session?.stringValue()
        timeLabel.text = "@\(session.session?.hour12 ?? "")"
        chedsEatenLabel.text = "\(session.chedsEaten)"
    }
}
