//
//  SideMenuCell.swift
//  GoValet
//
//  Created by Ajeesh T S on 27/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var menuImageView : UIImageView!
    @IBOutlet weak var menuTitleLbl : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
