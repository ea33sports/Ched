//
//  ChedHistoryController.swift
//  Ched
//
//  Created by Eric Andersen on 2/8/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import Foundation
import CoreData

class ChedHistoryController {
    
    // MARK: - Initialization
    static let shared = ChedHistoryController()
    
    
    
    // MARK: - Variables
    var myChedHistory: ChedHistory?
    
    var chedSessions: [ChedSession] {
        let moc = CoreDataStack.context
        let fetchRequest: NSFetchRequest<ChedSession> = ChedSession.fetchRequest()
        return (try? moc.fetch(fetchRequest)) ?? []
    }
    
    
    
    // MARK: - CRUD
    func initializeHistory() {
        myChedHistory = ChedHistory(dailyCheds: 0, weeklyCheds: 0, monthlyCheds: 0, yearlyCheds: 0, referenceDay: Date(), referenceWeek: Date(), referenceMonth: Date(), referenceYear: Date())
        saveToPersistentStore()
    }
    
    
    func updateHistory(todaysCheds: Int, thisWeeksCheds: Int, thisMonthsCheds: Int, thisYearsCheds: Int, referenceDay: Date, referenceWeek: Date, referenceMonth: Date, referenceYear: Date) {
        
        guard let myChedHistory = myChedHistory else { fatalError() }
        myChedHistory.dailyCheds = Int64(todaysCheds)
        myChedHistory.weeklyCheds = Int64(thisWeeksCheds)
        myChedHistory.monthlyCheds = Int64(thisMonthsCheds)
        myChedHistory.yearlyCheds = Int64(thisYearsCheds)
        
        myChedHistory.referenceDay = referenceDay
        myChedHistory.referenceWeek = referenceWeek
        myChedHistory.referenceMonth = referenceMonth
        myChedHistory.referenceYear = referenceYear
        
        saveToPersistentStore()
    }
    
    
    
    // MARK: - Fetch
    let fetchedResultsController: NSFetchedResultsController<ChedHistory> = {
        let fetchRequest: NSFetchRequest<ChedHistory> = ChedHistory.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dailyCheds", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    
    
    // MARK: - Save
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("***Error saving Managed Object Context. Items not saved.")
        }
    }
}
