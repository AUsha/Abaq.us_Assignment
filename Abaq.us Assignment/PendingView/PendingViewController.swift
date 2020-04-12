//
//  PendingViewController.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 08/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit

protocol AddDelegate {
    func didPressSearchButton(button: Any)
}

class PendingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var pendingTasks: [TaskModel] = []
    var stateChangeInTasks: [TaskModel] = []
    var timerCount = 5.0
    
    var tasksStateChange : ((_ changedIds: [TaskModel]?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = .flexibleBottomMargin
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.pendingTasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PendingTableViewCell.identifier, for: indexPath)  as! PendingTableViewCell
        let data = pendingTasks[indexPath.row]
        cell.titleLabel.text = data.title
        if self.stateChangeInTasks.contains(pendingTasks[indexPath.row]) {
            cell.cancelButton.isHidden = false
        }
        else {
            cell.cancelButton.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? PendingTableViewCell {
            cell.cancelButton.isHidden = false
            Helpers.sharedInstance.cancelButtonClicked = false
            Timer.scheduledTimer(withTimeInterval: timerCount, repeats: false, block: {_ in
                cell.cancelButton.isHidden = true
                if Helpers.sharedInstance.cancelButtonClicked == false {
                    self.stateChangeInTasks.append(self.pendingTasks[indexPath.row])
                    if let selected = self.tasksStateChange {
                        selected(self.stateChangeInTasks)
                    }
                }
            })
        }
    }
}

