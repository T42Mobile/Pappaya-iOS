//
//  Constants.swift
//  Pappaya
//
//  Created by Thirumal on 28/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import Foundation

struct Constants
{
    struct ViewControllerIdentifiers
    {
        static let UserSideMenuViewController : String = "userMenu_VC"
        static let LandingViewController: String = "landingVC"
        static let MyTimesheetViewController : String = "myTimeSheetVC"
        static let TimeSheetToApproveViewController : String = "timeSheetToApproveVC"
        static let NewTimesheetViewController : String = "newTimesheetVC"
        static let TimeSheetDetailViewController : String = "timeSheetDetailVC"
        static let EmptyStateViewController : String = "emptyState_VC"
        static let AddTimeSheetDateViewController : String = "addTimeSheetDate_vc"
    }
    
    struct StoryBoardIdentifiers
    {
        static let Main : String = "Main"
    }
    
    struct TableViewCellIdentifier
    {
        static let MenuCell : String = "menuTableCell"
        static let MenuSectionCell : String = "menuSectionCell"
        static let TimeSheetRowCell : String = "timeSheetRowCell"
        static let TimeSheetSectionCell : String = "timeSheetSectionCell"
        static let TimeSheetListCell : String = "timeSheetListCell"
        static let ProjectListCell : String = "projectListCell"
    }
    
    struct SegueIdentifier
    {
        static let NewTimeSheetSegueIdentifier : String = "newTimeSheet_SG"
        static let AddTimeSheetSegueIdentifier : String = "addTimeSheet_SG"
    }
    
    struct Color
    {
        static let NavigetionRedColor = getUIColorForRGB(185, green: 11, blue: 30)
        static let GreenColor = getUIColorForRGB(26, green: 127, blue: 64)
    }
    
    struct UserDefaultsKey
    {
        static let UserFirstName : String = "userFirstName"
        static let UserLastName : String = "userLastName"
        static let IsManager : String = "isManager"
        static let DBName : String = "dbName"
        static let UserName : String = "userName"
        static let Password : String = "password"
        static let UserImage : String = "userImage"
        static let UserId : String = "userId"
    }
    
    struct DateConstants
    {
        static let DateFormatFromServer : String = "yyyy-MM-dd"
        static let CommonDateFormat : String = "dd MMM, yyyy"
        static let CommonTimeZone : TimeZone = TimeZone.init(secondsFromGMT: 0)!
    }
    
    struct ServiceApi
    {
//        static let DomainUrl : String = "192.168.43.94:8069"
        static let DomainUrl : String = ".pappaya.co.uk"
        static let Login : String = "login"
        static let CreateTimeSheet : String = "create"
        static let UpdateTimeSheet : String = "update"
        static let UpdateTimeSheetStatus : String = "update_status"
        static let ListOfProjects : String = "project_list"
        static let TimeSheetList : String = "timesheet"
    }
    
}

//MARK:- Enum

enum TimeSheetStatus : String
{
    case Open = "draft"
    case WaitingForApproval = "confirm"
    case Approved = "done"
}

enum BillableStatus : String
{
    case Billable = "Billable"
    case Non_Billable = "Non-Billable"
}

enum TimeSheetListView : String
{
    case MyTimeSheet
    case TimeSheetToApprove
}

enum AddTimeSheetType : String
{
    case Create
    case Edit
}

