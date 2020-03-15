//
//  MenuController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/22/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class MenuController: BaseViewController {
    fileprivate let menus = ["Edit profile", "Privacy policy", "Terms of service", "Contact us"]
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivUser: CircularRoundImageView!
    @IBOutlet weak var tvMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvMenu.delegate = self
        tvMenu.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let path = Preferences.sharedInstance.thumbnailPath
        if !path.isEmpty {
            ivUser.sd_setImage(with: URL(string: path))
        }
        
        let name = Preferences.sharedInstance.firstName + " " + Preferences.sharedInstance.lastName
        lblName.text = "\(name)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        Utilities.logOut()
    }
    
}

// MARK: - UITableViewDataSource
extension MenuController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.cellId, for: indexPath) as! SettingViewCell
        cell.lblTitle.text = menus[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
}

// MARK: - UITableViewDelegate
extension MenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(76)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            if let vc = UIStoryboard.profile.instantiateViewController(withIdentifier: Controllers.editProfileController) as? EditProfileController {
                navigationController?.pushViewController(vc, animated: true)
            }
            break

        case 1:
            if let controller = UIStoryboard.profile.instantiateViewController(withIdentifier: Controllers.termsServiceController) as? TermsServiceController {
                navigationController?.pushViewController(controller, animated: true)
            }
            break
        case 2:
            if let controller = UIStoryboard.profile.instantiateViewController(withIdentifier: Controllers.termsServiceController) as? TermsServiceController {
                navigationController?.pushViewController(controller, animated: true)
            }
            break
        case 3:
            break
        
        default:
            break
        }
    }
    
}
