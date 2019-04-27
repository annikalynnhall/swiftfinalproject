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
    }
    
    func mapRegion() -> MKCoordinateRegion? {
        guard run.latitudes.count > 0 else{
            return nil
        }
        var latitudes = run.latitudes
        var longitudes = run.longitudes
        
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
        var latitudes = run.latitudes
        var longitudes = run.longitudes
        var coords: [CLLocationCoordinate2D] = []
        for i in 0 ..< latitudes.count {
            coords.append(CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i]))
        }
        
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    func loadMap() {
        
        let region = mapRegion()
        if region != nil {
            pathMapView.setRegion(region!, animated: true)
            pathMapView.addOverlay(polyLine())
        }
        
    }
}

extension PastRunViewController: MKMapViewDelegate {
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
