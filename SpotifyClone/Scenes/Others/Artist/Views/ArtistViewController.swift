//
//  ArtistViewController.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 13/11/22.
//

import UIKit

class ArtistViewController: UIViewController {
    @IBOutlet var artistImageView: UIImageView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        configureView()
    }
    
    func configureView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).cgColor,
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        ]
        gradientLayer.shouldRasterize = true
        gradientView.backgroundColor = .clear
        gradientView.layer.addSublayer(gradientLayer)
    }
}

extension ArtistViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
