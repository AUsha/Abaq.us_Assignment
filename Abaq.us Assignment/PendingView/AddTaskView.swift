//
//  AddTaskView.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 10/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit

protocol AddTaskViewProtocol{
    func addTasks()
}

class AddTaskView: UIView {

    @IBOutlet var doneButton: UIButton!
    @IBOutlet var titleTexTField: UITextField!
    
    var delegate : AddTaskViewProtocol!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func nibName() -> String {
        return String(describing: self)
    }

    @IBAction func doneButtonAction(_ sender: Any) {
        if titleTexTField.text != "" {
             delegate.addTasks()
        }
        self.removeFromSuperview()
    }
}
