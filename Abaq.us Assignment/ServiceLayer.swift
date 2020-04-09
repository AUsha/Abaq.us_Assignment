//
//  ServiceLayer.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 08/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import Foundation
import MBProgressHUD

class ServiceLayer {
    
    var isTasksSucceeded: Dynamic<Bool> = Dynamic(false)
    var pendingTasks = [String]()
    var doneTasks = [String]()
    var progressBar:MBProgressHUD?
    
    func getTasksData() {
        let url = URL(string: "https://my-json-server.typicode.com/karthikraj-duraisamy/todoendpoint/tasks")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
                self.isTasksSucceeded.value = false
            }else{
                do{
                    
                    if let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                        for data in json {
                            if let tasks = data["state"] as? Int{
                                if tasks == 1 {
                                    if let title = data["task"] as? String {
                                        self.pendingTasks.append(title)
                                    }
                                }
                                else if let title = data["task"] as? String {
                                    self.doneTasks.append(title)
                                }
                            }
                        }
                        self.isTasksSucceeded.value = true
                    }
                }
            }
        }).resume()
    }
    
    func hideProgressIndicator() {
        guard let window = UIApplication.shared.windows.last else { return }
        MBProgressHUD.hide(for: window, animated: true)
    }
}
