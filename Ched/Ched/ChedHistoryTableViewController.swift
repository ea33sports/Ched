//
//  ChedHistoryTableViewController.swift
//  Ched
//
//  Created by Eric Andersen on 2/12/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import UIKit

class ChedHistoryTableViewController: UITableViewController {
    
    // MARK: - Variables
    var sessions = ChedHistoryController.shared.chedSessions
    var allSessionsGrouped = [[ChedSession]]()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
        scrollToBottom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groupAllSessions()
    }
    
    
    
    // MARK: - Functions
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
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let section = self.allSessionsGrouped.count - 1
            let item = self.allSessionsGrouped[section].count - 1
            let indexPath = IndexPath(item: item, section: section)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
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
        
        let headerLabel = UILabel(frame: CGRect(x: 24, y: 48, width: (tableView.bounds.size.width - 60), height: 80))
        headerLabel.font = UIFont(name: "Avenir Next", size: 50)
        headerLabel.textColor = #colorLiteral(red: 0.5176470588, green: 0.7803921569, blue: 0.6431372549, alpha: 1)
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as? MyChedSessionsTableViewCell else { return UITableViewCell() }
        let session: ChedSession

        // Configure the cell...
        if allSessionsGrouped.count > 0 {
            session = allSessionsGrouped[indexPath.section][indexPath.row]
        } else {
            session = sessions[indexPath.row]
        }
        
        cell.session = session

        return cell
    }
}
