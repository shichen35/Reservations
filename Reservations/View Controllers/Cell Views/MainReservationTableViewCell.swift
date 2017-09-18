//
//  MainReservationTableViewCell.swift
//  Reservations
//
//  Created by Chen Shi on 2/21/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import UIKit

class MainReservationTableViewCell: UITableViewCell {

    @IBOutlet var reservationView: UIView!
    @IBOutlet var lblReservationDate: UILabel!
    @IBOutlet var lblReservationTime: UILabel!
    @IBOutlet var lblServiceTitle: UILabel!
    @IBOutlet var lblPartySize: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblServiceDescription: UILabel!
    @IBOutlet var btnReservation: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnReservation.layer.cornerRadius = 3.0
        btnReservation.layer.borderWidth = 0.1
        btnCancel.layer.cornerRadius = 3.0
        btnCancel.layer.borderWidth = 0.1
        
        reservationView.layer.cornerRadius = 3.0
        reservationView.layer.borderWidth = 0.1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellData(dictReservation: NSDictionary, nIndexPath: Int){
        lblReservationDate.text = dictReservation.value(forKey: "ReservationDate") as! String?
        lblReservationTime.text = dictReservation.value(forKey: "ReservationTime") as! String?
        lblServiceTitle.text = dictReservation.value(forKey: "ServiceTitle") as! String?
        lblPartySize.text = String .init(format: "Party Size %@", (dictReservation.value(forKey: "PartySize") as! String?)!)
        lblDuration.text = dictReservation.value(forKey: "Duration") as! String?
        lblServiceDescription.text = dictReservation.value(forKey: "ServiceDescription") as! String?
    }

}
