//
//  NewRunViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import MapKit

class NewRunViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var startRunButton: UIButton!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var viewRunDetailsButton: UIButton!
    
    let locationManager = LocationManager.shared
    var timer: Timer?
    var seconds = 0
    var distance = Measurement(value: 0.0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    var run: Run?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowHome", sender: (Any).self)
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if startRunButton.titleLabel?.text == "START"{
            startRun()
            startRunButton.setTitle("STOP", for: .normal)
            view.backgroundColor = UIColor(red: 124/255.0, green: 71/255.0, blue: 60/255.0, alpha: 1.0)
            navigationBar.isHidden = true
        } else if startRunButton.titleLabel?.text == "STOP"{
            endRun()
            navigationBar.isHidden = false
            navigationBar.barTintColor = UIColor(red: 124/255.0, green: 71/255.0, blue: 60/255.0, alpha: 1.0)
            viewRunDetailsButton.isHidden = false
            startRunButton.isHidden = true
 
        } else {
            performSegue(withIdentifier: "ShowFinishedRun", sender: (Any).self)
        }
    }
    
    func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func startRun() {
        seconds = 0
        distance = Measurement(value: 0.0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
        
    }
    
    func endRun() {
        saveRun()
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        
    }
    
    func saveRun(){
        let newRun = Run(distance: distance.value, duration: seconds, pace: distance.value / Double(seconds), latitudes: [Double](), longitudes: [Double](), postingUserID: "", documentID: "")
        for location in locationList {
            let locationObject = Location()
            locationObject.timeStamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            
            newRun.latitudes.append(locationObject.latitude)
            newRun.longitudes.append(locationObject.longitude)
        }
        run = newRun
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        milesLabel.text = "\(formattedDistance)"
        timeLabel.text = "\(formattedTime)"
        paceLabel.text = "\(formattedPace)"
        
    }
    
    func configureView(){
        startRunButton.isHidden = false
        viewRunDetailsButton.isHidden = true
        view.backgroundColor = UIColor(red: 108/255.0, green: 124/255.0, blue: 61/255.0, alpha: 1.0)
        startRunButton.setTitle("START", for: .normal)
        navigationBar.isHidden = false
        navigationBar.barTintColor = UIColor(red: 108/255.0, green: 124/255.0, blue: 61/255.0, alpha: 1.0)
        milesLabel.text = "0.00"
        timeLabel.text = "00:00"
        paceLabel.text = "0'00\""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinishedRun"{
            let destination = segue.destination as! FinishedRunViewController
            destination.finishedRun = run!
        }
    }
    
}

extension NewRunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let timeSinceUpdated = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(timeSinceUpdated) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            locationList.append(newLocation)
        }
    }

}
