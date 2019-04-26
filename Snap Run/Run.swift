//
//  Run.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import Foundation

class Run {
    
    
    var distance: Double
    var duration: Int
    var pace: Double
    var pathImage: String
    var date: Date
    var locations: Locations
    
    
    init(distance: Double, duration: Int, pace: Double, pathImage: String, date: Date, locations: Locations){
        self.distance = distance
        self.duration = duration
        self.pace = pace
        self.pathImage = ""
        self.date = Date()
        self.locations = Locations()
    }
    
    convenience init(){
        self.init(distance: 0.0, duration: 0, pace: 0, pathImage: "", date: Date(), locations: Locations())
    }
    
}
