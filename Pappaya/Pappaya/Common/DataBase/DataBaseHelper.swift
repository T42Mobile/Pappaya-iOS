//
//  DataBaseHelper.swift
//  Pappaya
//
//  Created by Thirumal on 23/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DataBaseHelper: NSObject
{
    static let sharedInstance = DataBaseHelper()
    
    func saveTimeSheetTableFromServer(detailList : [NSDictionary])
    {
        if detailList.count > 0
        {
            var dataList : [[String : Any]] = []
            
            for detail in detailList
            {
                let timeSheetDetail = detail["detail"] as! NSDictionary
                let employeeDetail = timeSheetDetail["employee_id"] as! NSDictionary
                let userDetail = timeSheetDetail["user_id"] as! NSDictionary
                let fromDate = timeSheetDetail["date_from"] as! String
                let toDate = timeSheetDetail["date_to"] as! String
                let timeSheetId  = timeSheetDetail["id"] as! Int
                
                var listOfProject : String = ""
                var listOfProjectName : String = ""
                let projectList = timeSheetDetail["account_ids"] as! [NSDictionary]
                
                for index : Int in 0 ..< projectList.count
                {
                    let projectDetail = projectList[index]
                    
                    if index > 0
                    {
                        listOfProject += ","
                        listOfProjectName += " , "
                    }
                    listOfProject += String(projectDetail["id"] as! Int)
                    listOfProjectName += projectDetail["name"] as! String
                }
                self.saveTimeSheetDateTable(timeSheetId : timeSheetId, sheetList : detail["activities"] as! [[String : Any]])
                
                let dataDict : [String : Any] =
                    [
                        TimeSheetTableColumnName.id : timeSheetId,
                        TimeSheetTableColumnName.employeeId : employeeDetail["id"] as! Int,
                        TimeSheetTableColumnName.userId : userDetail["id"] as! Int,
                        TimeSheetTableColumnName.totalHoursWorked : timeSheetDetail["total_timesheet"] as! Double,
                        TimeSheetTableColumnName.employeeName : employeeDetail["name"] as! String,
                        TimeSheetTableColumnName.fromDate : fromDate,
                        TimeSheetTableColumnName.toDate : toDate,
                        TimeSheetTableColumnName.status : timeSheetDetail["state"] as! String,
                        TimeSheetTableColumnName.fromDateObject : convertDateFromServerString(dateString: fromDate),
                        TimeSheetTableColumnName.toDateObject : convertDateFromServerString(dateString: toDate),
                        TimeSheetTableColumnName.listOfProject : listOfProject ,
                        TimeSheetTableColumnName.listOfProjectName : listOfProjectName
                ]
                dataList.append(dataDict)
            }
            DataBaseBL.sharedInstance.insertListOfDataInTable(tableName: EntityName.TimeSheetTable, dataDictList: dataList)
        }
    }
    
    func saveProjectListFromServer(projectList : [[String : Any]])
    {
        DataBaseBL.sharedInstance.insertListOfDataInTable(tableName: EntityName.TimeSheetProjectTable, dataDictList: projectList)
    }
    
    func saveTimeSheetDateTable(timeSheetId : Int , sheetList : [[String : Any]])
    {
        if sheetList.count > 0
        {
            var sheetDetailList : [[String : Any]] = []
            for dictionary in sheetList
            {
                let accountDetail : NSDictionary = dictionary["account_id"] as! NSDictionary
                let id = dictionary["id"] as! Int
                let date = dictionary["date"] as! String
                let predicate = NSPredicate(format: "id == %@", argumentArray: [id])
                if DataBaseBL.sharedInstance.checkIfDataAvailableInTable(tableName :EntityName.TimeSheetDateTable, predicate:predicate )
                {
                    DataBaseBL.sharedInstance.deleteDataInTableForAttribute(tableName : EntityName.TimeSheetDateTable , predicate : predicate)
                }
                
                let dataDict : [String : Any] =
                    [
                        TimeSheetDateTableColumnName.projectId : accountDetail["id"] as! Int ,
                        TimeSheetDateTableColumnName.projectName : accountDetail["name"] as! String,
                        TimeSheetDateTableColumnName.comment : dictionary["display_name"] as! String,
                        TimeSheetDateTableColumnName.hoursWorked : dictionary["unit_amount"] as! Double,
                        TimeSheetDateTableColumnName.date : date,
                        TimeSheetDateTableColumnName.timeSheetId : timeSheetId,
                        TimeSheetDateTableColumnName.billable : BillableStatus.Billable.rawValue,
                        TimeSheetDateTableColumnName.id : id,
                        TimeSheetDateTableColumnName.dateObject : convertDateFromString(dateString: date, dateFormate: Constants.DateConstants.DateFormatFromServer),
                        ]
                sheetDetailList.append(dataDict)
            }
            DataBaseBL.sharedInstance.insertListOfDataInTable(tableName: EntityName.TimeSheetDateTable, dataDictList: sheetDetailList)
        }
    }
    
    func deleteAllDataForTimeSheet()
    {
        DataBaseBL.sharedInstance.deleteAllDataInTable(tableName: EntityName.TimeSheetTable)
        DataBaseBL.sharedInstance.deleteAllDataInTable(tableName: EntityName.TimeSheetProjectTable)
        DataBaseBL.sharedInstance.deleteAllDataInTable(tableName: EntityName.TimeSheetDateTable)
    }
    
    func deleteTimeSheetForId(timeSheetId : Int)
    {
        let predicate = NSPredicate(format: TimeSheetTableColumnName.id + " == %@", argumentArray: [timeSheetId])
        DataBaseBL.sharedInstance.deleteDataInTableForAttribute(tableName: EntityName.TimeSheetTable, predicate: predicate)
        let predicate1 = NSPredicate(format: TimeSheetDateTableColumnName.timeSheetId + " == %@", argumentArray: [timeSheetId])
        DataBaseBL.sharedInstance.deleteDataInTableForAttribute(tableName: EntityName.TimeSheetDateTable, predicate: predicate1)
        
    }
    
    func getTimeSheetListFromDB(isMyTimeSheet : Bool) -> [TimeSheetListModel]
    {
        let userId = UserDefaults.standard.integer(forKey: Constants.UserDefaultsKey.UserId)
        
        let formatString : String!
        if isMyTimeSheet
        {
            formatString = " == %@"
        }
        else
        {
            formatString = " != %@"
        }
        let predicate = NSPredicate(format: TimeSheetTableColumnName.userId + formatString, argumentArray: [userId])
        
        let timeSheetList = DataBaseBL.sharedInstance.getObjectsFromTable(tableName: EntityName.TimeSheetTable, predicate: predicate, sortDescriptors: [NSSortDescriptor(key: TimeSheetTableColumnName.id, ascending: false)])
        
        var timeSheetModelList : [TimeSheetListModel] = []
        
        for detail in timeSheetList
        {
            timeSheetModelList.append(convertTimeSheetDetailToModel(detail : detail))
        }
        return timeSheetModelList
    }
    
    func getTimeSheetDetailForId(timeSheetId : Int) -> TimeSheetListModel
    {
        let predicate = NSPredicate(format: TimeSheetTableColumnName.id + " == %@", argumentArray: [timeSheetId])
        
        let timeSheetList = DataBaseBL.sharedInstance.getObjectsFromTable(tableName: EntityName.TimeSheetTable, predicate: predicate, sortDescriptors: [])
        
        if timeSheetList.count > 0
        {
            return convertTimeSheetDetailToModel(detail : timeSheetList[0])
        }
        else
        {
            return TimeSheetListModel()
        }
    }
    
    
    func getTimeSheetDateListForSheetId(timeSheetId : Int) -> [TimeSheetDateModel]
    {
        let predicate = NSPredicate(format: TimeSheetDateTableColumnName.timeSheetId + " == %@", argumentArray: [timeSheetId])
        
        let timeSheetList = DataBaseBL.sharedInstance.getObjectsFromTable(tableName: EntityName.TimeSheetDateTable, predicate: predicate, sortDescriptors: [NSSortDescriptor(key: TimeSheetDateTableColumnName.dateObject, ascending: true)])
        
        var timeSheetDateList : [TimeSheetDateModel] = []
        
        for detail in timeSheetList
        {
            let timeSheetDateModel : TimeSheetDateModel = TimeSheetDateModel()
            
            timeSheetDateModel.comment = detail.value(forKey: TimeSheetDateTableColumnName.comment) as! String
            timeSheetDateModel.projectName = detail.value(forKey: TimeSheetDateTableColumnName.projectName) as! String
            timeSheetDateModel.projectId = detail.value(forKey: TimeSheetDateTableColumnName.projectId) as! Int
            timeSheetDateModel.sheetId = detail.value(forKey: TimeSheetDateTableColumnName.id) as! Int
            timeSheetDateModel.timeSheetId = detail.value(forKey: TimeSheetDateTableColumnName.timeSheetId) as! Int
            timeSheetDateModel.hoursWorked = detail.value(forKey: TimeSheetDateTableColumnName.hoursWorked)as! Double
            timeSheetDateModel.dateObject = detail.value(forKey: TimeSheetDateTableColumnName.dateObject) as! Date
            timeSheetDateModel.dateString = detail.value(forKey: TimeSheetDateTableColumnName.date) as! String
            timeSheetDateModel.isBillable = BillableStatus(rawValue : detail.value(forKey: TimeSheetDateTableColumnName.billable) as! String)!
            timeSheetDateList.append(timeSheetDateModel)
        }
        return timeSheetDateList
    }
    
    func getProjectList() -> [TimeSheetProjectModel]
    {
        var projectModelList : [TimeSheetProjectModel] = []
        let projectList = DataBaseBL.sharedInstance.getAllObjectsFromTable(tableName: EntityName.TimeSheetProjectTable, sortDescriptors: [])
        for detail in projectList
        {
            let projectModel = TimeSheetProjectModel()
            projectModel.projectName = detail.value(forKey: TimeSheetProjectTableColumnName.name) as! String
            projectModel.projectId = detail.value(forKey: TimeSheetProjectTableColumnName.id) as! Int
            projectModelList.append(projectModel)
        }
        
        return projectModelList
    }
    
    private func convertTimeSheetDetailToModel(detail : NSManagedObject) -> TimeSheetListModel
    {
        var timeSheetModel : TimeSheetListModel = TimeSheetListModel()
        
        timeSheetModel.timeSheetId = detail.value(forKey: TimeSheetTableColumnName.id) as! Int
        timeSheetModel.employeeId = detail.value(forKey: TimeSheetTableColumnName.employeeId) as! Int
        timeSheetModel.employeeName = detail.value(forKey: TimeSheetTableColumnName.employeeName) as! String
        timeSheetModel.userId = detail.value(forKey: TimeSheetTableColumnName.userId) as! Int
        timeSheetModel.totalHoursWorked = detail.value(forKey: TimeSheetTableColumnName.totalHoursWorked)as! Double
        timeSheetModel.fromDate = detail.value(forKey: TimeSheetTableColumnName.fromDate) as! String
        timeSheetModel.toDate = detail.value(forKey: TimeSheetTableColumnName.toDate) as!
        String
        timeSheetModel.fromDateObject = detail.value(forKey: TimeSheetTableColumnName.fromDateObject) as! Date
        timeSheetModel.toDateObject = detail.value(forKey: TimeSheetTableColumnName.toDateObject) as! Date
        timeSheetModel.listOfProjectName = detail.value(forKey: TimeSheetTableColumnName.listOfProjectName) as! String
        timeSheetModel.status =  TimeSheetStatus(rawValue :detail.value(forKey: TimeSheetTableColumnName.status) as! String)!
        return timeSheetModel
    }
}

struct TimeSheetTableColumnName
{
    static let id : String = "id"
    static let employeeId : String = "employeeId"
    static let userId : String = "userId"
    static let totalHoursWorked : String = "totalHoursWorked"
    static let employeeName : String = "employeeName"
    static let fromDate : String = "fromDate"
    static let status : String = "status"
    static let toDate : String = "toDate"
    static let fromDateObject : String = "fromDateObject"
    static let toDateObject : String = "toDateObject"
    static let listOfProject : String = "listOfProject"
    static let listOfProjectName : String = "listOfProjectName"
}

struct TimeSheetDateTableColumnName
{
    static let projectId : String = "projectId"
    static let id : String = "id"
    static let hoursWorked : String = "hoursWorked"
    static let billable : String = "billable"
    static let comment : String = "comment"
    static let projectName : String = "projectName"
    static let date : String = "date"
    static let timeSheetId : String = "timeSheetId"
    static let dateObject : String = "dateObject"
}

struct TimeSheetProjectTableColumnName
{
    static let id : String = "id"
    static let name : String = "name"
}

