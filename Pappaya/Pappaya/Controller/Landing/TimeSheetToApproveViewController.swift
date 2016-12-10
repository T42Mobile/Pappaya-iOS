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
        
        let timeSheetDetail = TimeSheetDetailModel()
        timeSheetDetail.fromDate = "21/11/2016"
        timeSheetDetail.toDate = "30/11/2016"
        timeSheetDetail.totalHoursWorked = "30:30 hrs"
        timeSheetDetail.status = TimeSheetStatus.Open
        
        timeSheetArray.append(timeSheetDetail)
        //self.addLeftBarButtonWithImage(UIImage(named : "icon-menu")!)
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}
