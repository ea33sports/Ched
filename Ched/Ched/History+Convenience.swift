//
//  History+Convenience.swift
//  Ched
//
//  Created by Eric Andersen on 2/8/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import Foundation
import CoreData

extension ChedHistory {
    
    @discardableResult
    convenience init(dailyCheds: Int, weeklyCheds: Int, monthlyCheds: Int, yearlyCheds: Int, referenceDay: Date, referenceWeek: Date, referenceMonth: Date, referenceYear: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.dailyCheds = Int64(dailyCheds)
        self.weeklyCheds = Int64(weeklyCheds)
        self.monthlyCheds = Int64(monthlyCheds)
        self.yearlyCheds = Int64(yearlyCheds)
        
        self.referenceDay = referenceDay
        self.referenceWeek = referenceWeek
        self.referenceMonth = referenceMonth
        self.referenceYear = referenceYear
    }
}
