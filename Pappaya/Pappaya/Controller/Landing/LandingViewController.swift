//
//  LandingViewController.swift
//  Pappaya
//
//  Created by Thirumal on 30/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class LandingViewController: SlideDelegateViewController
{
    //MARK:- Variables
    //MARK:-- Outlet
    var checkUpdate : Bool = true
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Define identifier
        let notificationName = Notification.Name("updateWeekly")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(LandingViewController.updateView), name: notificationName, object: nil)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if checkUpdate
        {
            self.updateView()
        }
    }
    
    private lazy var emptyStateViewController: EmptyStateViewController = {
        
        // Instantiate View Controller
        var viewController = getViewControllerWithIdentifier(identifier: Constants.ViewControllerIdentifiers.EmptyStateViewController) as! EmptyStateViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var timeSheetDetailViewController: TimeSheetDetailViewController = {
        
        // Instantiate View Controller
        var viewController = getViewControllerWithIdentifier(identifier: Constants.ViewControllerIdentifiers.TimeSheetDetailViewController) as! TimeSheetDetailViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func updateView()
    {
        if let timeSheetDetail = TimeSheetBL.sharedInstance.getCurrentWeekTimeSheet()
        {
            self.checkUpdate = false
            timeSheetDetailViewController.timeSheetDetail = timeSheetDetail
            timeSheetDetailViewController.timeSheetDateList = TimeSheetBL.sharedInstance.getTimeSheetDateListForTimeSheetId(timeSheetId: timeSheetDetail.timeSheetId)
            timeSheetDetailViewController.timeSheetType = TimeSheetListView.MyTimeSheet
            timeSheetDetailViewController.setTimeSheetDetail()
             add(asChildViewController: timeSheetDetailViewController)
        }
        else
        {
            add(asChildViewController: emptyStateViewController)
        }
        
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem)
    {
        let newTimeSheet_VC = getViewControllerWithIdentifier(identifier : Constants.ViewControllerIdentifiers.NewTimesheetViewController ) as! NewTimesheetViewController
        
        getAppDelegate().rootNavigationController.pushViewController(newTimeSheet_VC, animated: true)
    }
    
}
