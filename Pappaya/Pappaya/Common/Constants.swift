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
    }
    
    struct DateConstants
    {
        static let DateFormatFromServer : String = "yyyy-MM-dd"
        static let CommonDateFormat : String = "dd MMM, yyyy"
        static let CommonTimeZone : TimeZone = TimeZone.init(secondsFromGMT: 0)!
    }
    
}

//MARK:- Enum

enum TimeSheetStatus : String
{
    case Open = "draft"
    case WaitingForApproval = "confirm"
    case Approved = "done"
    case Rejected = "rejected"
}

enum BillableStatus : String
{
    case Billable = "Billable"
    case Non_Billable = "Non-Billable"
}

