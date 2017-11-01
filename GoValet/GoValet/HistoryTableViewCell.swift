

//
//  HistoryTableViewCell.swift
//  GoValet
//
//  Created by Ajeesh T S on 19/01/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var hotelImageView : UIImageView!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var tipLbl : UILabel!
    @IBOutlet weak var containerView : UIView!

    var history : History?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.roundCornerValue(3.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showData(){
        if let date = self.history?.createdDate{
            timeLbl.text = "Time : \(UtilityMethods.gettimeFromDateString(date))"
        }
        if let date = self.history?.createdDate{
            dateLbl.text = "Date : \(UtilityMethods.dateFromString(date))"
        }
        if let imageUrl = self.history?.hotel?.image{
            hotelImageView.sd_setImage(with: URL(string:(imageUrl)))
        }
        if let name = self.history?.hotel?.name{
            tipLbl.text = name
        }
    }
}
