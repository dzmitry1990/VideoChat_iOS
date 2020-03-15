//
//  VideoCallController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/24/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import OpenTok

class VideoCallController: BaseViewController {
    @IBOutlet weak var sellerView: UIView!
    fileprivate var session: OTSession!
    fileprivate var publisher: OTPublisher!
    fileprivate var subscriber: OTSubscriber!
    fileprivate let preferences = Preferences.sharedInstance
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnCall: RecordButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnSnapchat: UIButton!
    fileprivate var progressTimer: Timer!
    fileprivate var progress: CGFloat = 0
    fileprivate let maxDuration = CGFloat(10)
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var reportView: UIView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblState.isHidden = true
        btnCall.isHidden = false
        btnReport.isHidden = false
        btnSnapchat.isHidden = false
        
        if let apiKey = preferences.apiKey, let sessionId = preferences.sessionId {
            session = OTSession.init(apiKey: apiKey, sessionId: sessionId, delegate: self)

            doConnect()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopTimer()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    fileprivate func countTimer() {
        btnCall.setRecord(true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        progress = progress + (CGFloat(0.05) / maxDuration)
        btnCall.setProgress(progress)
        
        let count = Int(maxDuration) - (Int(progress * 10))
        lblCount.text = "\(count)"
        
        if progress >= 1 {
            closeController()
        }
    }
    
    fileprivate func stopTimer() {
        if let progressTimer = progressTimer {
            progressTimer.invalidate()
            btnCall.setRecord(false)
        }
    }
    
    fileprivate func closeController() {
        DispatchQueue.main.async {
            self.stopTimer()
            self.lblCount.text = "Stop"
            var error: OTError?
            
            self.session.disconnect(&error)
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
       dismiss(animated: false, completion: nil)
    }
    
    @IBAction func reportAcction(_ sender: Any) {
        reportView.isHidden = false
    }
    
    @IBAction func snapchatAction(_ sender: Any) {
        if let user = user {
            let url = "https://snapchat.com/add/\(user.snapChatId)"
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if btnCall.buttonState == .idle {
            return
        }
        
        stopTimer()
        lblCount.text = ""
        btnCall.isEnabled = false
    }

    @IBAction func nudityAction(_ sender: Any) {
        reportView.isHidden = true
        
        sendReportUser(0)
    }
    
    @IBAction func violenceAction(_ sender: Any) {
        reportView.isHidden = true
        
        sendReportUser(1)
    }
    
    @IBAction func threateningAction(_ sender: Any) {
        reportView.isHidden = true
        
        sendReportUser(2)
    }
    
    @IBAction func harrassingAction(_ sender: Any) {
        reportView.isHidden = true
        
        sendReportUser(3)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        reportView.isHidden = true
    }
    
}

extension VideoCallController {
    fileprivate func doConnect() {
        var error: OTError?
        
        if let token = preferences.token {
            session.connect(withToken: token, error: &error)
            
            lblState.isHidden = false
            lblState.text = "connecting..."
            
            if let error = error {
                self.showAlertWithErrorMessage(error.localizedDescription)
            }
        }
    }
    
    fileprivate func doPublish() {
        let setting = OTPublisherSettings.init()
        setting.name = UIDevice.current.name
        
        publisher = OTPublisher.init(delegate: self)
        var error: OTError?
        session.publish(publisher, error: &error)
        
        if let error = error {
            self.showAlertWithErrorMessage(error.localizedDescription)
            return
        }
        
        self.view.addSubview(publisher.view!)
        publisher.view?.frame = self.view.bounds
        publisher.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.sendSubview(toBack: publisher.view!)
    }
    
    fileprivate func doSubscriber(stream: OTStream) {
        subscriber = OTSubscriber.init(stream: stream, delegate: self)
        var error: OTError?
        session.subscribe(subscriber, error: &error)
        
        if let error = error {
            self.showAlertWithErrorMessage(error.localizedDescription)
        }
    }
    
    fileprivate func didSubscribe() {
        if let subscriber = subscriber {
            self.view.addSubview(subscriber.view!)
            subscriber.view?.frame = self.view.bounds
            subscriber.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.sendSubview(toBack: subscriber.view!)

            if let publisher = publisher {
                self.sellerView.addSubview(publisher.view!)
                publisher.view?.frame = self.sellerView.bounds
                publisher.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.view.bringSubview(toFront: self.sellerView)
            }

            lblState.text = "Continue"
            countTimer()
            btnReport.isHidden = false
            btnCall.isHidden = false
            btnSnapchat.isHidden = false
        }
    }
}

extension VideoCallController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print(#function)
        
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print(#function)
        
        closeController()
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print(#function)
        doSubscriber(stream: stream)
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print(#function)
        closeController()
    }
    
    func session(_ session: OTSession, connectionCreated connection: OTConnection) {
        print(#function)
    }
    
    func session(_ session: OTSession, connectionDestroyed connection: OTConnection) {
        print(#function)
        closeController()
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print(#function)
        print(error.localizedDescription)
        closeController()
    }
    
}

extension VideoCallController: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print(#function)
        
        didSubscribe()
    }
    
    func subscriberDidDisconnect(fromStream subscriber: OTSubscriberKit) {
        print(#function)
        
        closeController()
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print(#function)
        
        closeController()
    }
}

extension VideoCallController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        print(#function)
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print(#function)
        
        closeController()
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        print(#function)
        
        closeController()
    }
}

//Mark -- http
extension VideoCallController {
    fileprivate func sendReportUser(_ type: Int) {
        if let user = user {
            let userId = preferences.userId
            self.loadingIndicator.visibility = true
            HttpHelper.reportUser(userId, blockId: user.userID, type: type) { success in
                DispatchQueue.main.async {
                    self.loadingIndicator.visibility = false
                    if success {
                        self.showAlert(with: "Reported successfully", message: nil, handler: { action in
                            self.closeController()
                        })
                    } else {
                        self.showNoInternetConnectionAlert()
                    }
                }
            }
        }
    }
}

