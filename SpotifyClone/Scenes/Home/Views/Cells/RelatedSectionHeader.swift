//
//  RelatedSectionHeader.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 13/11/22.
//

import UIKit

class RelatedSectionHeader: UICollectionReusableView {
    static var reuseIdentifier: String = "RelatedSectionHeader"
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with content: AnySpotifyContent) {
        if let artist = content as? Artist {
            itemTitle.text = artist.name
            
            if let urlString = artist.images?.last?.url, let url = URL(string: urlString) {
                itemImage.sd_setImage(with: url)
            }
            
            itemImage.makeRounded()
        } else if let album = content as? Album {
            itemTitle.text = album.name
            
            if let urlString = album.images.last?.url, let url = URL(string: urlString) {
                itemImage.sd_setImage(with: url)
            }
            
            itemImage.makeSquared()
        }
    }
}
