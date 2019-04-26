//
//  PastRunViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PastRunViewController: UIViewController {
    
    
    @IBOutlet weak var pathMapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    
    var run: Run!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formattedDistance = FormatDisplay.distance(Measurement(value: run.distance, unit: UnitLength.meters))
        let formattedTime = FormatDisplay.time(run.duration)
        let formattedPace = FormatDisplay.pace(distance: Measurement(value: run.distance, unit: UnitLength.meters),
                                               seconds: run.duration,
                                               outputUnit: UnitSpeed.minutesPerMile)
        distanceLabel.text = "\(formattedDistance)"
        durationLabel.text = "\(formattedTime)"
        paceLabel.text = "\(formattedPace)"
        
        distanceLabel.text = "\(run.distance)"
        durationLabel.text = "\(run.duration)"
        paceLabel.text = "\(run.distance / Double(run.duration))"

    }

}
