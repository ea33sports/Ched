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
    @IBOutlet weak var calorieButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var chedsEatenLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!    
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
    var calories = 0
    var caloMode = false
    
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
//        self.totalChedsCollectionView.register(TotalChedsCollectionViewCell.self, forCellWithReuseIdentifier: "dailyChedsCell")
//        self.totalChedsCollectionView.register(TotalChedsCollectionViewCell.self, forCellWithReuseIdentifier: "weeklyChedsCell")
//        self.totalChedsCollectionView.register(TotalChedsCollectionViewCell.self, forCellWithReuseIdentifier: "monthlyChedsCell")
//        self.totalChedsCollectionView.register(TotalChedsCollectionViewCell.self, forCellWithReuseIdentifier: "yearlyChedsCell")
        
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
            var referenceYear = ChedHistoryController.shared.myChedHistory?.referenceYear else { return }
        
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
        calorieLabel.isHidden = true
        
//        dropDownbutton.setTitle("\(myHistory.dailyCheds)", for: .normal)
        historyButton.setImage(#imageLiteral(resourceName: "timeTable"), for: .normal)
        calorieButton.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
        historyButton.imageView?.contentMode = .scaleAspectFit
        calorieButton.imageView?.contentMode = .scaleAspectFit
        
        historyButton.layer.masksToBounds = false
        historyButton.layer.cornerRadius = historyButton.frame.height / 8
        historyButton.clipsToBounds = true
        
        viewHistoryButton.layer.masksToBounds = false
        viewHistoryButton.layer.cornerRadius = viewHistoryButton.frame.height / 8
        viewHistoryButton.clipsToBounds = true
        
        if chedding == 0 {
            chedsEatenLabel.text = "CHED"
            calorieButton.isEnabled = false
        }
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
    
    
    func toggleSessionCalories() {
        if caloMode == false {
            caloMode = true
            calorieButton.setImage(#imageLiteral(resourceName: "heartFull"), for: .normal)
            calorieLabel.isHidden = false
            addChedButton.isHidden = true
            chedsEatenLabel.text = String(updatedCalories(currentCheds: chedding))
        } else {
            caloMode = false
            calorieButton.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
            calorieLabel.isHidden = true
            addChedButton.isHidden = false
            chedsEatenLabel.text = String(chedding)
        }
    }
    
    
    func cancelToggleSessionCalories() {
        calorieLabel.isHidden = true
    }
    
    
    func toggleDropdownCalories() {
        let dropDownCell = cell as? TotalChedsCollectionViewCell
        if caloMode == false {
            caloMode = true
            calorieButton.setImage(#imageLiteral(resourceName: "heartFull"), for: .normal)
            dropDownCell?.caloriesLabel.isHidden = false
            addChedButton.isHidden = true
            chedsEatenLabel.text = String(updatedCalories(currentCheds: chedding))
        } else {
            caloMode = false
            calorieButton.setImage(#imageLiteral(resourceName: "heartEmpty"), for: .normal)
            dropDownCell?.caloriesLabel.isHidden = true
            addChedButton.isHidden = false
            chedsEatenLabel.text = String(chedding)
        }
    }
    
    
    func updatedCalories(currentCheds: Int) -> Int {
        var calories = 0
        calories = currentCheds * 4
        return calories
    }
    
    
    func toggleDropDown() {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory else { return }
        
        if dropDownView.isHidden {
            
            totalChedsCollectionView.reloadData()
            
            UIView.animate(withDuration: 0.5) {
                self.chedsEatenLabel.isHidden = true
                self.chedsEatenLabel.alpha = 0
                self.calorieLabel.isHidden = true
                self.dropDownView.isHidden = false
                self.dropDownView.slideInFromTop()
                self.dropDownView.alpha = 1
                self.calorieButton.isEnabled = true
                self.addChedButton.alpha = 0
                self.addChedButton.isHidden = true
                UIView.performWithoutAnimation {
                    self.historyButton.setImage(#imageLiteral(resourceName: "timeTableHighlighted2"), for: .normal)
                    self.historyButton.imageView?.contentMode = .scaleAspectFit
                }
                self.historyButton.imageView?.tintColor = #colorLiteral(red: 0.168627451, green: 0.168627451, blue: 0.168627451, alpha: 1)
            }
            
        } else {
            UIView.animate(withDuration: 0.1) {
                self.dropDownView.isHidden = true
                self.dropDownView.slideBack()
                self.dropDownView.alpha = 0
                self.chedsEatenLabel.isHidden = false
                self.chedsEatenLabel.alpha = 1
                self.calorieLabel.isHidden = false
                self.addChedButton.alpha = 1
                self.addChedButton.isHidden = false
                self.calorieLabel.isEnabled = true
                UIView.performWithoutAnimation {
                    self.historyButton.setImage(#imageLiteral(resourceName: "timeTable"), for: .normal)
//                    self.dropDownbutton.setImage(UIImage(), for: .normal)
//                    self.dropDownbutton.setTitle("\(myHistory.dailyCheds)", for: .normal)
                }
            }
            
            totalChedsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            updateView()
        }
    }
    
    
    func resetView() {
        
        guard let myHistory = ChedHistoryController.shared.myChedHistory else { return }
        dropDownView.isHidden = true
        dropDownView.alpha = 0
        historyButton.setImage(#imageLiteral(resourceName: "timeTable"), for: .normal)
        chedsEatenLabel.isHidden = false
        chedsEatenLabel.alpha = 1
        addChedButton.alpha = 1
        addChedButton.isHidden = false
        
        if chedding == 0 {
            chedsEatenLabel.text = "CHED"
            calorieButton.isEnabled = false
        }
        
        if chedsEatenLabel.text == "CHED" {
            calorieButton.isEnabled = false
        } else {
            calorieButton.isEnabled = true
        }
    }
    
    
    
    // MARK: - IBActions
    @IBAction func calorieButtonTapped(_ sender: UIButton) {
        
        if dropDownView.isHidden {
            toggleSessionCalories()
        } else {
            cancelToggleSessionCalories()
            toggleDropdownCalories()
        }
        
        totalChedsCollectionView.reloadData()
    }
    
    
    @IBAction func historyButtonTapped(_ sender: UIButton) {
        toggleDropDown()
    }
    
    @IBAction func addChedButtonTapped(_ sender: UIButton) {
        
        UIButton.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            guard let myHistory = ChedHistoryController.shared.myChedHistory else { return }
            self.calorieButton.isEnabled = true
            self.updateCheds()
            self.updateChedHistory()
//            self.dropDownbutton.setTitle("\(myHistory.dailyCheds)", for: .normal)
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
        
        if caloMode == false {
            if indexPath.item == 0 {
                guard let dailyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                dailyCell.chedsPerTimeLabel.text = "Today"
                dailyCell.totalChedsLabel.text = String(myHistory.dailyCheds)
                dailyCell.caloriesLabel.isHidden = true
                cell = dailyCell
                
            } else if indexPath.item == 1 {
                guard let weeklyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                weeklyCell.chedsPerTimeLabel.text = "This Week"
                weeklyCell.totalChedsLabel.text = String(myHistory.weeklyCheds)
                weeklyCell.caloriesLabel.isHidden = true
                cell = weeklyCell
                
            } else if indexPath.item == 2 {
                guard let monthlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                monthlyCell.chedsPerTimeLabel.text = "This Month"
                monthlyCell.totalChedsLabel.text = String(myHistory.monthlyCheds)
                monthlyCell.caloriesLabel.isHidden = true
                cell = monthlyCell
                
            } else if indexPath.item == 3 {
                guard let yearlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                yearlyCell.chedsPerTimeLabel.text = "This Year"
                yearlyCell.totalChedsLabel.text = String(myHistory.yearlyCheds)
                yearlyCell.caloriesLabel.isHidden = true
                cell = yearlyCell
            }
            
        } else {
            
            if indexPath.item == 0 {
                guard let dailyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                dailyCell.chedsPerTimeLabel.text = "Today"
                dailyCell.totalChedsLabel.text = String(updatedCalories(currentCheds: Int(myHistory.dailyCheds)))
                dailyCell.caloriesLabel.isHidden = false
                cell = dailyCell
                
            } else if indexPath.item == 1 {
                guard let weeklyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                weeklyCell.chedsPerTimeLabel.text = "This Week"
                weeklyCell.totalChedsLabel.text = String(updatedCalories(currentCheds: Int(myHistory.weeklyCheds)))
                weeklyCell.caloriesLabel.isHidden = false
                cell = weeklyCell
                
            } else if indexPath.item == 2 {
                guard let monthlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                monthlyCell.chedsPerTimeLabel.text = "This Month"
                monthlyCell.totalChedsLabel.text = String(updatedCalories(currentCheds: Int(myHistory.monthlyCheds)))
                monthlyCell.caloriesLabel.isHidden = false
                cell = monthlyCell
                
            } else if indexPath.item == 3 {
                guard let yearlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "totalChedsCell", for: indexPath) as? TotalChedsCollectionViewCell else { return UICollectionViewCell() }
                yearlyCell.chedsPerTimeLabel.text = "This Year"
                yearlyCell.totalChedsLabel.text = String(updatedCalories(currentCheds: Int(myHistory.yearlyCheds)))
                yearlyCell.caloriesLabel.isHidden = false
                cell = yearlyCell
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        totalChedsPageControl.currentPage = indexPath.row
    }
}
