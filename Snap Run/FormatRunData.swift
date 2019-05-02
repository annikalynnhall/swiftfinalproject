//
//  FormatRunData.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/28/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import Foundation
struct FormatRunData {
    
    static func formatTime(seconds: Int) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    static func formatDistance(distance: Double)-> String{
        let formatString = "%.2f"
        let milesDistance = distance * 0.000621371192
        return String(format: formatString, milesDistance)
    }
    static func formatPace(distance: Double, time: Double)->String {
        let formatString = "%.2f"
        let speedMagnitude = time != 0 ? (distance) / time: 0.00
        return String(format: formatString, speedMagnitude)
    }
    
}
