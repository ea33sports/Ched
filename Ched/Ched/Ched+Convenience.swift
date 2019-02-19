//
//  Ched+Convenience.swift
//  Ched
//
//  Created by Eric Andersen on 2/8/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import Foundation
import CoreData

extension ChedSession {
    
    @discardableResult
    convenience init(session: Date, chedsEaten: Int, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.session = session
        self.chedsEaten = Int64(chedsEaten)
    }
}
