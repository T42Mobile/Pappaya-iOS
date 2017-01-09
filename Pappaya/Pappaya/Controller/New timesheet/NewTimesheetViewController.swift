//
//  NewTimesheetViewController.swift
//  Pappaya
//
//  Created by Thirumal on 05/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class NewTimesheetViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK:- Variables
    //MARK:-- Outlet
    
    @IBOutlet weak var fromDateTxtField: UITextField!
    @IBOutlet weak var toDateTxtField: UITextField!
    @IBOutlet weak var nonBillableBtn: UIButton!
    @IBOutlet weak var billableBtn: UIButton!
    @IBOutlet weak var projectTxtField: UITextField!
    
    //MARK:-- Class
    
    var projectList : [TimeSheetProjectModel] = []
    var fromDate : Date = Date()
    var toDate : Date = Date()
    var selectedIndex : IndexPath = IndexPath(row: 0, section: 0)
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.projectList = TimeSheetBL.sharedInstance.getProjectList()
        self.billableButtonClicked(self.billableBtn)
        self.addDoneButtonToTextField()
        toDate = getDateWithIntervalFromDate(date: Date(), interval: 6)
        setDateToTextField(date: fromDate, textField: fromDateTxtField)
        setDateToTextField(date: toDate, textField: toDateTxtField)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //self.navigationController!.navigationBar.topItem?.title = ""
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
    
    //MARK:- Textfield
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField != self.projectTxtField
        {
            let datePickerView:UIDatePicker = UIDatePicker()
            if textField.tag == 1
            {
                datePickerView.setDate(fromDate, animated: false)
            }
            else if textField.tag == 2
            {
                datePickerView.setDate(toDate, animated: false)
            }
            datePickerView.tag = textField.tag
            datePickerView.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(NewTimesheetViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        if sender.tag == 1
        {
            fromDate = sender.date
        }
        else if sender.tag == 2
        {
            toDate = sender.date
        }
        
        if getIntervalBetweenToDate(fromDate : fromDate , toDate : toDate).day! < 6
        {
            if sender.tag == 1
            {
                toDate = getDateWithIntervalFromDate(date: fromDate, interval: 6)
            }
            else if sender.tag == 2
            {
                fromDate = getDateWithIntervalFromDate(date: toDate, interval: -6)
            }
        }
        
        setDateToTextField(date: fromDate, textField: fromDateTxtField)
        setDateToTextField(date: toDate, textField: toDateTxtField)
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
        projectTxtField.inputAccessoryView = toolbarDone
        
        let projectPickerView:UIPickerView = UIPickerView()
        projectPickerView.frame.size.height = 160
        projectPickerView.delegate = self
        projectPickerView.dataSource = self
        self.projectTxtField.inputView = projectPickerView
        
        if projectList.count > 0
        {
            self.pickerView(projectPickerView, didSelectRow: 0, inComponent: 0)
        }
    }
    
    func doneButtonClicked()
    {
        self.view.endEditing(true)
    }
    
    func getDateWithIntervalFromDate(date : Date, interval : Int) -> Date
    {
        let calender = Calendar(identifier: Calendar.Identifier.gregorian)
        
        if let intervalDate = calender.date(byAdding: Calendar.Component.day, value: interval, to: date)
        {
            return intervalDate
        }
        return date
    }
    
    func setDateToTextField(date : Date , textField : UITextField)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        textField.text = dateFormatter.string(from: date)
    }
    
    func getIntervalBetweenToDate(fromDate : Date, toDate : Date) -> DateComponents
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let from = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: fromDate)
        let to = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: toDate)
        
        return calendar.dateComponents([.day], from: from!, to: to!)
    }
    
    @IBAction func saveButtonActionClicked(_ sender: UIBarButtonItem)
    {
        if projectTxtField.text?.characters.count == 0
        {
            _ = CustomAlertController.alert(title: "Warning", message: "Please select project name")
        }
        else if getIntervalBetweenToDate(fromDate : fromDate , toDate : toDate).day! < 6
        {
            _ = CustomAlertController.alert(title: "Warning", message: "Please select atleast 7 days")
        }
        else if TimeSheetBL.sharedInstance.checkTimeSheetOverLap(fromDate: fromDate, toDate: toDate)
        {
            _ = CustomAlertController.alert(title: "Warning", message: "Time sheet cannot overlap")
        }
        else
        {
            CustomActivityIndicator.shared.showProgressView()
            ServiceHelper.sharedInstance.createTimeSheetForPeriod(fromDate: fromDate, toDate: toDate, completionHandler: { (detailDict, error) -> Void in
                CustomActivityIndicator.shared.hideProgressView()
                if let dict = detailDict
                {
                    let status = dict["status"] as! Int
                    
                    if status == 200
                    {
                        self.saveCreatedTimeSheetDetail(detail: dict)
                    }
                    else
                    {
                        _ = CustomAlertController.alert(title: "Alert", message: "Please try again later.")
                    }
                }
                else
                {
                    _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
                }
            })
        }
    }
    
    //MARK:- Picker view delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return projectList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return projectList[row].projectName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedIndex = IndexPath(row: row, section: component)
        self.projectTxtField.text = projectList[row].projectName
    }
    
    private func saveCreatedTimeSheetDetail(detail : NSDictionary)
    {
        let timeSheetId = detail["sheet_id"] as! Int
        
        TimeSheetBL.sharedInstance.saveTimeSheetDetail(detail: detail["detail"] as! NSDictionary)
        
        let timeSheetDateList = getTimeSheetDateList(timeSheetId: timeSheetId)
        var timeSheetDetail = TimeSheetBL.sharedInstance.getTimeSheetDetailForTimeSheetId(timeSheetId: timeSheetId)
        
        timeSheetDetail.totalHoursWorked = Double(timeSheetDateList.count) * 8.0
        
        let timeSheetDetailViewController = getViewControllerWithIdentifier(identifier: Constants.ViewControllerIdentifiers.TimeSheetDetailViewController) as! TimeSheetDetailViewController
        timeSheetDetailViewController.timeSheetDetail = timeSheetDetail
        timeSheetDetailViewController.timeSheetDateList = timeSheetDateList
        timeSheetDetailViewController.timeSheetType = TimeSheetListView.MyTimeSheet
        
        _ = self.navigationController?.popViewController(animated: false)
        getAppDelegate().rootNavigationController.pushViewController(timeSheetDetailViewController, animated: true)
        
    }
    
    private func getTimeSheetDateList(timeSheetId : Int) -> [TimeSheetDateModel]
    {
        var timeSheetDateList : [TimeSheetDateModel] = []
        
        let interval = getIntervalBetweenToDate(fromDate: fromDate, toDate: toDate).day!
        let selectedProject = projectList[selectedIndex.row]
        
        for index : Int in 0 ..< interval + 1
        {
            let timeSheetDateModel = TimeSheetDateModel()
            let date = getDateWithIntervalFromDate(date: fromDate, interval: index).dateWithOutTime()
            timeSheetDateModel.dateObject = date
            timeSheetDateModel.dateString = convertDateToString(date: date, format: Constants.DateConstants.DateFormatFromServer)
            timeSheetDateModel.comment = "/"
            timeSheetDateModel.projectName = selectedProject.projectName
            timeSheetDateModel.projectId = selectedProject.projectId
            timeSheetDateModel.timeSheetId = timeSheetId
            timeSheetDateModel.isBillable = self.billableBtn.isSelected
            
            timeSheetDateList.append(timeSheetDateModel)
        }
        return timeSheetDateList
    }
}
