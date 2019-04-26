//
//  FinishedRunViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit
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
        
        milesLabel.text = "\(finishedRun.distance)"
        timeLabel.text = "\(finishedRun.duration)"
        paceLabel.text = "\(finishedRun.distance / Double(finishedRun.duration))"
    }
    
    func mapRegion() -> MKCoordinateRegion? {
        guard case let locations = finishedRun.locations, locations.locationsArray.count > 0 else{
            return nil
        }
        let latitudes = locations.locationsArray.map { location -> Double in
        let location = location as! Location
            return location.latitude
        }
        let longitudes = locations.locationsArray.map { location -> Double in
        let location = location as! Location
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
        guard case let locations = finishedRun.locations, locations.locationsArray.count > 0 else {
            return MKPolyline()
        }

        let coords: [CLLocationCoordinate2D] = locations.locationsArray.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    func loadMap() {
        guard case let locations = finishedRun.locations.locationsArray,
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

        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyLine())
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as! ViewController
//        if segue.identifier == "ReturnHome"{
//            destination.runs.runsArray.append(finishedRun)
//        }
//    }
    
    

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


