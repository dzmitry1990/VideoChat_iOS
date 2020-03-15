//
//  HistoryViewCell.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/21/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import SDWebImage


class HistoryViewCell: UITableViewCell {
    static let cellId = "HistoryViewCell"
    
    @IBOutlet weak var ivUser: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ivUser.layoutIfNeeded()
        ivUser.layer.cornerRadius = ivUser.bounds.height / 2
        ivUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func displayCell(_ inbox: Inbox) {
        ivUser.sd_setImage(with: URL(string: inbox.user?.userAvatar ?? ""))
        lblName.text = inbox.user?.fullname
        lblTime.text = Date.init(timeIntervalSince1970: (inbox.timestamp)).timeAgo
    }
}
