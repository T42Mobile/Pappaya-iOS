//
//  LandingViewController.swift
//  Pappaya
//
//  Created by Thirumal on 30/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class LandingViewController: SlideDelegateViewController, UITableViewDelegate , UITableViewDataSource
{
    //MARK:- Variables
    //MARK:-- Outlet
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var tableEmptyStateView: UIView!
    
    //MARK:-- Class
    var timeSheetDetail : TimeSheetDetailModel = TimeSheetDetailModel()
    var timeSheetDateList : [TimeSheetDateModel] = []
    
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
        if let timeSheetDetailModel = TimeSheetBL.sharedInstance.getCurrentWeekTimeSheet()
        {
            self.setTimeSheetDetail(timeSheetDetail:timeSheetDetailModel)
            emptyStateView.isHidden = true
        }
        else
        {
            emptyStateView.isHidden = false
        }
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
        let projectDetail = self.timeSheetDetail.timeSheetProjectArray[section]
        sectionView.projectLabel.text = projectDetail.projectName
        sectionView.billableLabel.text = projectDetail.isBillable.rawValue        
        
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
        let dateDetail = timeSheetDetail.timeSheetProjectArray[indexPath.section].timeSheetDateDetailArray[indexPath.row]
        cell.commentTxtView.text = dateDetail.comment
        cell.dateLabel.attributedText = getDisplayDate(dateObject: dateDetail.dateObject)
        cell.timeLabel.text = dateDetail.hoursWorked + " Hrs"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
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
                    self.timeSheetDetail.timeSheetProjectArray[indexPath.section].timeSheetDateDetailArray.remove(at: indexPath.row)
                    if self.timeSheetDetail.timeSheetProjectArray[indexPath.section].timeSheetDateDetailArray.count == 0
                    {
                        self.timeSheetDetail.timeSheetProjectArray.remove(at: indexPath.section)
                    }
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
    
    @IBAction func createTimeSheetButtonClicked(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: Constants.SegueIdentifier.NewTimeSheetSegueIdentifier, sender: nil)
    }
    
    @IBAction func newTimeSheetButtonClicked(_ sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: Constants.SegueIdentifier.NewTimeSheetSegueIdentifier, sender: nil)
    }
    
    @IBAction func addTimeSheetButtonClicked(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: Constants.SegueIdentifier.AddTimeSheetSegueIdentifier, sender: "add")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.AddTimeSheetSegueIdentifier
        {
            let addViewController = segue.destination as! AddTimeSheetViewController
            addViewController.timeSheetDetail = self.timeSheetDetail
            
            if let indexPath = sender as? IndexPath
            {
                addViewController.selectedIndexPath = indexPath
            }
        }
    }
    
    //MARK:- Private function 
    
    private func setTimeSheetDetail(timeSheetDetail : TimeSheetDetailModel)
    {
        self.timeSheetDetail = timeSheetDetail
        self.timeLabel.text = convertDateToString(date: self.timeSheetDetail.fromDateObject, format: Constants.DateConstants.CommonDateFormat) + "  to  " + convertDateToString(date: self.timeSheetDetail.toDateObject, format: Constants.DateConstants.CommonDateFormat)
        self.totalHoursLabel.text = self.timeSheetDetail.totalHoursWorked + " Hrs"
        self.tableView.reloadData()
    }
    
}
