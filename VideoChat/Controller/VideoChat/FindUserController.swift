//
//  FindUserController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/25/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SDWebImage

class FindUserController: BaseViewController {
    
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var lblSearchMsg: UILabel!
    @IBOutlet weak var searchView: UIView!
    fileprivate var timer: Timer!
    fileprivate var seconds: Int = 0
    fileprivate var offset = 0
    fileprivate var limit = 1
    fileprivate var foundUser: User!
    fileprivate var isAvailableSearch = false
    fileprivate var isActived = false
    
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var ivUser: CircularRoundImageView!
    @IBOutlet weak var lblUserInfo: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivSearch.loadGif(name: "searching-fast")

        registerNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        offset = 0
        isActived = true
        
        updateUser(isSearch: true)
        searchUser(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopTimer()
        isActived = false
        
        updateUser(isSearch: false)
    }

    
    @objc func didEnterBackground(_ notification: Notification) {
        updateUser(isSearch: false)
    }
    
    @objc func willTerminate(_ notification: Notification) {
        updateUser(isSearch: false)

    }
    
    @objc func willEnterforeground(_ notification: Notification) {
        updateUser(isSearch: true)
    }
    
    @objc func runTimed() {
        seconds = seconds + 1
        
        let count = seconds % 3
        if count == 0 {
            lblSearchMsg.text = "to talk to."
        } else if count == 1 {
            lblSearchMsg.text = "to talk to.."
        } else if count == 2 {
            lblSearchMsg.text = "to talk to..."
        }

    }
    
    private func stopTimer() {
        if timer != nil {
            seconds = 0
            timer.invalidate()
        }
    }
    
    private func searchUser(_ isSearch: Bool) {
        connectionView.isHidden = isSearch
        searchView.isHidden = !isSearch
        
        if isSearch {
            runTimed()
            findUser()
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runTimed), userInfo: nil, repeats: true)
        } else {
            stopTimer()
            
            if let user = foundUser {
                ivUser.sd_setImage(with: URL(string: user.userAvatar))
                lblUserInfo.text = "a \(user.age) year old \(user.sGender)?"
            }
        }

    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterforeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate(_:)), name: .UIApplicationWillTerminate, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark -- Action defines
    fileprivate func goToVideoChat() {
        if let vc = UIStoryboard.call.instantiateViewController(withIdentifier: Controllers.videoCallController) as? VideoCallController {
            connectionView.isHidden = true
            vc.user = self.foundUser
            present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func connectAction(_ sender: Any) {
       retrieveSessionInfo()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        searchUser(true)
        offset = offset + 1
    }
}

//Mark -- http
extension FindUserController {
    fileprivate func findUser() {
        if !isAvailableSearch {
            return
        }
        
        if !isActived {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            HttpHelper.search("", offset: self.offset, limit: self.limit, completionHandler: { arr in
                DispatchQueue.main.async {
                    if let users = arr, users.count > 0 {
                        let userid = Preferences.sharedInstance.userId
                        if userid == users.first?.userID {
                            self.offset = self.offset + 1
                            self.findUser()
                            return
                        }
                        
                        self.foundUser = users.first
                        
                        self.searchUser(false)
                    } else {
                        self.findUser()
                    }
                }
            })
        }
        
    }
    
    fileprivate func retrieveSessionInfo() {
        
        guard let receiveUser = foundUser else {
            return
        }
        
        let userId = Preferences.sharedInstance.userId
        
        Utilities.showHUD(self, with: "connecting...")

        HttpHelper.retrieveSession(userId, receiveUserId: receiveUser.userID) { (apKey, token, sessionId) in
            DispatchQueue.main.async {
                Utilities.hideHUD(self)
                
                if let apiKey = apKey, let token = token, let sessionId = sessionId {
                    
                    let preferences = Preferences.sharedInstance
                    preferences.apiKey = apiKey
                    preferences.token = token
                    preferences.sessionId = sessionId
                    
                    self.goToVideoChat()
                }
            }
        }
    }
    
    fileprivate func updateUser(isSearch: Bool) {
        DispatchQueue.global(qos: .background).async {
            let userId = Preferences.sharedInstance.userId
            
            HttpHelper.updateSearchingUser(userId, searching: isSearch, completionHandler: { success in
                DispatchQueue.main.async {
                    print("Updated User Status")
                    
                    self.isAvailableSearch = isSearch
                    self.findUser()
                }
            })
        }
    }
}
