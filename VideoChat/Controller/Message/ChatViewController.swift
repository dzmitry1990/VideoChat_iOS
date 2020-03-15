//
//  ChatViewController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/21/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//


import UIKit
import GrowingTextView
import SDWebImage

var messagesize :CGSize=CGSize()

class ChatViewController: BaseViewController {

    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var messageContentView: UIView!
    @IBOutlet weak var textViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    
    private var lastContentOffset: CGFloat = 0
    var conversationID: String!
    var chatTimer: Timer!
    var user: User?
    var lblNone: UILabel?
    
    var messages = [Message]() {
        didSet {
           reloadViewData()
        }
    }
    
    fileprivate var textViewHeightConstraintValue: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addKeyboardNotifications()
        
        textViewHeightConstraintValue = textViewHeightConst.constant
        resetTextViewNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = user {
            nameLabel.text = user.fullname
            ivUser.sd_setImage(with: URL(string: user.userAvatar))
        }

        chatTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scheduleTimer), userInfo: nil, repeats: true)

        if (self.conversationID == nil) {
            getConversionId()
        } else {
            self.getAllMessages()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if chatTimer != nil {
            chatTimer.invalidate()
        }
    }
    
    fileprivate func reloadViewData() {
        lblNone?.isHidden = messages.count > 0
        tableView.reloadData()
    }
    
    // MARK: - Custom Action
    @objc func scheduleTimer() {
        getAllMessages()
    }
    
    fileprivate func setTextViewHeight(_ textView: UITextView, height: CGFloat) {
        if textViewHeightConst.constant != height {
            if ( height <= tableView.bounds.size.height / 3 ) {
                textViewHeightConst.constant = height
            }
            textView.contentSize = CGSize(width: textView.bounds.width, height: height)
        }
    }
    
    fileprivate func resetTextViewNotes() {
        textView.text = ""
        setTextViewHeight(textView, height: textViewHeightConstraintValue)
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }

    
    // MARK: - actions
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendMessage()
    }
    
    
    @IBAction func cameraAction(_ sender: Any) {
    }
    
    @IBAction func infoBtnAction(_ sender: Any) {
        if let user = user {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: Utilities.isPad() ? .alert : .actionSheet)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Report User ", style: .default, handler: { (action) in
                self.blockUser(user: user)
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        adjustingHeight(true, notification: notification)

        scrollToBottom()
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
    }
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
        
        var userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let changeInHeight = keyboardFrame.height * (show ? -1 : 0)
        bottomConstraint.constant = changeInHeight
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func setupUI() {

        let lblNoTasks = UILabel()
        lblNoTasks.textAlignment = .center
        lblNoTasks.text = "No chats..."
        lblNoTasks.textColor = UIColor(rgb: 0x8F8F8F)
        
        lblNoTasks.font = UIFont.sfProTextRegularFont(17)
        tableView.backgroundView = lblNoTasks
        
        lblNone = lblNoTasks
        
        textView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.keyboardDismissMode = .onDrag
        let tapGestureRecognizer = UITapGestureRecognizer(target: self.textView,
                                                          action: #selector(resignFirstResponder))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: - Actions
    fileprivate func dismissAction() {
        if let navcontroller = self.navigationController {
            navcontroller.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissAction()
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "messaging"
        
        let cell = MessagingCell.init(style: .default, reuseIdentifier: cellIdentifier)
        
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: AnyObject, atIndexPath indexPath: IndexPath) {
        let ccell: MessagingCell = (cell as! MessagingCell)
        let mes = self.messages[indexPath.row]
        
        if mes.from == Preferences.sharedInstance.userId {
            ccell.sentBy = true
            ccell.profileImage.sd_setImage(with: URL(string: Preferences.sharedInstance.thumbnailPath))
        } else {
            ccell.sentBy = false
            if let user = user {
                ccell.profileImage.sd_setImage(with: URL(string: user.userAvatar))
            }
        }
        
        ccell.messageText.text = mes.message
        if mes == messages.last {
            ccell.messageTime.text = Date.init(timeIntervalSince1970: (mes.timeStamp)).timeAgo
        } else {
            ccell.messageTime.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ccell: MessagingCell = MessagingCell()
        let mes = messages[indexPath.row]
        messagesize = ccell.messageSize1(mes.message as NSString)
        return messagesize.height + ccell.floatVertical()
    }
}

// Mark -- HttpHelper
extension ChatViewController {
    fileprivate func getConversionId() {
        let userId = Preferences.sharedInstance.userId
        guard let toUser = user else {
            self.showAlert(with: "Invalid User", message: nil) { action in
                DispatchQueue.main.async {
                    if let navcontroller = self.navigationController {
                        navcontroller.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }

            return
        }

        self.loadingIndicator.visibility = true
        HttpHelper.getConversationId(userId, to: toUser.userID) { conId in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                if let conId = conId {
                    self.conversationID = conId
                    self.getAllMessages()
                } else {
                    self.showNoInternetConnectionAlert({ action in
                        self.getConversionId()
                    })
                }
            }

        }
    }
    
    fileprivate func getAllMessages() {
        guard let convid = conversationID else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            HttpHelper.getMessages(convid, completionHandler: { messages in
                DispatchQueue.main.async {
                    if var mess = messages {
                        mess.sort(by: { (m1, m2) -> Bool in
                            return m1.timeStamp < m2.timeStamp
                        })

                        self.messages = mess
                    } else {
                        self.messages.removeAll()
                    }
                }
            })
        }
    }
    
    fileprivate func sendMessage() {
        let currentUserID = Preferences.sharedInstance.userId
        
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        
        guard let user = user else {
            return
        }
        
        HttpHelper.sendMessage(currentUserID, to: user.userID, message: text) { message in
            DispatchQueue.main.async {
                if let message = message {
                    self.resetTextViewNotes()
                    self.messages.append(message)
                }
            }
        }
        
    }
    
    fileprivate func blockUser(user: User) {
        self.loadingIndicator.visibility = true
        let userId = Preferences.sharedInstance.userId
        let blockId = user.userID
        
        HttpHelper.reportUser(userId, blockId: blockId) { success in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                self.dismissAction()
            }
        }
        
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChatViewController: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.textViewHeightConst.constant = height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
