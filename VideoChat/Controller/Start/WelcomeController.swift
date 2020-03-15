//
//  WelcomeController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/18/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class WelcomeController: BaseViewController {
    var isPresented: Bool = false
    var PRODUCT: SKProduct?
    var trialLabel: UILabel?
    
    @IBOutlet weak var btnHeightContrast: NSLayoutConstraint!
    @IBOutlet weak var btnTrial: StyleButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnHeightContrast.constant = Constant.BTN_HEIGHT
        btnTrial.layoutIfNeeded()
        
        let firstString = "Start 3-day trial"
        let secondString = "\nthen $4.99/week"
        
        let attributedText = NSMutableAttributedString.init(string: "\(firstString)\(secondString)")
        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.sfProTextBoldFont(20), range: NSRange(location: 0, length: firstString.count))
        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.sfProTextBoldFont(14), range: NSRange(location: firstString.count, length: secondString.count))
        
        let label = UILabel.init(frame: btnTrial.bounds)
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.init(rgb: 0x260340)
        
        btnTrial.addSubview(label)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitProductsAvailable,
                                               object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                self.setupTrialInfo()
                                                self.paymentStatusPassed()
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitProductPurchased,
                                               object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                self.paymentStatusPassed()
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitRestoredPurchases,
                                               object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                self.paymentStatusPassed()
        }

        // purchase failed
        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitProductPurchaseFailed,
                                               object: nil, queue: OperationQueue.main) { (note) -> Void in

        }

        // restore failed
        NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitRestoringPurchasesFailed,
                                               object: nil, queue: OperationQueue.main) { (note) -> Void in

        }
        
        paymentStatusPassed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.mkStoreKitProductsAvailable, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.mkStoreKitProductPurchased, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.mkStoreKitRestoredPurchases, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.mkStoreKitProductPurchaseFailed, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.mkStoreKitRestoringPurchasesFailed, object: nil)
    }
    
    func setupTrialInfo() {
        PRODUCT = MKStoreKit.shared().availableProducts.first as? SKProduct
        
        weak var weakSelf = self
        URLSession.shared.dataTask(with: URL(string: HttpUrl.BASE_URL + "iap/")!) { (data, response, error) in
            guard error == nil, data != nil else {
                return
            }
            
            do {
                let iapInUse = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:String]
                
                let iapId = iapInUse["id"]
                
                for product in MKStoreKit.shared().availableProducts {
                    let skproduct = product as! SKProduct;
                    if skproduct.productIdentifier == iapId {
                        weakSelf?.PRODUCT = skproduct
                        break;
                    }
                }
                
                var iapPrice = iapInUse["price"]
                if (iapPrice ?? "").isEmpty {
                    iapPrice = weakSelf!.PRODUCT?.localizedPrice()
                }
                if (iapPrice ?? "").isEmpty {
                    iapPrice = "$"
                }
                var iapPeriod = iapInUse["period"]
                if (iapPeriod ?? "").isEmpty {
                    iapPeriod = "month"
                }
                
                DispatchQueue.main.async {
                    let firstString = "Start 3-Day Trial"
                    let secondString = "\nthen \(iapPrice!)/\(iapPeriod!)"
                    
                    let attributedText = NSMutableAttributedString.init(string: "\(firstString)\(secondString)")
                    attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.sfProTextBoldFont(20), range: NSRange(location: 0, length: firstString.count))
                    attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.sfProTextBoldFont(16), range: NSRange(location: firstString.count, length: secondString.count))
                    
                    weakSelf?.trialLabel?.attributedText = attributedText
                }
            } catch {
                print("Unexpected error: \(error).")
            }
            }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func trialAction(_ sender: Any) {
        #if DEBUG
        self.goToNext()
        #else
        MKStoreKit.shared().initiatePaymentRequestForProduct(withIdentifier: (PRODUCT?.productIdentifier) ?? kProductSubscriptionId)
        #endif
    }
    
    func paymentStatusPassed() {
        if MKStoreKit.shared().isSubscriptionForAnyProductActive() {
            self.goToNext()
        }
    }
    
    fileprivate func goToNext() {
        //log purchase
        logPurchase()
        
        
        if self.isPresented {
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        if Preferences.sharedInstance.isLoggedIn {
            Utilities.goToHomeScreen()
        } else {
            goToLogin()
        }
    }
    
    fileprivate func logPurchase() {
        let userId = Preferences.sharedInstance.getPurchaseUser()
        
        DispatchQueue.global(qos: .background).async {
            if !userId.isEmpty {
                HttpHelper.logPurchase(userId, completionHandler: { success in
                    print( "Log purcahsed successfully" )
                })
            }
        }
    }
    
    @IBAction func restoreAction(_ sender: Any) {
        MKStoreKit.shared().restorePurchases()
    }
    
    fileprivate func goToLogin() {
        if let controller = UIStoryboard.auth.instantiateViewController(withIdentifier: Controllers.loginViewController) as? LoginViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

