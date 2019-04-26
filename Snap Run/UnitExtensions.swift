//
//  UnitExtensions.swift
//  
//
//  Created by Annika Lynn Nordstrom Hall on 4/26/19.
//

import UIKit

class UnitPaceConverter: UnitConverter {
    let coefficient: Double
    
    init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        return reciprocal(value * coefficient)
    }
    
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return reciprocal(baseUnitValue * coefficient)
    }
    
    func reciprocal(_ value: Double) -> Double {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }

}
extension UnitSpeed {
    class var secondsPerMeter: UnitSpeed {
        return UnitSpeed(symbol: "", converter: UnitPaceConverter(coefficient: 1))
    }
    
    class var minutesPerKilometer: UnitSpeed {
        return UnitSpeed(symbol: "", converter: UnitPaceConverter(coefficient: 60.0 / 1000.0))
    }
    
    class var minutesPerMile: UnitSpeed {
        return UnitSpeed(symbol: "", converter: UnitPaceConverter(coefficient: 60.0 / 1609.34))
    }
}
