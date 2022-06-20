//
//  DetailVC.swift
//  Asurion-iOS
//
//  Copyright © 2022 Shruti. All rights reserved.
//

import Foundation
import WebKit
import UIKit

class DetailVC : UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: WKWebView!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlToLoad = URL.init(string: url) {
        webView.load(URLRequest(url: urlToLoad))
    }
}
}
