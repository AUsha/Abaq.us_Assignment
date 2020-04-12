//
//  PendingTableViewCell.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 09/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit

class PendingTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
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
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.cancelButton.isHidden = true
        Helpers.sharedInstance.cancelButtonClicked = true
    }
}
