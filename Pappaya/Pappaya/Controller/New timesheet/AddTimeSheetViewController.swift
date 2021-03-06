//
//  AddTimeSheetViewController.swift
//  Pappaya
//
//  Created by Thirumal on 20/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class AddTimeSheetViewController:UIViewController, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate
{
    //MARK:- Variables
    //MARK:-- Outlet
    
    @IBOutlet weak var fromDateTxtField: UITextField!
    @IBOutlet weak var nonBillableBtn: UIButton!
    @IBOutlet weak var billableBtn: UIButton!
    
    @IBOutlet weak var projectTxtField: UITextField!
    @IBOutlet weak var timeTxtField: UITextField!
    @IBOutlet weak var commentTxtView: UITextView!
    
    //MARK:-- Class
    
    var projectList : [TimeSheetProjectModel] = []
    var timeSheetDetail : TimeSheetListModel = TimeSheetListModel()
    var timeSheetDateDetail : TimeSheetDateModel = TimeSheetDateModel()
    var timeSheetDateModelList : [TimeSheetDateModel] = []
    
    var changeView : Bool = true
    var selectedIndex : IndexPath = IndexPath(row: 0, section: 0)
    var viewType : AddTimeSheetType = AddTimeSheetType.Create
    var indexPath : IndexPath = IndexPath(row: 0, section: 0)
    var delegate : AddTimeSheetDelegate?
    
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.projectList = TimeSheetBL.sharedInstance.getProjectList()

        setBorderColorForView(self.commentTxtView, borderColor: getUIColorForRGB(230, green: 230, blue: 230), borderWidth: 1.0)
        setCornerRadiusForView(self.commentTxtView, cornerRadius: 5.0)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.removeObserverForKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.bindToKeyboard()
        //self.navigationController!.navigationBar.topItem?.title = ""
        
        if viewType == AddTimeSheetType.Create
        {
            if !TimeSheetBL.sharedInstance.isGivenDateIsWithinTimeSheetPeriod(timeSheetDetail: self.timeSheetDetail, date: Date().dateWithOutTime())
            {
                timeSheetDateDetail.dateObject = self.timeSheetDetail.fromDateObject
            }
        }
        
        self.projectTxtField.text = timeSheetDateDetail.projectName
        self.timeTxtField.text = String(timeSheetDateDetail.hoursWorked)
        self.commentTxtView.text = timeSheetDateDetail.comment
        self.billableBtn.isSelected = timeSheetDateDetail.isBillable
        self.nonBillableBtn.isSelected = !timeSheetDateDetail.isBillable
        setDateToTextField(date: timeSheetDateDetail.dateObject, textField: fromDateTxtField)
        self.addInputViewToTextField()
        self.addDoneButtonToTextField()
    }
    
    //MARK:- Button Action
    
    @IBAction func nonBillableButtonClicked(_ sender: UIButton)
    {
        self.nonBillableBtn.isSelected = true
        self.billableBtn.isSelected = false
        self.timeSheetDateDetail.isBillable = self.billableBtn.isSelected
    }
    
    @IBAction func billableButtonClicked(_ sender: UIButton)
    {
        self.billableBtn.isSelected = true
        self.nonBillableBtn.isSelected = false
        self.timeSheetDateDetail.isBillable = self.billableBtn.isSelected
    }
    
    @IBAction func saveButtonActionClicked(_ sender: UIBarButtonItem)
    {
        
        if viewType == AddTimeSheetType.Edit
        {
            timeSheetDateModelList.remove(at: indexPath.row)
            timeSheetDateModelList.insert(self.timeSheetDateDetail, at: indexPath.row)
        }
        
        let filterList = timeSheetDateModelList.filter { (obj1) -> Bool in
            return obj1.dateObject.compare(self.timeSheetDateDetail.dateObject) == .orderedSame
        }
        
        var totalTime : Double = 0.0

        if viewType == AddTimeSheetType.Create
        {
            totalTime += self.timeSheetDateDetail.hoursWorked
        }
        
        
        for detail in filterList
        {
            totalTime += detail.hoursWorked
        }
        
        if totalTime > 24.0
        {
            _ = CustomAlertController.alert(title: "Alert", message: "You cannot add time more than 24 hrs per day")
        }
        else
        {
            if commentTxtView.text.characters.count == 0
            {
                self.commentTxtView.text = "/"
            }
            self.timeSheetDateDetail.comment = self.commentTxtView.text!
            
            if viewType == AddTimeSheetType.Edit
            {
                timeSheetDateModelList.remove(at: indexPath.row)
                timeSheetDateModelList.insert(self.timeSheetDateDetail, at: indexPath.row)
            }
            else
            {
                timeSheetDateModelList.append(self.timeSheetDateDetail)
            }
            self.delegate?.updateTimeSheetList(modelList: timeSheetDateModelList)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Text view delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        changeView = true
        return true
    }
    
    //MARK:- Textfield
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        changeView = false
        return true
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        timeSheetDateDetail.dateObject = sender.date
        setDateToTextField(date: timeSheetDateDetail.dateObject, textField: fromDateTxtField)
    }
    
    func timePickerViewValueChanged(sender:UIDatePicker)
    {
        var calender = Calendar(identifier: Calendar.Identifier.gregorian)
        calender.timeZone = Constants.DateConstants.CommonTimeZone
        let component = calender.dateComponents([Calendar.Component.hour,Calendar.Component.minute], from: sender.date)
        let hours = Double(component.hour!) + (Double(component.minute!) * 0.01)
        timeSheetDateDetail.hoursWorked = hours
        
        self.timeTxtField.text = String(hours)
    }
    
    func addDoneButtonToTextField()
    {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(AddTimeSheetViewController.doneButtonClicked))
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbarDone.items = [flexSpace,barBtnDone] // You can even add cancel button too
        fromDateTxtField.inputAccessoryView = toolbarDone
        timeTxtField.inputAccessoryView = toolbarDone
        projectTxtField.inputAccessoryView = toolbarDone
        commentTxtView.inputAccessoryView = toolbarDone
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
        let projectDetail = projectList[row]
        selectedIndex = IndexPath(row: row, section: component)
        self.projectTxtField.text = projectDetail.projectName
        self.timeSheetDateDetail.projectId = projectDetail.projectId
        self.timeSheetDateDetail.projectName = projectDetail.projectName
    }
    
    //MARK:- Private function
    
    private func addInputViewToTextField()
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.setDate(timeSheetDateDetail.dateObject, animated: false)
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minimumDate = self.timeSheetDetail.fromDateObject
        datePickerView.maximumDate = self.timeSheetDetail.toDateObject
        datePickerView.addTarget(self, action: #selector(AddTimeSheetViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        fromDateTxtField.inputView = datePickerView
        
        let timePickerView:UIDatePicker = UIDatePicker()
        timePickerView.datePickerMode = UIDatePickerMode.countDownTimer
        timePickerView.timeZone = Constants.DateConstants.CommonTimeZone
        timePickerView.addTarget(self, action: #selector(AddTimeSheetViewController.timePickerViewValueChanged), for: UIControlEvents.valueChanged)
        
        let date = convertDateFromString(dateString: String(timeSheetDateDetail.hoursWorked), dateFormate: "H.m")
        timePickerView.setDate(date, animated: false)
        
        timeTxtField.inputView = timePickerView
        
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
    
    //MARK:- Keyboard function 
    
    fileprivate func bindToKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(AddTimeSheetViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTimeSheetViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillHide()
    {
        if self.view.frame.origin.y != 64
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin.y = 64
            })
        }
    }
    
    func removeObserverForKeyboard()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
     func keyboardWillShow(notification: NSNotification)
     {
        if changeView
        {
            let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
            let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
            let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let bottomView = self.commentTxtView.frame.origin.y + self.commentTxtView.frame.height
            if bottomView > targetFrame.origin.y
            {
                UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
                    self.view.frame.origin.y = targetFrame.origin.y - bottomView
                },completion: nil)
            }
        }
    }
    
}

