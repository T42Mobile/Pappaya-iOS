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
}
