//
//  DoneTableViewCell.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 09/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit

class DoneTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var selectUnselectCheckBox: UIButton!
    
    @IBOutlet var cancelButton: UIButton!
    var checkButtonCallback: (() -> Void)?
    var unCheckButtonCallback: (() -> Void)?

    
    var cancelButtonCallback: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    static var identifier: String {
        return String(describing: self)
    }
     func bindJobData(task: TaskModel) {
        self.titleLabel.text = task.title
    }
    @IBAction func checkButtonAction(_ sender: Any) {
        changeSaveBtnImage(selectUnselectCheckBox)
    }
    
    func checkBoxSelected(checked : Bool){
        if(checked == true){
            selectUnselectCheckBox.setImage(UIImage(named: "ic_checkbox-selected"), for: .normal)
        }
        else{
            selectUnselectCheckBox.setImage(UIImage(named: "ic_checkbox"), for: .normal)
        }
    }
    
    func changeSaveBtnImage(_ sender: UIButton) {
        if let myButtonImage = sender.image(for: .normal),
            let buttonAppuyerImage = UIImage(named: "ic_checkbox-selected"),
            myButtonImage.pngData() == buttonAppuyerImage.pngData()
        {
            sender.setImage(UIImage(named: "ic_checkbox"), for: .normal)
            if let unCheckButtonCallback = self.unCheckButtonCallback {
                unCheckButtonCallback()
            }
           
        } else {
            sender.setImage(UIImage(named: "ic_checkbox-selected"), for: .normal)
            if let checkButtonCallback = self.checkButtonCallback {
                checkButtonCallback()
            }
        }
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.cancelButton.isHidden = true
        Helpers.sharedInstance.cancelButtonClicked = true

    }
}
