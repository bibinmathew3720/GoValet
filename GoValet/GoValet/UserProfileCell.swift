//
//  UserProfileCell.swift
//  GoValet
//
//  Created by Ajeesh T S on 27/12/16.
//  Copyright © 2016 Ajeesh T S. All rights reserved.
//

import UIKit
import SDWebImage

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var userNameLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = 30.0
        self.profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func showUserInfo(){
        if let userName = UserInfo.currentUser()?.userName{
            let uname : String = userName
            userNameLbl.text = uname
        }

        if let imageUrl = UserInfo.currentUser()?.profileImage{
//            profileImageView.sd_setImageWithURL(NSURL(string:(imageUrl)))
            profileImageView.sd_setImage(with: URL(string:(imageUrl)), placeholderImage: UIImage(named: "user"))
        }else{
            profileImageView.image = UIImage(named: "user")
        }
    }
}
