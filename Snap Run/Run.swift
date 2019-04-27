//
//  Run.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI
import MapKit

class Run {
    
    
    var distance: Double
    var duration: Int
    var pace: Double
    var date: Date
    var locations: Locations
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["distance": distance, "duration": duration, "pace":
            pace, "date": date, "locations":
            locations, "postingUserID": postingUserID]
    }

    
    
    init(distance: Double, duration: Int, pace: Double, date: Date, locations: Locations, postingUserID: String, documentID: String){
        self.distance = distance
        self.duration = duration
        self.pace = pace
        self.date = date
        self.locations = locations
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]){
        let distance = dictionary["distance"] as! Double? ?? 0.0
        let duration = dictionary["duration"] as! Int? ?? 0
        let pace = dictionary["pace"] as! Double? ?? 0.0
        let date = dictionary["date"] as! Date
        let locations = dictionary["locations"] as! Locations
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(distance: distance, duration: duration, pace: pace, date: date, locations: locations, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("runs").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("runs").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
    
}
