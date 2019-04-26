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
        
        loadMap()
        
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
    
    func mapRegion() -> MKCoordinateRegion? {
        guard run.locations.locationsArray.count > 0 else{
            return nil
        }
        let locations = run.locations
        let latitudes = locations.locationsArray.map { location -> Double in
            return location.latitude
        }
        let longitudes = locations.locationsArray.map { location -> Double in
            return location.longitude
        }
        
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
        
    }
    
    
    func polyLine() -> MKPolyline {
        guard run.locations.locationsArray.count > 0 else {
            return MKPolyline()
        }
        let locations = run.locations
        let coords: [CLLocationCoordinate2D] = locations.locationsArray.map { location in
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    func loadMap() {
        guard case let locations = run.locations.locationsArray,
            locations.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Error",
                                              message: "Sorry, this run has no locations saved",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        pathMapView.setRegion(region, animated: true)
        pathMapView.addOverlay(polyLine())
    }

}
