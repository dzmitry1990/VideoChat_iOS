//
//  ChatRoomCell.swift
//  Ghost
//
//  Created by Dzmitry Zhuk on 6/20/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import SDWebImage

class ChatRoomCell: UITableViewCell {
    static let cellId = "ChatRoomCell"
    
    
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusView.layer.cornerRadius = 5
        statusView.layer.borderColor = UIColor.white.cgColor
        statusView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func displayCell(_ inbox: Inbox) {
        ivUser.sd_setImage(with:URL(string: inbox.user?.userAvatar ?? ""))
        statusView.isHidden = true
        lblUserName.text = inbox.user?.fullname
        lblMessage.text = inbox.message
        lblTime.text = Date.init(timeIntervalSince1970: (inbox.timestamp)).timeAgo
    }
}
