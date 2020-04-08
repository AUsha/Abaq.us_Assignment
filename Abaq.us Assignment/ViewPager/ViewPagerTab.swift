//
//  ViewPagerTab.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 07/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.

import Foundation
import UIKit

public enum ViewPagerTabType {
    /// Tab contains text only.
    case basic
    /// Tab contains images only.
    case image
    /// Tab contains image with text. Text is shown at the bottom of the image
    case imageWithText
}

public struct ViewPagerTab {
    
    public var title:String!
    public var image:UIImage?
    
    public init(title:String, image:UIImage?) {
        self.title = title
        self.image = image
    }
}
