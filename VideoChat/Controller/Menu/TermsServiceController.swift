 //
//  TermsServiceController.swift
//  Ghost
//
//  Created by Dzmitry Zhuk on 5/27/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import WebKit

class TermsServiceController: BaseViewController {

    // outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: UIView!
    
    //properties
    var contentWebView: WKWebView!
    var contentUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.layoutIfNeeded()
        contentWebView = WKWebView(frame: webView.bounds)
        contentWebView.translatesAutoresizingMaskIntoConstraints = false
        contentWebView.backgroundColor = UIColor.clear
        contentWebView.isOpaque = false
        webView.addSubview(contentWebView)
        
//        if contentUrl == Constants.TermsService.PRIVACY_POLICY {
//            titleLbl.text   = "Privacy Policy"
//        } else {
//            titleLbl.text   = "Terms of Service"
//        }
//        contentWebView.load(URLRequest(url: URL(string: contentUrl)!))
    }
    
    override func viewDidLayoutSubviews() {
        contentWebView.frame = webView.bounds
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
