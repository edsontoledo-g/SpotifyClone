//
//  SettingsViewController.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 10/11/22.
//

import UIKit

protocol AnyPreferencesView: AnyObject {
    var presenter: AnyPreferencesPresenter? { get set }
}

class PreferencesViewController: UIViewController, AnyPreferencesView {
    @IBOutlet var tableView: UITableView!
    
    var presenter: AnyPreferencesPresenter?
    
    var userProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PreferencesRouter.createModule(for: self)
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter?.viewDidLoad()
        
        registerCells()
    }
    
    func registerCells() {
        let settingsCellNib = UINib(nibName: SettingsCell.reuseIdentifier, bundle: nil)
        tableView.register(settingsCellNib, forCellReuseIdentifier: SettingsCell.reuseIdentifier)
        
        let userProfileCellNib = UINib(nibName: UserProfileCell.reuseIdentifier, bundle: nil)
        tableView.register(userProfileCellNib, forCellReuseIdentifier: UserProfileCell.reuseIdentifier)
        
        let signOutCellNib = UINib(nibName: SignOutCell.reuseIdentifier, bundle: nil)
        tableView.register(signOutCellNib, forCellReuseIdentifier: SignOutCell.reuseIdentifier)
    }
    
    func configureCell<T: SelfConfiguringPreferencesCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        let preferencesListRow = presenter?.preferences?[indexPath.row]
        
        if let userProfile = userProfile {
            cell.configure(for: userProfile, title: preferencesListRow?.title)
        }
        
        return cell
    }
    
    func configure(with userProfile: UserProfile) {
        self.userProfile = userProfile
    }
}
