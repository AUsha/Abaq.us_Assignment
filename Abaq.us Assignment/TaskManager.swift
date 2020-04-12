//
//  TaskManager.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 11/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit

class TaskManager {
    
    static let sharedInstance = TaskManager()
    
    func getTaskData(callback:@escaping (_ result: [TaskModel]?, _ error:Error?) -> Void) {
        ServiceLayer.sharedInstance.getTasksData() {
            (result, error) in
            
            if error == nil {
                callback(result,nil)
                
            } else {
                print(error as Any)
                callback(nil,error)
                
            }
            
        }
    }
}
