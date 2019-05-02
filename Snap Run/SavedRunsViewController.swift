//
//  SavedRunsViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase


class SavedRunsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var runs = Runs()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        runs.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PastRunViewController
        if segue.identifier == "ShowRunDetail"{
            let selectedIndex = tableView.indexPathForSelectedRow!
            destination.run = runs.runsArray[selectedIndex.row]
        }
    }
    
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    

}

extension SavedRunsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.runsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(runs.runsArray[indexPath.row].runName)"
        cell.textLabel?.textColor = UIColor(red: 108/255.0, green: 124/255.0, blue: 61/255.0, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Avenir Next Condensed", size: 20)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        return cell
    }
    
    
}


