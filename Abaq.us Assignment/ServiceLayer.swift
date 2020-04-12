//
//  ServiceLayer.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 08/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import Foundation
import MBProgressHUD
import ObjectMapper

class ServiceLayer {
    
    static let sharedInstance = ServiceLayer()
    
    func getTasksData(callback:@escaping (_ result: [TaskModel]?, _ error:Error?) -> Void) {
        let url = URL(string: "https://my-json-server.typicode.com/karthikraj-duraisamy/todoendpoint/tasks")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
                callback(nil,error)
            }else{
                if let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                    let taskResult = Mapper<TaskModel>().mapArray(JSONArray: json)
                    callback(taskResult,nil)
                }
                callback(nil, error)
            }
        }).resume()
    }
}
