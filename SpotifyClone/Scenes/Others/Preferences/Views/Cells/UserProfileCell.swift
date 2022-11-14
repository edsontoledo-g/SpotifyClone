//
//  UserProfileCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import UIKit
import SDWebImage

class UserProfileCell: UITableViewCell, SelfConfiguringPreferencesCell {
    static var reuseIdentifier = "UserProfileCell"
    
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userProfileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(for user: UserProfile, title: String?) {
        userProfileName.text = user.display_name
        if let urlString = user.images.last?.url, let url = URL(string: urlString) {
            userProfileImage.sd_setImage(with: url)
        }
    }
}
