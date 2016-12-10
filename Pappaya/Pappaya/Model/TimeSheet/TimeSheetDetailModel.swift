//
//  TimeSheetDetailModel.swift
//  Pappaya
//
//  Created by Thirumal on 02/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class TimeSheetDetailModel: NSObject
{
    var fromDate : String = ""
    var toDate : String = ""
    var employeeName : String = ""
    var employeeId : Int = 0
    var timeSheetId : Int = 0
    var status : TimeSheetStatus = TimeSheetStatus.Open
    var totalHoursWorked : String = ""
    var timeSheetProjectArray : [TimeSheetProjectDetailModel] = []
}
