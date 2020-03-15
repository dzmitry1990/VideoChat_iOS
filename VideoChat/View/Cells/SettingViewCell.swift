
//
//  SettingViewCell.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/22/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class SettingViewCell: UITableViewCell {
    static let cellId = "SettingViewCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
