//
//  EmptyStateViewController.swift
//  Pappaya
//
//  Created by Thirumal on 29/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class EmptyStateViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton)
    {
        let newTimeSheet_VC = getViewControllerWithIdentifier(identifier : Constants.ViewControllerIdentifiers.NewTimesheetViewController ) as! NewTimesheetViewController
        
        getAppDelegate().rootNavigationController.pushViewController(newTimeSheet_VC, animated: true)
    }

}
