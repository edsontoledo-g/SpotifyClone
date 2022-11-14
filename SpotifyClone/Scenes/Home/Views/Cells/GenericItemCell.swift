//
//  GenericItemCell.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 12/11/22.
//

import UIKit
import SDWebImage

class GenericItemCell: UICollectionViewCell, SelfConfiguringHomeCell {
    static var reuseIdentifier: String = "GenericItemCell"

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with content: AnySpotifyContent) {
        if let artist = content as? Artist {
            itemTitle.text = artist.name
            itemSubtitle.text = "Artist"
            
            if let urlString = artist.images?.first?.url, let url = URL(string: urlString) {
                itemImage.sd_setImage(with: url)
            }
            
            itemImage.makeRounded()
        } else if let album = content as? Album {
            itemTitle.text = album.name
            if let artistName = album.artists.first?.name {
                itemSubtitle.text = "Album · \(artistName)"
            } else {
                itemSubtitle.text = "Album"
            }
            
            if let urlString = album.images.first?.url, let url = URL(string: urlString) {
                itemImage.sd_setImage(with: url)
            }
            
            itemImage.makeSquared()
        }
    }
}
