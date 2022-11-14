//
//  AuthenticationViewController.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 08/11/22.
//

import UIKit
import WebKit

protocol AnyAuthenticationView: AnyObject {
    var presenter: AnyAuthenticationPresenter? { get set }
    func loadRequest(_ request: URLRequest)
}

class AuthenticationViewController: UIViewController {
    var presenter: AnyAuthenticationPresenter?
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AuthenticationRouter.createModule(for: self)
        webView.navigationDelegate = self
        
        presenter?.loadAuthenticationPage()
    }
}

extension AuthenticationViewController: AnyAuthenticationView {
    func loadRequest(_ request: URLRequest) {
        self.webView.load(request)
    }
}

extension AuthenticationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        presenter?.didStartProvisionalNavigation(with: webView.url)
    }
}
