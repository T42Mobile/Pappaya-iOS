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
    @IBOutlet weak var statusImageView: UIImageView!

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
        let imageDict : [String : String] = ["open" : "icon_open" , "waiting" : "icon_waiting" , "approved" : "icon_approved", "rejected" : "icon_rejected"]
        
        self.statusImageView.image = UIImage(named: imageDict[status.rawValue]!)
    }

}
