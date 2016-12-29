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
    
    var projectList : [String] = ["Project 1" , "Project 1" ,"Project 1" ,"Project 1" , "Project 2" ,"Project 2"]
    var timeSheetDetail : TimeSheetDetailModel = TimeSheetDetailModel()
    var timeSheetDateDetail : TimeSheetDateDetailModel = TimeSheetDateDetailModel()
    var selectedIndexPath : IndexPath?
    var changeView : Bool = true
    
    //MARK:- View life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.addInputViewToTextField()
        self.addDoneButtonToTextField()
        self.billableButtonClicked(billableBtn)
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
        self.navigationController!.navigationBar.topItem?.title = ""
        
        if let indexPath = selectedIndexPath
        {
            self.timeSheetDateDetail = self.timeSheetDetail.timeSheetProjectArray[indexPath.section].timeSheetDateDetailArray[indexPath.row]
            
        }
        else
        {
            if !TimeSheetBL.sharedInstance.isGivenDateIsWithinTimeSheetPeriod(timeSheetDetail: self.timeSheetDetail, date: Date().dateWithOutTime())
            {
                timeSheetDateDetail.dateObject = self.timeSheetDetail.fromDateObject
            }
        }
        
        self.projectTxtField.text = timeSheetDateDetail.projectName
        self.timeTxtField.text = timeSheetDateDetail.hoursWorked
        setDateToTextField(date: timeSheetDateDetail.dateObject, textField: fromDateTxtField)
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
    
    @IBAction func saveButtonActionClicked(_ sender: UIBarButtonItem)
    {
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.timeTxtField.text = dateFormatter.string(from: sender.date)
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
        return projectList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.projectTxtField.text = projectList[row]
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
        timePickerView.addTarget(self, action: #selector(AddTimeSheetViewController.timePickerViewValueChanged), for: UIControlEvents.valueChanged)
        timeTxtField.inputView = timePickerView
        
        let projectPickerView:UIPickerView = UIPickerView()
        projectPickerView.frame.size.height = 160
        projectPickerView.delegate = self
        projectPickerView.dataSource = self
        self.projectTxtField.inputView = projectPickerView
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

