//
//  DateHelper.swift
//  Ched
//
//  Created by Eric Andersen on 2/8/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import Foundation

extension Date {
    
    var monthNum: Int { return Calendar.current.component(.month, from: self) }
    var monthFull: String  { return Formatter.monthFull.string(from: self) }
    var hour12:  String      { return Formatter.hour12.string(from: self) }
    
    
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    
    
    func stringValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "EEEE dd"
        
        return dateFormatter.string(from: self)
    }
}



extension Formatter {
    static let monthFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()
    static let hour12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        //        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
}
