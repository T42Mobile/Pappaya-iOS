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
    var fromDateObject : Date = Date().dateWithOutTime()
    var toDateObject : Date = Date().dateWithOutTime()
    var employeeName : String = ""
    var employeeId : Int = 0
    var userId : Int = 0
    var timeSheetId : Int = 0
    var status : TimeSheetStatus = TimeSheetStatus.WaitingForApproval
    var totalHoursWorked : String = ""
    var listOfProjectName : String = ""
    var timeSheetProjectArray : [TimeSheetProjectDetailModel] = []
    
    convenience init(dictionary : NSDictionary)
    {
        self.init()
        
        let timeSheetDetail = dictionary["detail"] as! NSDictionary
        
        let employeeDetail = timeSheetDetail["employee_id"] as! NSDictionary
        self.employeeId = employeeDetail["id"] as! Int
        self.employeeName = employeeDetail["name"] as! String
        
        let userDetail = timeSheetDetail["user_id"] as! NSDictionary
        self.userId = userDetail["id"] as! Int
        
        self.fromDate = timeSheetDetail["date_from"] as! String
        self.fromDateObject = convertDateFromServerString(dateString: self.fromDate)
        
        self.toDate = timeSheetDetail["date_to"] as! String
        self.toDateObject = convertDateFromServerString(dateString: self.toDate)
        self.totalHoursWorked = String(timeSheetDetail["total_timesheet"] as! Double)
        self.timeSheetId = timeSheetDetail["id"] as! Int
        
        let sheetList = convertListOfSheetIntoModelList(sheetList: dictionary["activities"] as! [NSDictionary])
        
        self.timeSheetProjectArray = []
        
        let projectList = timeSheetDetail["account_ids"] as! [NSDictionary]
        
        for projectDetail in projectList
        {
            let projectModel = TimeSheetProjectDetailModel()
            projectModel.projectName = projectDetail["name"] as! String
            projectModel.projectId = projectDetail["id"] as! Int
            projectModel.timeSheetDateDetailArray = filterTimeSheetModelList(timeSheetList: sheetList, projectId: projectModel.projectId)
            projectModel.timeSheetId = self.timeSheetId
            self.timeSheetProjectArray.append(projectModel)
        }
    }
    
    private func convertListOfSheetIntoModelList(sheetList : [NSDictionary]) -> [TimeSheetDateDetailModel]
    {
        var sheetModelList : [TimeSheetDateDetailModel] = []
        for sheetDetail in sheetList
        {
            sheetModelList.append(TimeSheetDateDetailModel(dictionary: sheetDetail))
        }
        return sheetModelList
    }
    
    private func filterTimeSheetModelList(timeSheetList : [TimeSheetDateDetailModel] , projectId : Int) -> [TimeSheetDateDetailModel]
    {
       return timeSheetList.filter { (timeSheetModel) -> Bool in
            timeSheetModel.projectId == projectId
            }
    }
    
}

struct TimeSheetListModel
{
    var fromDate : String = ""
    var toDate : String = ""
    var fromDateObject : Date = Date().dateWithOutTime()
    var toDateObject : Date = Date().dateWithOutTime()
    var employeeName : String = ""
    var employeeId : Int = 0
    var userId : Int = 0
    var timeSheetId : Int = 0
    var status : TimeSheetStatus = TimeSheetStatus.WaitingForApproval
    var totalHoursWorked : Double = 0.0
    var listOfProjectName : String = ""
}
