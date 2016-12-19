//
//  TimeSheetToApproveViewController.swift
//  Pappaya
//
//  Created by Thirumal on 02/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class TimeSheetToApproveViewController: SlideDelegateViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Variables
    
    //MARK:-- Outlet
    
    @IBOutlet weak var tableView : UITableView!
    
    //MARK:-- Class
    
    var timeSheetArray : [TimeSheetDetailModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.timeSheetArray = TimeSheetBL.sharedInstance.timeSheetToApproveList
        self.tableView.estimatedRowHeight = 200
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Table view
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return timeSheetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TimeSheetListCell, for: indexPath) as! TimesheetListTableViewCell
        
        let timeSheetDetail = timeSheetArray[indexPath.row]
        
        cell.periodLabel.attributedText = getDisplayDateFromDateString(fromDate: timeSheetDetail.fromDate, toDate: timeSheetDetail.toDate)
        cell.totalHoursLabel.text = timeSheetDetail.totalHoursWorked
        cell.employeeName.text = timeSheetDetail.employeeName
        cell.projectNameLabel.text = TimeSheetBL.sharedInstance.convertArrayToString(projectList: timeSheetDetail.timeSheetProjectArray)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}
