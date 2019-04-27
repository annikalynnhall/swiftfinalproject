//
//  Runs.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI


class Runs {
    var runsArray: [Run] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("runs").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                    return completed()
            }
            self.runsArray = []
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let run = Run(dictionary: document.data())
                run.documentID = document.documentID
                self.runsArray.append(run)
            }
            completed()
        }
    }

}
