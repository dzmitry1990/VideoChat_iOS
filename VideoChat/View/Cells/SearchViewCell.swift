//
//  SearchViewCell.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/21/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewCell: UITableViewCell {
    static let cellId = "SearchViewCell"
    
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayCell(_ user: User) {
        ivUser.sd_setImage(with: URL(string: user.userAvatar))
        lblName.text = user.fullname
    }

}
