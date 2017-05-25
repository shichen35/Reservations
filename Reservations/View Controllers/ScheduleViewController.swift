//
//  ScheduleViewController.swift
//  Reservations
//
//  Created by Chen Shi on 2/22/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import UIKit

protocol sendScheduleBackDelegate {
    func sendScheduleToTable(dictSchedule: NSDictionary)
}

class TimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var checkView: UIView!
}

class ScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate {

    var scheduleDelegate: sendScheduleBackDelegate?
    @IBOutlet var dateCollectionView: UICollectionView!
    @IBOutlet var timeCollectionView: UICollectionView!
    @IBOutlet var btnReserve: UIButton!
    @IBOutlet var txtPartySize: UITextField!
    @IBOutlet weak var lblMonth: UILabel!
    
    var isDateTimeSelected = false
    var selectedTime: String!
    var iSelectedIndex = -1
    var dateMinimum: Date!
    var dateMaximum: Date!
    
    var calendar: Calendar = .current
    var arrayDates: [Date]! = []
    var currentDate = Date()
    
    let dateCellReuseIdentifier = "dateCellSchedule"
    let timeCellReuseIdentifier = "timeCellSchedule"
    
    let arrayScheduleTime: NSArray = ["09:00 AM","10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 AM","03:00 AM", "04:00 AM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM"]
    
    var pickerPartySize = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        
        btnReserve.isUserInteractionEnabled = false
        btnReserve.alpha = 0.5
        self.initialDateCollectionView()
      
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtPartySize.delegate = self
        
        addToolBar(textField: txtPartySize)
        txtPartySize.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Custom Methods
    
    func initialDateCollectionView(){
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 7)
        self.show(selected: currentDate, minimumDate: min, maximumDate: max)
        
        fillDates(fromDate: dateMinimum, toDate: dateMaximum)
        updateCollectionView(to: currentDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        lblMonth.text = formatter.string(from: currentDate)
        formatter.dateFormat = "dd/MM/YYYY"
      
        for i in 0..<arrayDates.count {
            let date = arrayDates[i]
            if formatter.string(from: date) == formatter.string(from: currentDate) {
                dateCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                break
            }
        }
    }
    
    func show(selected: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil) {
        dateMinimum = minimumDate ?? Date(timeIntervalSinceNow: -3600 * 24 * 365 * 20)
        dateMaximum = maximumDate ?? Date(timeIntervalSinceNow: 3600 * 24 * 365 * 20)
    }
    
    func fillDates(fromDate: Date, toDate: Date) {
        
        var dates: [Date] = []
        var days = DateComponents()
        
        var dayCount = 0
        repeat {
            days.day = dayCount
            dayCount += 1
            guard let date = calendar.date(byAdding: days, to: fromDate) else {
                break;
            }
            if date.compare(toDate) == .orderedDescending {
                break
            }
            dates.append(date)
        } while (true)
        
        self.arrayDates = dates
        dateCollectionView.reloadData()
        
        if let index = self.arrayDates.index(of: currentDate) {
            dateCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func updateCollectionView(to currentDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        for i in 0..<arrayDates.count {
            let date = arrayDates[i]
            if formatter.string(from: date) == formatter.string(from: currentDate) {
                let indexPath = IndexPath(row: i, section: 0)
                dateCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.dateCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                })
                
                break
            }
        }
    }
    
    //MARK: Button Methods
    
    @IBAction func reserverAction(_ sender: AnyObject){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let scheduleDate = formatter.string(from: currentDate)
        let dictSchedule: NSDictionary = ["ReservationDate" : scheduleDate, "ReservationTime" : arrayScheduleTime[iSelectedIndex] as! String, "ServiceTitle" : "Hot  Stone Massage", "PartySize" : txtPartySize.text!, "Duration" : "1H", "ServiceDescription" : "Massage focused on the deepest layer of muscles to target knots and release chronic muscle tension."];
        self.scheduleDelegate?.sendScheduleToTable(dictSchedule: dictSchedule)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView{
           return arrayDates.count
        }
        else{
            return arrayScheduleTime.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dateCollectionView{
            let cellDate = dateCollectionView.dequeueReusableCell(withReuseIdentifier: dateCellReuseIdentifier, for: indexPath as IndexPath) as! DateCollectionViewCell
            
            let date = arrayDates[indexPath.item]
            cellDate.populateItem(date: date)
            
            if  iSelectedIndex == indexPath.row{
                cellDate.checkView.isHidden = false
            }
            else{
                cellDate.checkView.isHidden = true
            }
            
            return cellDate
        }
        else{
            let cellTime = timeCollectionView.dequeueReusableCell(withReuseIdentifier: timeCellReuseIdentifier, for: indexPath as IndexPath) as! TimeCollectionViewCell
            
            cellTime.lblTime.text = arrayScheduleTime[indexPath.row] as? String
            
            if  iSelectedIndex == indexPath.row{
                cellTime.checkView.isHidden = false
            }
            else{
                cellTime.checkView.isHidden = true
            }
            
            return cellTime
        }
    }
    
    //MARK: UICollectionViewDelegate protocol
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iSelectedIndex = indexPath.row
        if collectionView == dateCollectionView{
            isDateTimeSelected = true
            let date = arrayDates[indexPath.item]
            currentDate = date
            dateCollectionView.reloadData()
        }
        else{
            selectedTime = arrayScheduleTime[indexPath.item] as! String
            timeCollectionView.reloadData()
        }
        if(isDateTimeSelected && selectedTime != nil) {
            btnReserve.isUserInteractionEnabled = true
            btnReserve.alpha = 1.0
        }
    }
    
    //MARK: Pickerview Datasource Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerPartySize.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerPartySize[row]
    }

     //MARK: Pickerview Delegate Methods
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtPartySize.text = pickerPartySize[row]
    }

}

extension UIViewController: UITextFieldDelegate{
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.donePressed))
        doneButton.tintColor = UIColor(red: 2/255, green: 107/255, blue: 197/255, alpha: 1)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.cancelPressed))
        cancelButton.tintColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true)
    }
}
