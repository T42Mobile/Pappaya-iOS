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
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    // MARK: -- Class
    
    var menuDataList : [[SideMenuModel]] = []
    
    var userLandingVC: UIViewController!
    
    var previouslySelectedIndex : IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        menuDataList = [[SideMenuModel.init(imageName : "icon_Pencil" , detailText : "View and Edit Profile")],[SideMenuModel.init(imageName : "icon_Stats" , detailText : "Weekly"), SideMenuModel.init(imageName : "icon_Review" , detailText : "My timesheet"), SideMenuModel.init(imageName : "icon_History" , detailText : "Timesheet to approve")]]
        
        // Do any additional setup after loading the view.
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
        //cell.menuImageView.image = UIImage(named: menuDetailModel.imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        userLandingVC.slideMenuController()?.toggleLeft()
        
        if previouslySelectedIndex != indexPath
        {
            previouslySelectedIndex = indexPath
            if indexPath.section == 1
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
        }
    }
    
    // Section
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if section == 0
        {
            let view = UIView(frame: CGRect(x: 0,y: 0,width: tableView.frame.width,height: 1))
            view.backgroundColor = getUIColorForRGB(201, green: 201, blue: 201)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.MenuSectionCell) as! MenuSectionTableViewCell
            cell.sectionLabel.text = "Timesheets"
            return cell.contentView
        }
        return nil
    }
}
