//
//  ChatRoomController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/21/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class ChatRoomController: BaseViewController {
    fileprivate var inboxList = [Inbox]() {
        didSet {
            reloadViewData()
        }
    }
    
    fileprivate var lblNone: UILabel!
    
    @IBOutlet weak var tvChats: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lblNoInboxs = UILabel()
        lblNoInboxs.textAlignment = .center
        
        lblNoInboxs.textColor = UIColor(rgb: 0x8F8F8F)
        
        lblNoInboxs.font = UIFont.sfProTextRegularFont(17)
        tvChats.backgroundView = lblNoInboxs
        lblNone = lblNoInboxs
        
        tvChats.delegate = self
        tvChats.dataSource = self
        tvChats.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getInboxList()
    }
    
    fileprivate func reloadViewData() {
        if inboxList.count == 0 {
            lblNone.text = "No chats..."
        }
        lblNone.isHidden = inboxList.count > 0
        tvChats.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - UITableViewDataSource
extension ChatRoomController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomCell.cellId, for: indexPath) as! ChatRoomCell
        cell.displayCell(inboxList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxList.count
    }
}

// MARK: - UITableViewDelegate
extension ChatRoomController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(77)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let inbox = inboxList[indexPath.row]
        
        if let vc = UIStoryboard.chats.instantiateViewController(withIdentifier: Controllers.chatViewController) as? ChatViewController {
            vc.conversationID = inbox.conversationId
            vc.user = inbox.user
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
// Mark -- http
extension ChatRoomController {
    fileprivate func getInboxList(_ isShowLoading: Bool = false) {
        self.loadingIndicator.visibility = isShowLoading
        lblNone.text = "Loading..."
        let uerId = Preferences.sharedInstance.userId

        HttpHelper.getInbox(uerId) { arr in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                if let arr = arr {
                    self.inboxList = arr
                } else {
                    self.inboxList.removeAll()
                }
            }

        }
    }
}
