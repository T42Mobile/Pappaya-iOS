//
//  TimeSheetDetailViewController.swift
//  Pappaya
//
//  Created by Thirumal on 28/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

protocol AddTimeSheetDelegate
{
    func updateTimeSheetList(modelList : [TimeSheetDateModel])
}

class TimeSheetDetailViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, AddTimeSheetDelegate
{
    //MARK:- Variables
    //MARK:-- Outlet
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var tableEmptyStateView: UIView!
    
    @IBOutlet weak var bottomViewHgtCnt: NSLayoutConstraint!
    
    @IBOutlet weak var addBtn: RoundCornerButton!
    @IBOutlet weak var emptyStateAddBtn: RoundCornerButton!
    
    //MARK:-- Class
    var timeSheetDetail : TimeSheetListModel = TimeSheetListModel()
    var timeSheetDateList : [TimeSheetDateModel] = []
    var timeSheetType : TimeSheetListView = TimeSheetListView.MyTimeSheet
    
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight = 300
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.setTimeSheetDetail()
    }
    
    //MARK:- Table View data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return timeSheetDateList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if timeSheetDateList.count == 0
        {
            tableEmptyStateView.isHidden = false
        }
        else
        {
            tableEmptyStateView.isHidden = true
        }
        return 1
    }
    
    //MARK:-- Section
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionView = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TimeSheetSectionCell) as! TimeSheetSectionCell
//        let projectDetail = timeSheetDateList[]
//        sectionView.projectLabel.text = projectDetail.projectName
//        sectionView.billableLabel.text = projectDetail.isBillable.rawValue
        
        return sectionView.contentView
    }
    
    //MARK:-- Row
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if timeSheetDateList[indexPath.row].is_timeSheet
        {
            return UITableViewAutomaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TimeSheetRowCell, for: indexPath) as! TimeSheetDateCell
        let dateDetail = timeSheetDateList[indexPath.row]
        cell.commentTxtView.text = dateDetail.comment
        cell.dateLabel.attributedText = getDisplayDate(dateObject: dateDetail.dateObject)
        cell.projectLabel.text = dateDetail.projectName
        cell.timeLabel.text = String(dateDetail.hoursWorked) + " Hrs"
        if dateDetail.isBillable
        {
            cell.billableLabel.text = "Billable"
        }
        else
        {
            cell.billableLabel.text = "Non-Billable"
        }
        let dict : [String : String] = ["draft":"Open","pending" : "Waiting for Approval","approved":"Approved","refused":"Rejected"]
        cell.statusLabel.text = dict[dateDetail.lineStatus.rawValue]
        
        if dateDetail.lineStatus == TimeSheetLineStatus.Pending && self.timeSheetType == TimeSheetListView.TimeSheetToApprove
        {
            cell.bottomView.isHidden = false
            cell.approveBtn.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
        }
        else
        {
            cell.bottomView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if timeSheetType == TimeSheetListView.MyTimeSheet
        {
            let detail = timeSheetDateList[indexPath.row]
            if detail.lineStatus == TimeSheetLineStatus.Open || detail.lineStatus == TimeSheetLineStatus.Rejected
            {
                return true
            }
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let update = UITableViewRowAction(style: .normal, title: "Edit") { action, indexPath in
            
            let addTimeSheet_VC = getViewControllerWithIdentifier(identifier: Constants.ViewControllerIdentifiers.AddTimeSheetDateViewController) as! AddTimeSheetViewController
            addTimeSheet_VC.viewType = AddTimeSheetType.Edit
            addTimeSheet_VC.timeSheetDetail = self.timeSheetDetail
            addTimeSheet_VC.timeSheetDateModelList = self.timeSheetDateList
            addTimeSheet_VC.timeSheetDateDetail = self.timeSheetDateList[indexPath.row]
            addTimeSheet_VC.delegate = self
            addTimeSheet_VC.indexPath = indexPath
            getAppDelegate().rootNavigationController.pushViewController(addTimeSheet_VC, animated: true)
            
            self.tableView.reloadData()
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            _ = CustomAlertController.alert(title: "Confirm", message:  "Are you sure you want to delete this time sheet date.", buttons: ["Cancel","Delete"], tapBlock: { (alert, index) in
                if index == 1
                {
                    if self.timeSheetDateList[indexPath.row].sheetId == 0
                    {
                        self.timeSheetDateList.remove(at: indexPath.row)
                    }
                    else
                    {
                        self.timeSheetDateList[indexPath.row].is_timeSheet = false
                    }
                    self.updateTimeSheetList(modelList: self.timeSheetDateList)
                    self.tableView.reloadData()
                }
            })
        }
        return [delete, update]
    }
    
    //MARK:- Date conversion Function
    
    fileprivate func getDisplayDate(dateObject : Date) -> NSAttributedString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: dateFormatter.string(from: dateObject).uppercased(), attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 13) ]))
        
        dateFormatter.dateFormat = "dd"
        
        attributedString.append(NSAttributedString(string: "\n" + dateFormatter.string(from: dateObject) + "\n", attributes: [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20) ]))
        
        dateFormatter.dateFormat = "MMM, YYYY"
        
        attributedString.append(NSAttributedString(string: dateFormatter.string(from: dateObject), attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 13) ]))
        
        return attributedString
    }
    
    //MARK:- Button Action
    
    @IBAction func addTimeSheetButtonClicked(_ sender: UIButton)
    {
        let addTimeSheet_VC = getViewControllerWithIdentifier(identifier: Constants.ViewControllerIdentifiers.AddTimeSheetDateViewController) as! AddTimeSheetViewController
        addTimeSheet_VC.viewType = AddTimeSheetType.Create
        addTimeSheet_VC.timeSheetDetail = self.timeSheetDetail
        addTimeSheet_VC.timeSheetDateModelList = self.timeSheetDateList
        addTimeSheet_VC.delegate = self
        getAppDelegate().rootNavigationController.pushViewController(addTimeSheet_VC, animated: true)
    }
    
    @IBAction func leftButtonAction(_ sender: RoundCornerButton)
    {
        self.updateTimeSheetDetail(isSubmit: false)
    }
    
    @IBAction func rightButtonAction(_ sender: RoundCornerButton)
    {
        self.updateTimeSheetDetail(isSubmit: true)
    }
    
    @IBAction func rejectButtonAction(_ sender: UIButton)
    {
        self.updateTimeSheetLineStatus(status: TimeSheetLineStatus.Rejected, row: sender.tag)
    }
    
    @IBAction func approveButtonAction(_ sender: UIButton)
    {
        self.updateTimeSheetLineStatus(status: TimeSheetLineStatus.Approved, row: sender.tag)
    }
    
    //MARK:- Private function
    
    func setTimeSheetDetail()
    {
        
        if timeSheetType == TimeSheetListView.MyTimeSheet
        {
            self.bottomViewHgtCnt.constant = 34
            self.addBtn.isHidden = false
            self.emptyStateAddBtn.isHidden = false
        }
        else
        {
            self.bottomViewHgtCnt.constant = 0
            self.addBtn.isHidden = true
            self.emptyStateAddBtn.isHidden = true
        }

        self.employeeName.text = self.timeSheetDetail.employeeName
        self.timeLabel.text = convertDateToString(date: self.timeSheetDetail.fromDateObject, format: Constants.DateConstants.CommonDateFormat) + "  to  " + convertDateToString(date: self.timeSheetDetail.toDateObject, format: Constants.DateConstants.CommonDateFormat)
        self.totalHoursLabel.text = String(self.timeSheetDetail.totalHoursWorked) + " Hrs"
        self.tableView.reloadData()
    }
    
    func updateTimeSheetList(modelList: [TimeSheetDateModel])
    {
        self.timeSheetDateList = modelList.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.dateObject.compare(obj2.dateObject) == .orderedAscending
        })
        var totalHrs : Double = 0.0
        for detail in self.timeSheetDateList
        {
            print(detail.sheetId)
            if detail.is_timeSheet
            {
                totalHrs += detail.hoursWorked
            }
        }
        self.timeSheetDetail.totalHoursWorked = totalHrs
        self.totalHoursLabel.text = String(totalHrs) + " Hrs"
        
        self.setTimeSheetDetail()
    }
    
    private func updateTimeSheetDetail(isSubmit : Bool)
    {
        var lineList : [NSDictionary] = []
        for detail in timeSheetDateList
        {
            if detail.lineStatus != TimeSheetLineStatus.Approved
            {
                var status = detail.lineStatus.rawValue
                if isSubmit
                {
                    status = TimeSheetLineStatus.Pending.rawValue
                }
                let lineDict : NSDictionary = [
                    "line_id" : detail.sheetId,
                    "name" : detail.comment,
                    "unit_amount" : detail.hoursWorked,
                    "account_id" : detail.projectId,
                    "is_timesheet" : detail.is_timeSheet,
                    "date" : detail.dateObject.getDateStringInServerFormat(),
                    "is_billable" : detail.isBillable,
                    "status" : status
                ]
                lineList.append(lineDict)
            }
        }
        
        if lineList.count > 0
        {
            CustomActivityIndicator.shared.showProgressView()
            ServiceHelper.sharedInstance.updateTimeSheetForId(sheetId: self.timeSheetDetail.timeSheetId, lines: lineList,  completionHandler: { (detailDict, error) -> Void in
                CustomActivityIndicator.shared.hideProgressView()
                if let dict = detailDict
                {
                    let status = dict["status"] as! Int
                    if status == 200
                    {
                        TimeSheetBL.sharedInstance.saveTimeSheetDetail(detail: dict["detail"] as! NSDictionary)
                        let sheetId = self.timeSheetDetail.timeSheetId
                        self.timeSheetDetail = TimeSheetBL.sharedInstance.getTimeSheetDetailForTimeSheetId(timeSheetId: sheetId)
                        self.timeSheetDateList = TimeSheetBL.sharedInstance.getTimeSheetDateListForTimeSheetId(timeSheetId: sheetId)
                        self.setTimeSheetDetail()
                        
                        _ = CustomAlertController.alert(title: "Success", message: "Updated successfully.")
                    }
                    else
                    {
                        _ = CustomAlertController.alert(title: "Alert", message: "Please try again later.")
                    }
                }
                else
                {
                    _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
                }
            })
        }
    }
    
    func updateTimeSheetStatus(status : TimeSheetStatus)
    {
        CustomActivityIndicator.shared.showProgressView()
        ServiceHelper.sharedInstance.updateStatusForTimeSheetId(sheetId: self.timeSheetDetail.timeSheetId, status: status.rawValue,  completionHandler: { (detailDict, error) -> Void in
            CustomActivityIndicator.shared.hideProgressView()
            if let dict = detailDict
            {
                let state = dict["status"] as! Int
                
                if state == 200
                {
                    if self.timeSheetType == TimeSheetListView.TimeSheetToApprove
                    {
                        TimeSheetBL.sharedInstance.deleteTimeSheetId(timeSheetId: self.timeSheetDetail.timeSheetId)
                        
                        var messageString : String = "Time sheet approved successfully"
                        if status == TimeSheetStatus.Open
                        {
                            messageString = "Time sheet rejected successfully"
                        }
                       _ = CustomAlertController.alert(title: "Alert", message: messageString, acceptMessage: "OK", acceptBlock: {
                            getAppDelegate().rootNavigationController.popViewController(animated: true)
                        })
                    }
                    else
                    {
                        TimeSheetBL.sharedInstance.updateStateForTimeSheetId(sheetId: self.timeSheetDetail.timeSheetId, status: TimeSheetStatus.WaitingForApproval)
                        self.timeSheetDetail.status = TimeSheetStatus.WaitingForApproval
                        _ = CustomAlertController.alert(title: "Alert", message: "Time sheet submitted successfully.")
                        self.setTimeSheetDetail()
                    }
                }
                else
                {
                    _ = CustomAlertController.alert(title: "Alert", message: "Please try again later.")
                }
            }
            else
            {
                _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
            }
        })
    }
    
    func updateTimeSheetLineStatus(status : TimeSheetLineStatus, row : Int)
    {
        CustomActivityIndicator.shared.showProgressView()
        ServiceHelper.sharedInstance.updateStatusForTimeSheetLineId(sheetId: self.timeSheetDetail.timeSheetId, status: status.rawValue, lineId : timeSheetDateList[row].sheetId ,  completionHandler: { (detailDict, error) -> Void in
            CustomActivityIndicator.shared.hideProgressView()
            if let dict = detailDict
            {
                let state = dict["status"] as! Int
                
                if state == 200
                {
                    self.timeSheetDateList[row].lineStatus = status
                    TimeSheetBL.sharedInstance.updateStateForTimeSheetLineId(lineId: self.timeSheetDateList[row].sheetId, status: status)
                    self.tableView.reloadData()
                }
                else
                {
                    _ = CustomAlertController.alert(title: "Alert", message: "Please try again later.")
                }
            }
            else
            {
                _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
            }
        })
    }
    
}
