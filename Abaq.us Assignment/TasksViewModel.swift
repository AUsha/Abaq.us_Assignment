//
//  TasksViewModel.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 11/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import Foundation

class TasksViewModel {
    
    var taskModel: [TaskModel]?
    var serverError:Error?
    
    var isTasksSucceeded: Dynamic<Bool> = Dynamic(false)
    
    func getTasksData() {
        TaskManager.sharedInstance.getTaskData() {
            (result, error) in
            
            if error == nil {
                self.taskModel = result
                self.isTasksSucceeded.value = true
                
                
            } else {
                self.serverError = error
                self.isTasksSucceeded.value = false
            }
            
        }
    }
    
}
