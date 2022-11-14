//
//  UserTopItemCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 11/11/22.
//

import UIKit
import SDWebImage

class RecentlyPlayedTrackCell: UICollectionViewCell, SelfConfiguringHomeCell {
    static var reuseIdentifier = "RecentlyPlayedTrackCell"

    @IBOutlet var trackImage: UIImageView!
    @IBOutlet var trackTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with content: AnySpotifyContent) {
        if let artist = content as? Artist {
            trackTitle.text = artist.name
            
            if let urlString = artist.images?.last?.url, let url = URL(string: urlString) {
                trackImage.sd_setImage(with: url)
            }
        } else if let album = content as? Album {
            trackTitle.text = album.name
            
            if let urlString = album.images.last?.url, let url = URL(string: urlString) {
                trackImage.sd_setImage(with: url)
            }
        }
    }
}
