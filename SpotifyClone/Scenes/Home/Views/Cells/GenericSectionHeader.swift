//
//  GenericSectionHeader.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 13/11/22.
//

import UIKit

class GenericSectionHeader: UICollectionReusableView {
    static var reuseIdentifier: String = "GenericSectionHeader"
    
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with text: String) {
        title.text = text
    }
}
