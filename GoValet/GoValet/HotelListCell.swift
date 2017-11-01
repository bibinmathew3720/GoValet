//
//  HotelListCell.swift
//  GoValet
//
//  Created by Ajeesh T S on 28/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit
import SDWebImage

class HotelListCell: UITableViewCell {

    @IBOutlet weak var hotelImageView : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var distanceLbl : UILabel!
    var hotel : Hotel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(_ hotelInfo : Hotel){
        self.hotel = hotelInfo
        if let name = self.hotel?.name{
            nameLbl.text = name
        }
        if let distc = self.hotel?.distance{
            distanceLbl.text = "Distance : \(distc)"
        }
        if let imageUrl = self.hotel?.image{
            hotelImageView.sd_setImage(with: URL(string:(imageUrl)))
        }
    }

}
