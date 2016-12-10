//
//  NewTimesheetViewController.swift
//  Pappaya
//
//  Created by Thirumal on 05/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class NewTimesheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate
{
    //MARK:- Variables
    //MARK:-- Outlet
    
    @IBOutlet weak var fromDateTxtField: UITextField!
    @IBOutlet weak var toDateTxtField: UITextField!
    @IBOutlet weak var nonBillableBtn: UIButton!
    @IBOutlet weak var billableBtn: UIButton!
    @IBOutlet weak var projectBtn: UIButton!
    
    //MARK:-- Class
    
    var tableView : UITableView = UITableView()
    var projectList : [String] = ["Project 1" , "Project 1" ,"Project 1" ,"Project 1" , "Project 2" ,"Project 2"]
    var fromDate : Date = Date()
    var toDate : Date = Date()
    
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.billableBtn.isSelected = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.TableViewCellIdentifier.ProjectListCell)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.addDoneButtonToTextField()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        setShadowForView(tableView, cornerRadius : 5, shadowOpacity : 2.0)
        self.view.addSubview(tableView)
    }
    //MARK:- Button Action
    @IBAction func nonBillableButtonClicked(_ sender: UIButton)
    {
        self.nonBillableBtn.isSelected = true
        self.billableBtn.isSelected = false
    }
    
    @IBAction func billableButtonClicked(_ sender: UIButton)
    {
        self.billableBtn.isSelected = true
        self.nonBillableBtn.isSelected = false
    }
    
    @IBAction func projectButtonClicked(_ sender: UIButton)
    {
        showTableView()
    }
    
    func showTableView()
    {
        tableView.alpha = 0.0
        tableView.frame = projectBtn.frame
        tableView.frame.size.height = 0
        
        var tableHeight : CGFloat = 176
        
        if projectList.count < 4
        {
            tableHeight = CGFloat(projectList.count) * 44.0
        }
        UIView.animate(withDuration: 0.3, animations:
            {
                self.tableView.frame.size.height = tableHeight
                self.tableView.alpha = 1.0
        }
        )
    }
    
    //MARK:- TableView 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return projectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ProjectListCell, for: indexPath)
        cell.textLabel?.text = projectList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.projectBtn.setTitle(projectList[indexPath.row], for: UIControlState.normal)
        self.tableView.frame.size.height = 0
        self.tableView.alpha = 0.0
    }
    
    //MARK:- Textfield
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.setDate(Date(), animated: false)
        datePickerView.tag = textField.tag
        datePickerView.datePickerMode = UIDatePickerMode.date
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(NewTimesheetViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let dateText = dateFormatter.string(from: sender.date)
        
        if sender.tag == 1
        {
            fromDate = sender.date
            fromDateTxtField.text = dateText
        }
        else if sender.tag == 2
        {
            toDate = sender.date
            toDateTxtField.text = dateText
        }
    }
    
    func addDoneButtonToTextField()
    {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(NewTimesheetViewController.doneButtonClicked))
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbarDone.items = [flexSpace,barBtnDone] // You can even add cancel button too
        fromDateTxtField.inputAccessoryView = toolbarDone
        toDateTxtField.inputAccessoryView = toolbarDone
    }
    
    func doneButtonClicked()
    {
        self.view.endEditing(true)
    }

}
