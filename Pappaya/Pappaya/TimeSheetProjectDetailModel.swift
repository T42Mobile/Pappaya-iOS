//
//  TimeSheetProjectDetailModel.swift
//  Pappaya
//
//  Created by Thirumal on 02/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class TimeSheetProjectDetailModel: NSObject
{
    var projectName : String = ""
    var projectId : Int = 0
    var isBillable : String = ""
    var timeSheetDateDetailArray : [TimeSheetDateDetailModel] = []
}