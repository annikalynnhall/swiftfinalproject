//
//  Location.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
    
    var latitude: Double
    var longitude: Double
    var timeStamp: Date
    
    init(latitude: Double, longitude: Double, timeStamp: Date){
        self.latitude = latitude
        self.longitude = longitude
        self.timeStamp = Date()
    }
    
    convenience init(){
        self.init(latitude: 0.0, longitude: 0.0, timeStamp: Date())
    }
    
    
}
