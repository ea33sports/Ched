//
//  ChedHistoryTableViewController.swift
//  Ched
//
//  Created by Eric Andersen on 2/12/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import UIKit

class ChedHistoryTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var calorieButton: CalorieBarButton!
    
    
    
    // MARK: - Variables
    var sessions = ChedHistoryController.shared.chedSessions
    var allSessionsGrouped = [[ChedSession]]()
    var calMode = false
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
//        setGradientToTableView(tableView: tableView, topColor: #colorLiteral(red: 1, green: 0.7333333333, blue: 0.3490196078, alpha: 1), bottomColor: #colorLiteral(red: 0.5176470588, green: 0.7803921569, blue: 0.6431372549, alpha: 1))
//        view.addVerticalGradientLayer(topColor: #colorLiteral(red: 1, green: 0.7333333333, blue: 0.3490196078, alpha: 1), bottomColor: #colorLiteral(red: 0.5176470588, green: 0.7803921569, blue: 0.6431372549, alpha: 1))
        scrollToBottom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groupAllSessions()
    }
    
    
    
    // MARK: - Functions
    func setGradientToTableView(tableView: UITableView, topColor:UIColor, bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    
    func groupAllSessions() {
        
        let groupedDictionary = Dictionary(grouping: sessions) { (month) -> Int in
            return (month.session?.monthNum)!
        }
        
        let keys = groupedDictionary.keys.sorted()
        keys.forEach({
            allSessionsGrouped.append(groupedDictionary[$0]!)
        })
        
        tableView.reloadData()
    }
    
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let section = self.allSessionsGrouped.count - 1
            let item = self.allSessionsGrouped[section].count - 1
            let indexPath = IndexPath(item: item, section: section)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func toggleCalories() {
        if calMode == false {
            calMode = true
            calorieButton.setImage(#imageLiteral(resourceName: "heartFull"), for: .normal)
            tableView.reloadData()
        } else {
            calMode = false
            calorieButton.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Actions
    @IBAction func calorieButtonTapped(_ sender: Any) {
        toggleCalories()
    }
    

    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allSessionsGrouped.count > 0 ? allSessionsGrouped.count : 1
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if allSessionsGrouped.count == 0 {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
//        headerView.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 0)
        
        let headerLabel = UILabel(frame: CGRect(x: 24, y: 48, width: (tableView.bounds.size.width - 60), height: 80))
        headerLabel.font = UIFont(name: "Avenir Next", size: 50)
        headerLabel.textColor = #colorLiteral(red: 0.5176470588, green: 0.7803921569, blue: 0.6431372549, alpha: 1)
//        headerLabel.textColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.textAlignment = .left
        headerLabel.numberOfLines = 1
        headerLabel.adjustsFontSizeToFitWidth = true
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let key = allSessionsGrouped[section]
        let targetSession = key.first
        let monthString = targetSession?.session?.monthFull
        
        return monthString
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return allSessionsGrouped.count == 0 ? 0 : 128
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if allSessionsGrouped.count > 0 {
            return allSessionsGrouped[section].count
        }
        
        return sessions.count
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as? MyChedSessionsTableViewCell else { return UITableViewCell() }
        let session: ChedSession

        // Configure the cell...
        if calMode == true {
            if allSessionsGrouped.count > 0 {
                session = allSessionsGrouped[indexPath.section][indexPath.row]
                cell.session = session
                
                let cheds = Int(session.chedsEaten)
                let calories = cheds * 4
                
                if cheds == 1 {
                    cell.chedsEatenLabel.text = "\(cheds) Ched"
                } else {
                    cell.chedsEatenLabel.text = "\(cheds) Cheds"
                }
                
                cell.caloriesLabel.isHidden = false
                cell.caloriesLabel.text = "\(String(calories)) calories"
                
            } else {
                session = sessions[indexPath.row]
                cell.session = session
                
                let cheds = Int(session.chedsEaten)
                let calories = cheds * 4
                
                if cheds == 1 {
                    cell.chedsEatenLabel.text = "\(cheds) Ched"
                } else {
                    cell.chedsEatenLabel.text = "\(cheds) Cheds"
                }
                
                cell.caloriesLabel.isHidden = false
                cell.caloriesLabel.text = "\(String(calories)) calories"
            }
            
        } else {
            if allSessionsGrouped.count > 0 {
                session = allSessionsGrouped[indexPath.section][indexPath.row]
                cell.session = session
                cell.caloriesLabel.isHidden = true
            } else {
                session = sessions[indexPath.row]
                cell.session = session
                cell.caloriesLabel.isHidden = true
            }
        }

        return cell
    }
}
