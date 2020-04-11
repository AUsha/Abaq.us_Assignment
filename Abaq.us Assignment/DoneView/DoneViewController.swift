//
//  DoneViewController.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 08/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit

class DoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var doneTasks = [String]()
    var deleteCell: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.allowsMultipleSelection = true
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
        cell.titleLabel.text = doneTasks[indexPath.row]
//        let holdToDelete = UILongPressGestureRecognizer(target: self, action: "longPressDelete:")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

        if let _ = deleteCell {
            cell.addGestureRecognizer(tap)
            self.tableView.allowsSelection = true
        }
        return cell
    }
    
    @objc func handleTap(_ sender: UILongPressGestureRecognizer) {

       print("Long tap")
        self.deleteButtonNavItem()
//       let longPress = sender as UILongPressGestureRecognizer
//       _ = longPress.state
//        let locationInView = longPress.location(in: self.tableView)
//        guard let indexPath = self.tableView.indexPathForRow(at: locationInView) else { return }
//        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
   func deleteButtonNavItem() {
         let addBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
         navigationItem.rightBarButtonItem = addBarButton
     }
    
}
