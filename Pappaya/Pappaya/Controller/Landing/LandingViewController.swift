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
    
    //MARK:-- Class
    var timeSheetDetail : TimeSheetDetailModel = TimeSheetDetailModel()
    
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 300
        
        let projectDetail : TimeSheetProjectDetailModel = TimeSheetProjectDetailModel()
        projectDetail.projectName = "Android Project"
        projectDetail.isBillable = "Billable"
        
        let dateDetail : TimeSheetDateDetailModel = TimeSheetDateDetailModel()
        dateDetail.dateString = "21/11/2016"
        dateDetail.comment = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras nec metus vel mauris volutpat sodales."
        dateDetail.hoursWorked = "6 hrs"
        
        let dateDetail1 : TimeSheetDateDetailModel = TimeSheetDateDetailModel()
        dateDetail1.dateString = "22/11/2016"
        dateDetail1.comment = "Suspendisse erat est, maximus ut ipsum nec, imperdiet laoreet lectus. Ut condimentum tempus ipsum vel dapibus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Fusce auctor vulputate nunc sit amet pulvinar. Aliquam erat volutpat. Integer semper metus eget eros elementum mollis. Aenean orci orci, interdum laoreet suscipit quis, fermentum id diam."
        dateDetail1.hoursWorked = "08:30 hrs"
        
        let dateDetail2 : TimeSheetDateDetailModel = TimeSheetDateDetailModel()
        dateDetail2.dateString = "22/11/2016"
        dateDetail2.comment = "Suspendisse erat est, maximus ut ipsum nec, imperdiet laoreet lectus. Ut condimentum tempus ipsum vel dapibus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Fusce auctor vulputate nunc sit amet pulvinar. Aliquam erat volutpat."
        dateDetail2.hoursWorked = "07:30 hrs"
        
        projectDetail.timeSheetDateDetailArray.append(dateDetail)
        projectDetail.timeSheetDateDetailArray.append(dateDetail1)
        projectDetail.timeSheetDateDetailArray.append(dateDetail2)
        
        timeSheetDetail.timeSheetProjectArray.append(projectDetail)
        
        // Do any additional setup after loading the view.
        
        //self.addLeftBarButtonWithImage(UIImage(named : "icon-menu")!)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews()
    {
        //self.tableView.reloadData()
        
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
    
    //MARK:-- Date conversion Function
    
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
    
}
