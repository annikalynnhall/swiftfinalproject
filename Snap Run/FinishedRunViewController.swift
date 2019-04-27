//
//  FinishedRunViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import MapKit
import CoreLocation

class FinishedRunViewController: UIViewController {
    
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var finishedRun: Run!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMap()
        
        let formattedDistance = FormatDisplay.distance(Measurement(value: finishedRun.distance, unit: UnitLength.meters))
        let formattedTime = FormatDisplay.time(finishedRun.duration)
        let formattedPace = FormatDisplay.pace(distance: Measurement(value: finishedRun.distance, unit: UnitLength.meters),
                                               seconds: finishedRun.duration,
                                               outputUnit: UnitSpeed.minutesPerMile)
        milesLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        paceLabel.text = "\(formattedPace)"
    }
    
    func mapRegion() -> MKCoordinateRegion? {
        guard finishedRun.locations.locationsArray.count > 0 else{
            return nil
        }
        let locations = finishedRun.locations
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
        
        let locations = finishedRun.locations.locationsArray
        var coords: [CLLocationCoordinate2D] = []
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    func loadMap() {
        let locations = finishedRun.locations.locationsArray
        let region = mapRegion()

        mapView.setRegion(region!, animated: true)
        mapView.addOverlay(polyLine())
    }
    
    

    //ADD TO THIS FUNCTION to RETURN HOME
    @IBAction func saveRunPressed(_ sender: UIButton) {
        finishedRun.saveData() { success in
            if success {
                
            } else{
                print("Can't segue because of the error")
            }

        }
    }
    
    
    

}

extension FinishedRunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor(red: 108/255.0, green: 124/255.0, blue: 61/255.0, alpha: 1.0)
        renderer.lineWidth = 3
        return renderer
    }
}


