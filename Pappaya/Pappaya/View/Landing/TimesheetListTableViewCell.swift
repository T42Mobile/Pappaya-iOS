//
//  TimesheetListTableViewCell.swift
//  Pappaya
//
//  Created by Thirumal on 02/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class TimesheetListTableViewCell: UITableViewCell
{
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        setCornerRadiusForView(periodLabel, cornerRadius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStatusImage(status : TimeSheetStatus)
    {
        let imageDict : [String : String] = [TimeSheetStatus.Open.rawValue : "icon_open" , TimeSheetStatus.WaitingForApproval.rawValue : "icon_waiting" , TimeSheetStatus.Approved.rawValue : "icon_approved"]
        
        let titleDict : [String : String] = [TimeSheetStatus.Open.rawValue : "Open" , TimeSheetStatus.WaitingForApproval.rawValue : "Waiting Approval" , TimeSheetStatus.Approved.rawValue : "Approved"]
        
        self.statusButton.setImage(UIImage(named: imageDict[status.rawValue]!), for: UIControlState.normal)
        self.statusButton.setTitle(titleDict[status.rawValue], for: UIControlState.normal)
    }

}
