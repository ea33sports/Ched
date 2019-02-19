//
//  ChedViewController.swift
//  Ched
//
//  Created by Eric Andersen on 2/8/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import UIKit
import CoreData

class ChedViewController: UIViewController, NSFetchedResultsControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var dropDownbutton: UIButton!
    @IBOutlet weak var dropDownButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var dropDownViewYAlignment: NSLayoutConstraint!
    @IBOutlet weak var chedsEatenLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var totalChedsCollectionView: UICollectionView!
    @IBOutlet weak var totalChedsPageControl: UIPageControl!
    @IBOutlet weak var viewHistoryButton: UIButton!
    @IBOutlet weak var addChedButton: UIButton!
    
    
    
    // MARK: - Variables
    let now = Date()
    
    var updatedDailyCheds = 0
    var updatedWeeklyCheds = 0
    var updatedMonthlyCheds = 0
    var updatedYearlyCheds = 0
    
    var chedding = 0
    
    var cell = UICollectionViewCell()
    var selectedHistoryCell = 0
    
    var animating = false
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = ZoomAndSnapFlowLayout()
        ChedHistoryController.shared.fetchedResultsController.delegate = self
        totalChedsCollectionView.delegate = self
        totalChedsCollectionView.dataSource = self
        totalChedsCollectionView.collectionViewLayout = flowLayout
        
        setupMyHistory()
        configureDate()
        updateView()
        
        dropDownView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        resetView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    // MARK: - Functions
   func setupMyHistory() {
        do {
            try ChedHistoryController.shared.fetchedResultsController.performFetch()
        } catch {
            print("❌ Error fetching with FetchResultsController: \(error) \(error.localizedDescription)")
        }
        
        if let myHistory = ChedHistoryController.shared.fetchedResultsController.fetchedObjects?.first {
            ChedHistoryController.shared.myChedHistory = myHistory
        } else {
            ChedHistoryController.shared.initializeHistory()
        }
    }
    
    
    func configureDate() {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory,
            var referenceDay = ChedHistoryController.shared.myChedHistory?.referenceDay,
            var referenceWeek = ChedHistoryController.shared.myChedHistory?.referenceWeek,
            var referenceMonth = ChedHistoryController.shared.myChedHistory?.referenceMonth,
            var referenceYear = ChedHistoryController.shared.myChedHistory?.referenceYear else { fatalError() }
        
        if now.isInSameDay(date: referenceDay) {
            updatedDailyCheds = Int(myHistory.dailyCheds)
        } else {
            referenceDay = now
            myHistory.dailyCheds = 0
        }
        
        if now.isInSameWeek(date: referenceWeek) {
            updatedWeeklyCheds = Int(myHistory.weeklyCheds)
        } else {
            referenceWeek = now
            myHistory.weeklyCheds = 0
        }
        
        if now.isInSameMonth(date: referenceMonth) {
            updatedMonthlyCheds = Int(myHistory.monthlyCheds)
        } else {
            referenceMonth = now
            myHistory.monthlyCheds = 0
        }
        
        if now.isInSameYear(date: referenceYear) {
            updatedYearlyCheds = Int(myHistory.yearlyCheds)
        } else {
            referenceYear = now
            myHistory.yearlyCheds = 0
        }
        
        ChedHistoryController.shared.updateHistory(todaysCheds: Int(myHistory.dailyCheds), thisWeeksCheds: Int(myHistory.weeklyCheds), thisMonthsCheds: Int(myHistory.monthlyCheds), thisYearsCheds: Int(myHistory.yearlyCheds), referenceDay: referenceDay, referenceWeek: referenceWeek, referenceMonth: referenceMonth, referenceYear: referenceYear)
    }
    
    
    func updateView() {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory else { return }
        view.addVerticalGradientLayer(topColor: #colorLiteral(red: 1, green: 0.7333333333, blue: 0.3490196078, alpha: 1), bottomColor: #colorLiteral(red: 0.5176470588, green: 0.7803921569, blue: 0.6431372549, alpha: 1))
        chedsEatenLabel.text = "CHED"
        dropDownbutton.setTitle("\(myHistory.dailyCheds)", for: .normal)
        
        dropDownbutton.layer.masksToBounds = false
        dropDownbutton.layer.cornerRadius = dropDownbutton.frame.height / 8
        dropDownbutton.clipsToBounds = true
        
        viewHistoryButton.layer.masksToBounds = false
        viewHistoryButton.layer.cornerRadius = viewHistoryButton.frame.height / 8
        viewHistoryButton.clipsToBounds = true
    }
    
    
    func updateCheds() {
        
        chedding += 1
        chedsEatenLabel.text = String(chedding)
        
        if chedding == 1 {
            ChedSessionController.shared.createSession(session: now)
            ChedSessionController.shared.updateSession(chedsEaten: chedding)
        } else {
            ChedSessionController.shared.updateSession(chedsEaten: chedding)
        }
    }
    
    
    func updateChedHistory() {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory,
            let referenceDay = ChedHistoryController.shared.myChedHistory?.referenceDay,
            let referenceWeek = ChedHistoryController.shared.myChedHistory?.referenceWeek,
            let referenceMonth = ChedHistoryController.shared.myChedHistory?.referenceMonth,
            let referenceYear = ChedHistoryController.shared.myChedHistory?.referenceYear else { return }
        
        myHistory.dailyCheds += 1
        myHistory.weeklyCheds += 1
        myHistory.monthlyCheds += 1
        myHistory.yearlyCheds += 1

        ChedHistoryController.shared.updateHistory(todaysCheds: Int(myHistory.dailyCheds), thisWeeksCheds: Int(myHistory.weeklyCheds), thisMonthsCheds: Int(myHistory.monthlyCheds), thisYearsCheds: Int(myHistory.yearlyCheds), referenceDay: referenceDay, referenceWeek: referenceWeek, referenceMonth: referenceMonth, referenceYear: referenceYear)
    }
    
    
    func toggleDropDown() {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory  else { return }
        
        if dropDownView.isHidden {
            
            totalChedsCollectionView.reloadData()
            
            UIView.animate(withDuration: 0.5) {
                self.chedsEatenLabel.isHidden = true
                self.chedsEatenLabel.alpha = 0
                self.dropDownView.isHidden = false
                self.dropDownView.slideInFromTop()
                self.dropDownView.alpha = 1
                self.addChedButton.alpha = 0
                self.addChedButton.isHidden = true
                self.dropDownbutton.setImage(#imageLiteral(resourceName: "backUp"), for: .normal)
                self.dropDownbutton.imageView?.contentMode = .scaleAspectFit
                self.dropDownbutton.imageView?.tintColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            }
            
        } else {
            UIView.animate(withDuration: 0.1) {
                self.dropDownView.isHidden = true
                self.dropDownView.slideBack()
                self.dropDownView.alpha = 0
                self.chedsEatenLabel.isHidden = false
                self.chedsEatenLabel.alpha = 1
                self.addChedButton.alpha = 1
                self.addChedButton.isHidden = false
                self.dropDownbutton.setImage(nil, for: .normal)
                self.dropDownbutton.setTitle("\(myHistory.dailyCheds)", for: .normal)
            }
            totalChedsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        }
    }
    
    
    func resetView() {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory else { return }
        dropDownView.isHidden = true
        dropDownView.alpha = 0
        chedsEatenLabel.isHidden = false
        chedsEatenLabel.alpha = 1
        addChedButton.alpha = 1
        addChedButton.isHidden = false
        dropDownbutton.setImage(nil, for: .normal)
        dropDownbutton.setTitle("\(myHistory.dailyCheds)", for: .normal)
    }
    
    
    
    // MARK: - IBActions
    @IBAction func dropDownButtonTapped(_ sender: UIButton) {
        toggleDropDown()
    }
    
    @IBAction func addChedButtonTapped(_ sender: UIButton) {
        
        UIButton.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            guard let myHistory = ChedHistoryController.shared.myChedHistory else { return }
            self.updateCheds()
            self.updateChedHistory()
            self.dropDownbutton.setTitle("\(myHistory.dailyCheds)", for: .normal)
        }) { (finish) in
            UIButton.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                sender.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}



extension ChedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return totalChedsCollectionView.bounds.size
    }


    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }


    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory else { fatalError() }
        
        if indexPath.row == 0 {
            guard let dailyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
            dailyCell.chedsPerTimeLabel.text = "Today"
            dailyCell.totalChedsLabel.text = String(myHistory.dailyCheds)
//            dailyCell.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            cell = dailyCell
            
        } else if indexPath.row == 1 {
            guard let weeklyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
            weeklyCell.chedsPerTimeLabel.text = "This Week"
            weeklyCell.totalChedsLabel.text = String(myHistory.weeklyCheds)
//            weeklyCell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell = weeklyCell
            
        } else if indexPath.row == 2 {
            guard let monthlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
            monthlyCell.chedsPerTimeLabel.text = "This Month"
            monthlyCell.totalChedsLabel.text = String(myHistory.monthlyCheds)
//            monthlyCell.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell = monthlyCell
            
        } else if indexPath.row == 3 {
            guard let yearlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
            yearlyCell.chedsPerTimeLabel.text = "This Year"
            yearlyCell.totalChedsLabel.text = String(myHistory.yearlyCheds)
//            yearlyCell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            cell = yearlyCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        totalChedsPageControl.currentPage = indexPath.row
    }
}
