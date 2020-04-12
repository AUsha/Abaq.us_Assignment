//
//  TaskModel.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 11/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import Foundation
import ObjectMapper

class TaskModel : NSObject, Mappable {
    
    var title: String?
    var status: Int?
    var id: Int?

    override init() {
        super.init()
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["task"]
        status <- map["state"]
        id <- map["id"]
    }

}
