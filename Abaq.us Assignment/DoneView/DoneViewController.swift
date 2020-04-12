//
//  DoneViewController.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 08/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    @IBOutlet var noTasksLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var doneTasks: [TaskModel] = []
    
    var deleteCell : ((_ deletedIds: [TaskModel]?) -> Void)?
    var resumeCell : ((_ deletedIds: [TaskModel]?) -> Void)?

    
    var matchesSelectedJobs: [TaskModel] = []
    
    var stateChangeInTasks: [TaskModel] = []
    var timerCount = 5.0
    
    var tasksStateChange : ((_ changedIds: [TaskModel]?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = .flexibleBottomMargin
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.doneTasks.count == 0 {
            self.tableView.isHidden = true
            self.noTasksLabel.isHidden = false
            
        }
        self.tableView.isHidden = false
        self.noTasksLabel.isHidden = true        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doneTasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DoneTableViewCell.identifier, for: indexPath)  as! DoneTableViewCell
        let tasks = doneTasks[indexPath.row]
        cell.bindJobData(task: tasks)
        
        if self.stateChangeInTasks.contains(doneTasks[indexPath.row]) {
                cell.cancelButton.isHidden = false
            }
            else {
                cell.cancelButton.isHidden = true
            }
        
        
        cell.checkBoxSelected(checked: false)
        if let id = tasks.id {
            if self.matchesSelectedJobs.contains(where: {($0.id == id)}) {
                cell.checkBoxSelected(checked: true)
            }
        }
        //Check Buttons callback
        cell.checkButtonCallback = {
            if let selected = self.deleteCell {
                self.matchesSelectedJobs.append(self.doneTasks[indexPath.row])
                selected(self.matchesSelectedJobs)
                
            }
        }
        cell.unCheckButtonCallback = {
            if let selected = self.resumeCell {
                let modifiedArray = self.matchesSelectedJobs.filter { $0 == self.doneTasks[indexPath.row] }
                self.matchesSelectedJobs = modifiedArray
                selected(self.matchesSelectedJobs)
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? DoneTableViewCell {
            cell.cancelButton.isHidden = false
            Helpers.sharedInstance.cancelButtonClicked = false
            Timer.scheduledTimer(withTimeInterval: timerCount, repeats: false, block: {_ in
                if Helpers.sharedInstance.cancelButtonClicked == false {
                    cell.cancelButton.isHidden = true
                    self.stateChangeInTasks.append(self.doneTasks[indexPath.row])
                    if let selected = self.tasksStateChange {
                        selected(self.stateChangeInTasks)
                    }
                }
            })
        }
    }
    
    func updateSelectedJobs(_ tasks: TaskModel) -> Bool {
        if self.doneTasks.contains(tasks) {
            self.matchesSelectedJobs.append(tasks)
            return true
        }
        return false
    }
}
