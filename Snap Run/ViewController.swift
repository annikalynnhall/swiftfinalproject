//
//  ViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var newRunButton: UIButton!
    @IBOutlet weak var savedRunsButton: UIButton!
    
    var newRunX: CGFloat!
    var savedRunsY: CGFloat!
    //var runs = Runs()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRunX = newRunButton.frame.origin.x
        savedRunsY = savedRunsButton.frame.origin.y
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newRunButton.frame.origin.x = self.view.frame.width
        savedRunsButton.frame.origin.y = self.view.frame.height
        
        UIView.animate(withDuration: 1.0, delay: 1.0, animations:{self.newRunButton.frame.origin.x = self.newRunX})
        
        UIView.animate(withDuration: 1.0, delay: 1.5, animations:{self.savedRunsButton.frame.origin.y = self.savedRunsY})
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowTableView"{
//            let destination = segue.destination as! SavedRunsViewController
//            destination.runs = runs
//
//        }
//    }


}

