//
//  SearchController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/21/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class SearchController: BaseAuthController {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tvSearch: UITableView!
    fileprivate var lblNone: UILabel!
    
    fileprivate var users = [User]() {
        didSet {
            reloadSearchData()
        }
    }
    
    //Mark -- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.applyCustomClearButton()
        self.setTextFieldPlaceholderColor(searchBar)
        tvSearch.delegate = self
        tvSearch.dataSource = self
        
        let lblNoInboxs = UILabel()
        lblNoInboxs.textAlignment = .center
        
        lblNoInboxs.textColor = UIColor(rgb: 0x8F8F8F)
        
        lblNoInboxs.font = UIFont.sfProTextRegularFont(17)
        tvSearch.backgroundView = lblNoInboxs
        lblNone = lblNoInboxs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if users.count <= 0 {
            searchUser()
        } else {
            reloadSearchData()
        }
    }
    
    fileprivate func reloadSearchData() {
        lblNone.isHidden = users.count > 0
        if users.count == 0 {
            lblNone.text = "No search result"
        }
        
        tvSearch.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.cellId, for: indexPath) as! SearchViewCell
        
        cell.displayCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

// MARK: - UITableViewDelegate
extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(76)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let controller = UIStoryboard.chats.instantiateViewController(withIdentifier: Controllers.chatViewController) as? ChatViewController {
            controller.user = users[indexPath.row]
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension SearchController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        searchUser()
        return true
    }
}

//Mark -- Http
extension SearchController {
    fileprivate func searchUser() {
        guard let searchStr = searchBar.text else { return }
        
        lblNone.text = "Searching..."
        self.loadingIndicator.visibility = true
        HttpHelper.search(searchStr) { users in
            DispatchQueue.main.async {
                self.loadingIndicator.visibility = false
                
                if let users = users {
                    self.users = users
                } else {
                    self.users.removeAll()
                }
            }
        }
    }
}
