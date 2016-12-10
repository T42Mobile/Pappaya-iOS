//
//  MenuTableViewCell.swift
//  Pappaya
//
//  Created by Thirumal on 28/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell
{
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
