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
    
    //MARK:- Public function
    
    func checkTimeSheetOverLap(fromDate : Date , toDate : Date) -> Bool
    {
        var isTimeSheetAvailable : Bool = false
        
        for detail in self.getMyTimeSheetList()
        {
            if (detail.fromDateObject.timeIntervalSince1970 <= fromDate.timeIntervalSince1970 && detail.toDateObject.timeIntervalSince1970 >= fromDate.timeIntervalSince1970) || (detail.fromDateObject.timeIntervalSince1970 <= toDate.timeIntervalSince1970 && detail.toDateObject.timeIntervalSince1970 >= toDate.timeIntervalSince1970)
            {
                isTimeSheetAvailable = true
                break
            }
        }
        return isTimeSheetAvailable
    }
    
    func getMyTimeSheetList() -> [TimeSheetListModel]
    {
        return DataBaseHelper.sharedInstance.getTimeSheetListFromDB(isMyTimeSheet: true)
    }
    
    func getTimeSheetToApproveList() -> [TimeSheetListModel]
    {
        return DataBaseHelper.sharedInstance.getTimeSheetListFromDB(isMyTimeSheet: false)
    }
    
    func getProjectList() -> [TimeSheetProjectModel]
    {
        return DataBaseHelper.sharedInstance.getProjectList()
    }
    
    func convertTimeSheetDetailFromServerToModel(detailDict : NSDictionary)
    {
        let mySheetList = detailDict["my_time_sheet"] as! [NSDictionary]
        let approveList = detailDict["time_sheet_to_approve"] as! [NSDictionary]
        DataBaseHelper.sharedInstance.deleteAllDataForTimeSheet()
        
        DataBaseHelper.sharedInstance.saveTimeSheetTableFromServer(detailList: mySheetList + approveList)
        DataBaseHelper.sharedInstance.saveProjectListFromServer(projectList: detailDict["project_list"] as! [[String : Any]])
    }
    
    func getTimeSheetDateListForTimeSheetId(timeSheetId : Int) -> [TimeSheetDateModel]
    {
        return DataBaseHelper.sharedInstance.getTimeSheetDateListForSheetId(timeSheetId: timeSheetId)
    }
    
    func getTimeSheetDetailForTimeSheetId(timeSheetId : Int) -> TimeSheetListModel
    {
        return DataBaseHelper.sharedInstance.getTimeSheetDetailForId(timeSheetId: timeSheetId)
    }
    
    func getCurrentWeekTimeSheet() -> TimeSheetListModel?
    {
        var timeSheetDetail : TimeSheetListModel?
        let currentDate = Date().dateWithOutTime()
        for detail in self.getMyTimeSheetList()
        {
            if isGivenDateIsWithinTimeSheetPeriod(timeSheetDetail: detail, date: currentDate)
            {
                timeSheetDetail = detail
                break
            }
        }
        return timeSheetDetail
    }
    
    func isGivenDateIsWithinTimeSheetPeriod(timeSheetDetail : TimeSheetListModel , date : Date) -> Bool
    {
        if (timeSheetDetail.fromDateObject.timeIntervalSince1970 <= date.timeIntervalSince1970 && timeSheetDetail.toDateObject.timeIntervalSince1970 >= date.timeIntervalSince1970)
        {
            return true
        }
        return false
    }
    
    func getWeekNameForDates(fromDate : Date) -> String
    {
        let calendar = Calendar.current
        let dateComponent = calendar.component(Calendar.Component.weekOfYear, from: fromDate)
        return  "Week " + String(dateComponent)
    }
    
    func saveTimeSheetDetail(detail : NSDictionary)
    {
        let timeSheetDetail = detail["detail"] as! NSDictionary
        let timeSheetId  = timeSheetDetail["id"] as! Int
        DataBaseHelper.sharedInstance.deleteTimeSheetForId(timeSheetId:timeSheetId)
        DataBaseHelper.sharedInstance.saveTimeSheetTableFromServer(detailList: [detail])
    }
    
    func deleteTimeSheetId(timeSheetId : Int)
    {
        DataBaseHelper.sharedInstance.deleteTimeSheetForId(timeSheetId:timeSheetId)
    }
    
    func updateStateForTimeSheetId(sheetId : Int, status : TimeSheetStatus)
    {
        let predicate = NSPredicate(format: TimeSheetTableColumnName.id + " == %@", argumentArray: [sheetId])
        DataBaseBL.sharedInstance.updateRowsInTable(tableName: EntityName.TimeSheetTable, dataDict: [TimeSheetTableColumnName.status : status.rawValue], predicate: predicate)
    }
    
    func updateStateForTimeSheetLineId(lineId : Int, status : TimeSheetLineStatus)
    {
        let predicate = NSPredicate(format: TimeSheetDateTableColumnName.id + " == %@", argumentArray: [lineId])
        DataBaseBL.sharedInstance.updateRowsInTable(tableName: EntityName.TimeSheetDateTable, dataDict: [TimeSheetDateTableColumnName.status : status.rawValue], predicate: predicate)
    }
    
}
