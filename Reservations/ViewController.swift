//
//  ViewController.swift
//  Reservations
//
//  Created by Chen Shi on 2/21/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, sendScheduleBackDelegate {
    
    @IBOutlet var tableViewMyReservation : UITableView!
    @IBOutlet var addReservationBarButton: UIBarButtonItem!
    
    var arrayReservation: NSMutableArray = NSMutableArray()
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cellReservations"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableViewMyReservation.delegate = self
        tableViewMyReservation.dataSource = self
        
        self.loadData()
        addReservationBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonAddReservation))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
//        let dictReservation = ["ReservationDate" : "Monday, March 26, 2016", "ReservationTime" : "2:00 PM", "ServiceTitle" : "Gel Manicure", "PartySize" : "1", "Duration" : "30M", "ServiceDescription" : "Get the upper hand with our chip-resistant, mirror-finish gel polish that requires no drying time and last up to two weeks."];
//        arrayReservation.add(dictReservation);
        let defaults = UserDefaults.standard
        let array = defaults.array(forKey: "SavedObjArray") ?? []
        arrayReservation = NSMutableArray.init(array: array)
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(arrayReservation, forKey: "SavedObjArray")
    }
    
    //MARK: Tableview Datasource methods
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayReservation.count;
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let mainReservationCell = tableViewMyReservation.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MainReservationTableViewCell
        
        let dictReservationData = arrayReservation[indexPath.row]
        mainReservationCell .configureCellData(dictReservation: dictReservationData as! NSDictionary, nIndexPath: indexPath.row)
        
        return mainReservationCell
    }
    
    //MARK: Button Action
    @objc func barButtonAddReservation(sender:AnyObject){
        performSegue(withIdentifier: "SpaServicesSegueIdentifier", sender: sender)
    }
    
    //MARK: Delegate Method
    
    func sendScheduleToTable(dictSchedule: NSDictionary) {
        arrayReservation.add(dictSchedule)
        self.saveData()
        tableViewMyReservation.reloadData()
    }
    
    //MARK: Storyboard methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "SpaServicesSegueIdentifier" == segue.identifier {
            let vc = segue.destination as! SPAServicesViewController
            vc.scheduleDelegate = self
        }
    }
}

