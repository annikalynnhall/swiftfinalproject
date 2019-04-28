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
import CoreLocation

class Run {
    
    var runName: String
    var distance: Double
    var duration: Int
    var pace: Double
    var latitudes: [Double]
    var longitudes: [Double]
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["runName": runName,"distance": distance, "duration": duration, "pace":
            pace, "latitudes":
            latitudes, "longitudes": longitudes, "postingUserID": postingUserID]
    }

    
    
    init(runName: String, distance: Double, duration: Int, pace: Double, latitudes: [Double], longitudes: [Double], postingUserID: String, documentID: String){
        self.runName = runName
        self.distance = distance
        self.duration = duration
        self.pace = pace
        self.latitudes = latitudes
        self.longitudes = longitudes
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]){
        let runName = dictionary["runName"] as! String
        let distance = dictionary["distance"] as! Double? ?? 0.0
        let duration = dictionary["duration"] as! Int? ?? 0
        let pace = dictionary["pace"] as! Double? ?? 0.0
        let latitudes = dictionary["latitudes"] as! [Double]? ?? []
        let longitudes = dictionary["longitudes"] as! [Double]? ?? []
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(runName: runName, distance: distance, duration: duration, pace: pace, latitudes: latitudes, longitudes: longitudes, postingUserID: postingUserID, documentID: "")
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
