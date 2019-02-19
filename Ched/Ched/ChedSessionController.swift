//
//  ChedSessionController.swift
//  Ched
//
//  Created by Eric Andersen on 2/8/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import Foundation
import CoreData

class ChedSessionController {
    
    // MARK: - Initialize
    static var shared = ChedSessionController()
    
    
    
    // MARK: - Variables
    var thisChedSession: ChedSession?
    
    
    
    // MARK: - CRUD
    func createSession(session: Date) {
        self.thisChedSession = ChedSession(session: session, chedsEaten: 0)
        ChedHistoryController.shared.saveToPersistentStore()
    }
    
    
    func updateSession(chedsEaten: Int) {
        guard let thisSession = thisChedSession else { fatalError() }
        thisSession.chedsEaten = Int64(chedsEaten)
        ChedHistoryController.shared.saveToPersistentStore()
    }
    
    func cancelSession() {
        guard let thisSession = thisChedSession else { fatalError() }
        thisSession.managedObjectContext?.delete(thisSession)
        ChedHistoryController.shared.saveToPersistentStore()
    }
    
    func deleteAllSessions() {
        var sessions = ChedHistoryController.shared.chedSessions
        for session in sessions {
            session.managedObjectContext?.delete(session)
            ChedHistoryController.shared.saveToPersistentStore()
        }
        sessions.removeAll()
        ChedHistoryController.shared.saveToPersistentStore()
    }
}
