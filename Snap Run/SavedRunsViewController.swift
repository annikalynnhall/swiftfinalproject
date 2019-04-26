//
//  SavedRunsViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit

class SavedRunsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var runs = Runs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PastRunViewController
        if segue.identifier == "ShowRunDetail"{
            let selectedIndex = tableView.indexPathForSelectedRow!
            destination.run = runs.runsArray[selectedIndex.row]
        }
    }
    

}

extension SavedRunsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.runsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(runs.runsArray[indexPath.row].date)"
        return cell
    }
    
    
}