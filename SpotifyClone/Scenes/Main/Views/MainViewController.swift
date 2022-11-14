//
//  MainViewController.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/11/22.
//

import UIKit

protocol AnyMainView: AnyObject {
    var presenter: AnyMainPresenter? { get set }
}

class MainViewController: UITabBarController, AnyMainView {
    var presenter: AnyMainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        MainRouter.createModule(for: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
}
