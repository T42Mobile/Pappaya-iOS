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
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    
    //MARK:-- Class
    var timeSheetDetail : TimeSheetDetailModel = TimeSheetDetailModel()
    
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setCornerRadiusForView(createBtn, cornerRadius: 5)
        self.tableView.estimatedRowHeight = 300
        
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Table View data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return timeSheetDetail.timeSheetProjectArray[section].timeSheetDateDetailArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return timeSheetDetail.timeSheetProjectArray.count
    }
    
    //MARK:-- Section
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionView = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TimeSheetSectionCell) as! TimeSheetSectionCell
        
        
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
        
        return cell
    }
    
    //MARK:- Date conversion Function
    
    fileprivate func getDisplayDate(dateObject : Date) -> NSAttributedString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        let attributedString = NSMutableAttributedString()

        attributedString.append(NSAttributedString(string: dateFormatter.string(from: dateObject), attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 13) ]))
        
        dateFormatter.dateFormat = "dd"
        
        attributedString.append(NSAttributedString(string: "\n" + dateFormatter.string(from: dateObject) + "\n", attributes: [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20) ]))
        
        dateFormatter.dateFormat = "MMM , YYYY"
        
        attributedString.append(NSAttributedString(string: dateFormatter.string(from: dateObject), attributes: [ NSFontAttributeName: UIFont.systemFont(ofSize: 13) ]))
        
        return attributedString
    }
    
    //MARK:- Private function 
    
    private func setTimeSheetDetail(timeSheetDetail : TimeSheetDetailModel)
    {
        self.timeSheetDetail = timeSheetDetail
        self.timeLabel.text = convertDateToString(date: self.timeSheetDetail.fromDateObject, format: Constants.DateConstants.CommonDateFormat) + " To " + convertDateToString(date: self.timeSheetDetail.toDateObject, format: Constants.DateConstants.CommonDateFormat)
        self.totalHoursLabel.text = self.timeSheetDetail.totalHoursWorked + " Hrs"
        self.tableView.reloadData()
    }
    
}
