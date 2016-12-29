//
//  UserSideMenuViewController.swift
//  Pappaya
//
//  Created by Thirumal on 28/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class UserSideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Variables
    // MARK: -- Outlets
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    // MARK: -- Class
    
    var menuDataList : [[SideMenuModel]] = []
    
    var userLandingVC: UIViewController!
    
    var previouslySelectedIndex : IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        menuDataList = [
            [SideMenuModel.init(imageName : "icon_weekly" , detailText : "Weekly"), SideMenuModel.init(imageName : "icon_myTimeSheet" , detailText : "My timesheet")
            ],
            [SideMenuModel.init(imageName : "icon_logout" , detailText : "Logout")
            ]
        ]
        
        if getBoolValueForKey(key: Constants.UserDefaultsKey.IsManager)
        {
           menuDataList[0].append(SideMenuModel.init(imageName : "icon_timeSheetApprove" , detailText : "Timesheet to approve"))
        }
        self.nameLabel.text = getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.UserFirstName) + " "  + getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.UserLastName)
        self.profileImageButton.setImage(getUserImage(), for: UIControlState.normal)
        CustomActivityIndicator.shared.showProgressView()
        ServiceHelper.sharedInstance.getListOfTimeSheet(completionHandler: { (detailDict, error) -> Void in
            CustomActivityIndicator.shared.hideProgressView()
            if let dict = detailDict
            {
                TimeSheetBL.sharedInstance.convertTimeSheetDetailFromServerToModel(detailDict: dict)
                
                // Post notification
                NotificationCenter.default.post(name: Notification.Name("updateWeekly"), object: nil)
            }
            else
            {
                _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
            }
        })
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table Data source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return menuDataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuDataList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.MenuCell, for: indexPath) as! MenuTableViewCell
        let menuDetailModel = menuDataList[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        cell.menuDetailLabel.text = menuDetailModel.detailText
        cell.menuImageView.image = UIImage(named: menuDetailModel.imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        userLandingVC.slideMenuController()?.toggleLeft()
        
        if previouslySelectedIndex != indexPath
        {
            previouslySelectedIndex = indexPath
            if indexPath.section == 0
            {
                var identifier : String = ""
                switch indexPath.row
                {
                case 0:
                    identifier = Constants.ViewControllerIdentifiers.LandingViewController
                    break
                case 1:
                    identifier = Constants.ViewControllerIdentifiers.MyTimesheetViewController
                    break
                case 2:
                    identifier = Constants.ViewControllerIdentifiers.TimeSheetToApproveViewController
                    break
                default:
                    identifier = ""
                    break
                }
                
                changeRootNavigationController(landingViewIdentifier: identifier)
            }
            else
            {
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                UserDefaults.standard.synchronize()
                let loginView = UIStoryboard(name: Constants.StoryBoardIdentifiers.Main, bundle: nil).instantiateInitialViewController()
                getAppDelegate().window?.rootViewController = loginView
            }
        }
    }
    
    // Section
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.MenuSectionCell) as! MenuSectionTableViewCell
        if section == 0
        {
            cell.sectionLabel.text = "Timesheets"
        }
        else if section == 1
        {
            cell.sectionLabel.text = "General Setting"
        }
        return cell.contentView
    }
    
    // MARK:- Private functions
    
    private func getUserImage() -> UIImage
    {
        if let userImageData = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.UserImage) as? Data
        {
            if let image = UIImage(data: userImageData)
            {
                return image
            }
        }
        return UIImage(named: "logo_pappaya")!
    }
}
