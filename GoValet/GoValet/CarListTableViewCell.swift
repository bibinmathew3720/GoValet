//
//  CarListTableViewCell.swift
//  GoValet
//
//  Created by Ajeesh T S on 22/01/17.
//  Copyright © 2017 Ajeesh T S. All rights reserved.
//

import UIKit

class CarListTableViewCell: UITableViewCell {

    @IBOutlet weak var carImageView : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    var car : Car?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.roundCornerValue(3.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showData(){
       
        if let name = self.car?.name{
            nameLbl.text = name
        }
        if let imageUrl = self.car?.carImage{
            carImageView.sd_setImage(with: URL(string:(imageUrl)))
        }
    }
}
