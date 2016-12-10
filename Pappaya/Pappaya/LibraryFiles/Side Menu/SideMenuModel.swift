//
//  DealerMenuModel.swift
//  Pappaya
//
//  Created by Thirumal on 28/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class SideMenuModel: NSObject
{
    var imageName : String!
    var detailText : String!
    var notificationIconCount : Int = 0
    
    convenience init(imageName : String , detailText : String)
    {
        self.init()
        self.imageName = imageName
        self.detailText = detailText
    }
    
    convenience init(imageName : String)
    {
        self.init()
        self.imageName = imageName
        self.detailText = ""
    }
}
