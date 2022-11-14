//
//  UserTopItemCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 11/11/22.
//

import UIKit

class UserTopItemCell: UICollectionViewCell, SelfConfiguringHomeCell {
    static var reuseIdentifier: String = "UserTopItemCell"
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with content: AnySpotifyContent) {
        if let artist = content as? Artist {
            itemTitle.text = artist.name
            
            if let urlString = artist.images?.first?.url, let url = URL(string: urlString) {
                itemImage.sd_setImage(with: url)
            }
            
            itemImage.makeRounded()
        } else if let album = content as? Album {
            itemTitle.text = album.name
            
            if let urlString = album.images.first?.url, let url = URL(string: urlString) {
                itemImage.sd_setImage(with: url)
            }
            
            itemImage.makeSquared()
        }
    }
}
