//
//  TimeSheetDetailViewController.swift
//  Pappaya
//
//  Created by Thirumal on 28/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class TimeSheetDetailViewController: UIViewController, UITableViewDelegate , UITableViewDataSource
{
    //MARK:- Variables
    //MARK:-- Outlet
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var tableEmptyStateView: UIView!
    
    @IBOutlet weak var rightBtn: RoundCornerButton!
    @IBOutlet weak var leftBtn: RoundCornerButton!
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
        self.bottomViewHgtCnt.constant = 0
        if timeSheetType == TimeSheetListView.TimeSheetToApprove
        {
            self.leftBtn.setTitle("Reject", for: UIControlState.normal)
            self.rightBtn.setTitle("Accept", for: UIControlState.normal)
            self.bottomViewHgtCnt.constant = 34
        }
        else
        {
            if timeSheetDetail.status == TimeSheetStatus.Open
            {
                self.leftBtn.setTitle("Save", for: UIControlState.normal)
                self.rightBtn.setTitle("Submit", for: UIControlState.normal)
                self.bottomViewHgtCnt.constant = 34
                self.addBtn.isHidden = false
                self.emptyStateAddBtn.isHidden = false
            }
        }
        
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
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TimeSheetRowCell, for: indexPath) as! TimeSheetDateCell
        let dateDetail = timeSheetDateList[indexPath.row]
        cell.commentTxtView.text = dateDetail.comment
        cell.dateLabel.attributedText = getDisplayDate(dateObject: dateDetail.dateObject)
        cell.timeLabel.text = String(dateDetail.hoursWorked) + " Hrs"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if timeSheetDetail.status == TimeSheetStatus.Open
        {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let update = UITableViewRowAction(style: .normal, title: "Edit") { action, indexPath in
            self.performSegue(withIdentifier: Constants.SegueIdentifier.AddTimeSheetSegueIdentifier, sender: "edit")
            self.tableView.reloadData()
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            _ = CustomAlertController.alert(title: "Confirm", message:  "Are you sure you want to delete this time sheet date.", buttons: ["Cancel","Delete"], tapBlock: { (alert, index) in
                if index == 1
                {
                    self.timeSheetDateList.remove(at: indexPath.row)
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
    
    @IBAction func newTimeSheetButtonClicked(_ sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: Constants.SegueIdentifier.NewTimeSheetSegueIdentifier, sender: nil)
    }
    
    @IBAction func addTimeSheetButtonClicked(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: Constants.SegueIdentifier.AddTimeSheetSegueIdentifier, sender: "add")
    }
    
    @IBAction func leftButtonAction(_ sender: RoundCornerButton)
    {
        if timeSheetType == TimeSheetListView.TimeSheetToApprove
        {
            
        }
        else
        {
            
        }
    }
    
    @IBAction func rightButtonAction(_ sender: RoundCornerButton)
    {
        if timeSheetType == TimeSheetListView.TimeSheetToApprove
        {
            
        }
        else
        {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.AddTimeSheetSegueIdentifier
        {
            let addViewController = segue.destination as! AddTimeSheetViewController
           // addViewController.timeSheetDetail = self.timeSheetDetail
            
            if let indexPath = sender as? IndexPath
            {
                addViewController.selectedIndexPath = indexPath
            }
        }
    }
    
    //MARK:- Private function
    
    private func setTimeSheetDetail()
    {
        self.employeeName.text = self.timeSheetDetail.employeeName
        self.timeLabel.text = convertDateToString(date: self.timeSheetDetail.fromDateObject, format: Constants.DateConstants.CommonDateFormat) + "  to  " + convertDateToString(date: self.timeSheetDetail.toDateObject, format: Constants.DateConstants.CommonDateFormat)
        self.totalHoursLabel.text = String(self.timeSheetDetail.totalHoursWorked) + " Hrs"
        self.tableView.reloadData()
    }
    
}
