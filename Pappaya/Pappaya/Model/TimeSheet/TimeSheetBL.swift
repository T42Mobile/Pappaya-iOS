//
//  TimeSheetBL.swift
//  Pappaya
//
//  Created by Thirumal on 17/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class TimeSheetBL: NSObject
{
    static let sharedInstance = TimeSheetBL()
    
    //MARK:- Variable
    
    var myTimeSheetList : [TimeSheetDetailModel] = []
    var timeSheetToApproveList : [TimeSheetDetailModel] = []
    
    //MARK:- Public function
    
    func checkTimeSheetOverLap(fromDate : Date , toDate : Date) -> Bool
    {
        var isTimeSheetAvailable : Bool = false
        
        for detail in myTimeSheetList
        {
            if (detail.fromDateObject.timeIntervalSince1970 <= fromDate.timeIntervalSince1970 && detail.toDateObject.timeIntervalSince1970 >= fromDate.timeIntervalSince1970) || (detail.fromDateObject.timeIntervalSince1970 <= toDate.timeIntervalSince1970 && detail.toDateObject.timeIntervalSince1970 >= toDate.timeIntervalSince1970)
            {
                isTimeSheetAvailable = true
                break
            }
        }
        return isTimeSheetAvailable
    }
    
    func convertArrayToString(projectList : [TimeSheetProjectDetailModel]) -> String
    {
        var compoundString : String = ""
        let totalCount = projectList.count
        for index :Int in 0 ..< totalCount
        {
            compoundString += projectList[index].projectName
            if index + 1 != totalCount
            {
                compoundString += ", "
            }
        }
        return compoundString
    }
    
    func getMyTimeSheetList() -> [TimeSheetListModel]
    {
        return DataBaseHelper.sharedInstance.getTimeSheetListFromDB(isMyTimeSheet: true)
    }
    
    func getTimeSheetToApproveList() -> [TimeSheetListModel]
    {
        return DataBaseHelper.sharedInstance.getTimeSheetListFromDB(isMyTimeSheet: false)
    }
    
    func convertTimeSheetDetailFromServerToModel(detailDict : NSDictionary)
    {
        let mySheetList = detailDict["my_time_sheet"] as! [NSDictionary]
        let approveList = detailDict["time_sheet_to_approve"] as! [NSDictionary]
        
        DataBaseHelper.sharedInstance.saveTimeSheetTableFromServer(detailList: mySheetList + approveList)
    }
    
    func getTimeSheetDateListForTimeSheetId(timeSheetId : Int) -> [TimeSheetDateModel]
    {
        return DataBaseHelper.sharedInstance.getTimeSheetDateListForSheetId(timeSheetId: timeSheetId)
    }
    
    func getCurrentWeekTimeSheet() -> TimeSheetDetailModel?
    {
        var timeSheetDetail : TimeSheetDetailModel?
        let currentDate = Date().dateWithOutTime()
        for detail in myTimeSheetList
        {
            if isGivenDateIsWithinTimeSheetPeriod(timeSheetDetail: detail, date: currentDate)
            {
                timeSheetDetail = detail
                break
            }
        }
        return timeSheetDetail
    }
    
    func isGivenDateIsWithinTimeSheetPeriod(timeSheetDetail : TimeSheetDetailModel , date : Date) -> Bool
    {
        if (timeSheetDetail.fromDateObject.timeIntervalSince1970 <= date.timeIntervalSince1970 && timeSheetDetail.toDateObject.timeIntervalSince1970 >= date.timeIntervalSince1970)
        {
            return true
        }
        return false
    }
    
    func convertValueFromObject(fromObject : TimeSheetDetailModel , toModel : TimeSheetDetailModel)
    {
         toModel.fromDate = fromObject.fromDate
         toModel.toDate = fromObject.toDate
         toModel.fromDateObject = fromObject.fromDateObject
         toModel.toDateObject = fromObject.toDateObject
         toModel.employeeName = fromObject.employeeName
         toModel.employeeId = fromObject.employeeId
         toModel.userId = fromObject.userId
         toModel.timeSheetId = fromObject.timeSheetId
         toModel.status = fromObject.status
         toModel.totalHoursWorked = fromObject.totalHoursWorked
    }
    
    //MARK:- Private function
    
    private func convertTimeSheetDetailToModel(detailList : [NSDictionary]) -> [TimeSheetDetailModel]
    {
        var timeSheetList : [TimeSheetDetailModel] = []
        for detail in detailList
        {
            timeSheetList.append(TimeSheetDetailModel(dictionary: detail))
        }
        return timeSheetList // sortTimeSheetList(timeSheetList: timeSheetList)
    }
    
    private func sortTimeSheetList(timeSheetList : [TimeSheetDetailModel]) -> [TimeSheetDetailModel]
    {
        let sortedTimeSheetList = timeSheetList.sorted { (obj1, obj2) -> Bool in
            obj1.fromDateObject.compare(obj2.fromDateObject) == ComparisonResult.orderedDescending
        }
        return sortedTimeSheetList
    }
}
