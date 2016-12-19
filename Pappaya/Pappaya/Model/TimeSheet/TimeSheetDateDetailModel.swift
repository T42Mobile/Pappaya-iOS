//
//  TimeSheetDateDetailModel.swift
//  Pappaya
//
//  Created by Thirumal on 02/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class TimeSheetDateDetailModel: NSObject
{
    var dateString : String = ""
    var dateObject : Date = Date()
    var hoursWorked : String = ""
    var comment : String = ""
    var projectName : String = ""
    var isBillable : String = ""
    var sheetId : Int = 0
    var projectId : Int = 0
    
    convenience init(dictionary : NSDictionary)
    {
        self.init()
        
        self.comment = dictionary["display_name"] as! String
        let accountDetail : NSDictionary = dictionary["account_id"] as! NSDictionary
        self.projectId = accountDetail["id"] as! Int
        self.projectName = accountDetail["name"] as! String
        self.hoursWorked = String(dictionary["unit_amount"] as! Double)
        self.dateString = dictionary["date"] as! String
        self.dateObject = convertDateFromString(dateString: self.dateString, dateFormate: Constants.DateConstants.DateFormatFromServer)
        self.sheetId = dictionary["id"] as! Int
    }
}
