//
//  DetailVC.swift
//  Asurion-iOS
//
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation
import WebKit
import UIKit

/// To display detail of image
class DetailVC : UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var pet: Pet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        self.title = pet.title
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.webView.navigationDelegate = self
        if let urlToLoad = URL.init(string: pet.content_url) {
        webView.load(URLRequest(url: urlToLoad))
    }
}
}

extension DetailVC: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityIndicator.stopAnimating()
        
    }
        
}
