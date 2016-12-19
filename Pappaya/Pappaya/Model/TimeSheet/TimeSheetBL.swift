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
    
    func convertTimeSheetDetailFromServerToModel(detailDict : NSDictionary)
    {
        self.myTimeSheetList = convertTimeSheetDetailToModel(detailList:detailDict["my_time_sheet"] as! [NSDictionary])
        self.timeSheetToApproveList = convertTimeSheetDetailToModel(detailList:detailDict["time_sheet_to_approve"] as! [NSDictionary])
    }
    
    func getCurrentWeekTimeSheet() -> TimeSheetDetailModel?
    {
        var timeSheetDetail : TimeSheetDetailModel?
        let currentDate = Date().dateWithOutTime()
        for detail in myTimeSheetList
        {
            if (detail.fromDateObject.timeIntervalSince1970 <= currentDate.timeIntervalSince1970 && detail.toDateObject.timeIntervalSince1970 >= currentDate.timeIntervalSince1970)
            {
                timeSheetDetail = detail
                break
            }
        }
        return timeSheetDetail
    }
    
    func sampleDemoData()
    {
        let sampleData : NSDictionary = ["my_time_sheet" : getTimeSheetSample(),
                                         "time_sheet_to_approve" : getTimeSheetSample()
        ]
        convertTimeSheetDetailFromServerToModel(detailDict: sampleData)
    }
    
    func getTimeSheetSample() -> [NSDictionary]
    {
        let timeSheetArray : [NSDictionary] =  [[
            "activities": [[
                "display_name": "/",
                "account_id": [
                    "id": 2,
                    "name": "[123] Project 2 - CEO 1"
                ],
                "unit_amount": 110.0,
                "date": "2016-12-24",
                "id": 113,
                "name": "/"
                ], [
                    "display_name": "/",
                    "account_id": [
                        "id": 2,
                        "name": "[123] Project 2 - CEO 1"
                    ],
                    "unit_amount": 111.0,
                    "date": "2016-12-23",
                    "id": 112,
                    "name": "/"
                ]],
            "detail": [
                "timesheet_ids": [
                    113,
                    112
                ],
                "employee_id": [
                    "id": 24,
                    "name": "Karthik Selvaraj"
                ],
                "user_id": [
                    "id": 38,
                    "name": "Karthik Selvaraj"
                ],
                "date_from": "2016-12-23",
                "total_timesheet": 221.0,
                "state": "done",
                "account_ids": [[
                    "id": 2,
                    "name": "[123] Project 2 - CEO 1"
                    ]],
                "date_to": "2017-01-04",
                "id": 31
            ]
            ], [
                "activities": [[
                    "display_name": "/",
                    "account_id": [
                        "id": 2,
                        "name": "[123] Project 2 - CEO 1"
                    ],
                    "unit_amount": 110.0,
                    "date": "2016-12-13",
                    "id": 111,
                    "name": "/"
                    ], [
                        "display_name": "/",
                        "account_id": [
                            "id": 2,
                            "name": "[123] Project 2 - CEO 1"
                        ],
                        "unit_amount": 110.0,
                        "date": "2016-12-12",
                        "id": 110,
                        "name": "/"
                    ]],
                "detail": [
                    "timesheet_ids": [
                        111,
                        110
                    ],
                    "employee_id": [
                        "id": 24,
                        "name": "Karthik Selvaraj"
                    ],
                    "user_id": [
                        "id": 38,
                        "name": "Karthik Selvaraj"
                    ],
                    "date_from": "2016-12-12",
                    "total_timesheet": 220.0,
                    "state": "draft",
                    "account_ids": [[
                        "id": 2,
                        "name": "[123] Project 2 - CEO 1"
                        ]],
                    "date_to": "2016-12-20",
                    "id": 30
                ]
            ], [
                "activities": [
                    
                ],
                "detail": [
                    "timesheet_ids": [
                        
                    ],
                    "employee_id": [
                        "id": 24,
                        "name": "Karthik Selvaraj"
                    ],
                    "user_id": [
                        "id": 38,
                        "name": "Karthik Selvaraj"
                    ],
                    "date_from": "2016-12-05",
                    "total_timesheet": 0.0,
                    "state": "draft",
                    "account_ids": [
                        
                    ],
                    "date_to": "2016-12-11",
                    "id": 28
                ]
            ], [
                "activities": [[
                    "display_name": "/",
                    "account_id": [
                        "id": 2,
                        "name": "[123] Project 2 - CEO 1"
                    ],
                    "unit_amount": 110.0,
                    "date": "2016-12-24",
                    "id": 113,
                    "name": "/"
                    ], [
                        "display_name": "/",
                        "account_id": [
                            "id": 2,
                            "name": "[123] Project 2 - CEO 1"
                        ],
                        "unit_amount": 111.0,
                        "date": "2016-12-23",
                        "id": 112,
                        "name": "/"
                    ]],
                "detail": [
                    "timesheet_ids": [
                        113,
                        112
                    ],
                    "employee_id": [
                        "id": 24,
                        "name": "Karthik Selvaraj"
                    ],
                    "user_id": [
                        "id": 38,
                        "name": "Karthik Selvaraj"
                    ],
                    "date_from": "2016-12-23",
                    "total_timesheet": 221.0,
                    "state": "done",
                    "account_ids": [[
                        "id": 2,
                        "name": "[123] Project 2 - CEO 1"
                        ]],
                    "date_to": "2017-01-04",
                    "id": 31
                ]
            ], [
                "activities": [[
                    "display_name": "/",
                    "account_id": [
                        "id": 2,
                        "name": "[123] Project 2 - CEO 1"
                    ],
                    "unit_amount": 110.0,
                    "date": "2016-12-13",
                    "id": 111,
                    "name": "/"
                    ], [
                        "display_name": "/",
                        "account_id": [
                            "id": 2,
                            "name": "[123] Project 2 - CEO 1"
                        ],
                        "unit_amount": 110.0,
                        "date": "2016-12-12",
                        "id": 110,
                        "name": "/"
                    ]],
                "detail": [
                    "timesheet_ids": [
                        111,
                        110
                    ],
                    "employee_id": [
                        "id": 24,
                        "name": "Karthik Selvaraj"
                    ],
                    "user_id": [
                        "id": 38,
                        "name": "Karthik Selvaraj"
                    ],
                    "date_from": "2016-12-12",
                    "total_timesheet": 220.0,
                    "state": "draft",
                    "account_ids": [[
                        "id": 2,
                        "name": "[123] Project 2 - CEO 1"
                        ]],
                    "date_to": "2016-12-20",
                    "id": 30
                ]
            ], [
                "activities": [
                    
                ],
                "detail": [
                    "timesheet_ids": [
                        
                    ],
                    "employee_id": [
                        "id": 24,
                        "name": "Karthik Selvaraj"
                    ],
                    "user_id": [
                        "id": 38,
                        "name": "Karthik Selvaraj"
                    ],
                    "date_from": "2016-12-05",
                    "total_timesheet": 0.0,
                    "state": "draft",
                    "account_ids": [
                        
                    ],
                    "date_to": "2016-12-11",
                    "id": 28
                ]
            ]]
        
        return timeSheetArray
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
