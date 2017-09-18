//
//  DateCollectionViewCell.swift
//  Reservations
//
//  Created by Chen Shi on 2/22/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var checkView: UIView!
    
    func populateItem(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        lblDay.text = dateFormatter.string(from: date).uppercased()
        
        let numberFormatter = DateFormatter()
        numberFormatter.dateFormat = "d"
        lblDate.text = numberFormatter.string(from: date)
    }
}
