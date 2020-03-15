//
//  HistoryController.swift
//  VideoChat
//
//  Created by Dzmitry Zhuk on 6/21/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit

class HistoryController: BaseViewController {
    @IBOutlet weak var tvHistory: UITableView!
    fileprivate var lblNone: UILabel!
    
    fileprivate var inboxList = [Inbox]() {
        didSet {
            reloadViewData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lblNoInboxs = UILabel()
        lblNoInboxs.textAlignment = .center
        
        lblNoInboxs.textColor = UIColor(rgb: 0x8F8F8F)
        
        lblNoInboxs.font = UIFont.sfProTextRegularFont(17)
        tvHistory.backgroundView = lblNoInboxs
        lblNone = lblNoInboxs
        
        tvHistory.delegate = self
        tvHistory.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getHistories()
    }
    
    fileprivate func reloadViewData() {
        if inboxList.count == 0 {
            lblNone.text = "No histories"
        }
        lblNone.isHidden = inboxList.count > 0
        tvHistory.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension HistoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewCell.cellId, for: indexPath) as! HistoryViewCell
        
        cell.displayCell(inboxList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxList.count
    }
}

// MARK: - UITableViewDelegate
extension HistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(64)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// Mark: - Http
extension HistoryController {
    fileprivate func getHistories() {
        lblNone.text = "Loading..."
        let uerId = Preferences.sharedInstance.userId
        
        HttpHelper.getHistories(uerId) { arr in
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
