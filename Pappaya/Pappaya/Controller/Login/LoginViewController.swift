//
//  LoginViewController.swift
//  Pappaya
//
//  Created by Thirumal on 29/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK :- Variable
    //MARK:-- Outlet
    @IBOutlet weak var tenantIdTxtFld: UITextField!
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var hostNameTxtFld: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:-- Class
    
    var currentTxtFld : UITextField = UITextField()
    var domainList : [String] = ["pappaya.co.uk","pappaya.com"]

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        setCornerRadiusForView(self.loginButton, cornerRadius: 5)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.bindToKeyboard()
        self.addDoneButtonToTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.removeKeyBoardObserver()
    }
    
    //MARK:- Button Action
    @IBAction func loginButtonAction(_ sender: UIButton)
    {
        if tenantIdTxtFld.text?.characters.count == 0
        {
            let _ = CustomAlertController.alert(title: "Warning", message: "Enter TenantID", acceptMessage: "OK", acceptBlock: {
                self.tenantIdTxtFld.becomeFirstResponder()
            })
        }
        else if userNameTxtFld.text?.characters.count == 0
        {
            let _ = CustomAlertController.alert(title: "Warning", message: "Enter User name", acceptMessage: "OK", acceptBlock: {
                self.userNameTxtFld.becomeFirstResponder()
            })
        }
        else if passwordTxtFld.text?.characters.count == 0
        {
            let _ = CustomAlertController.alert(title: "Warning", message: "Enter Password", acceptMessage: "OK", acceptBlock: {
                self.passwordTxtFld.becomeFirstResponder()
            })
        }
        else
        {
            self.view.endEditing(true)
            CustomActivityIndicator.shared.showProgressView()
            ServiceHelper.sharedInstance.authendicateLogin(userName: userNameTxtFld.text!, password: passwordTxtFld.text!,dbName : tenantIdTxtFld.text!,hostName : hostNameTxtFld.text! , completionHandler: { (detailDict, error) -> Void in
                
                CustomActivityIndicator.shared.hideProgressView()
                if let dict = detailDict
                {
                    let status = dict["status"] as! Int
                    if status == 200
                    {
                        self.saveLoginDetail(employeeDetail : dict)
                        setRootViewControllerForWindow(landingViewIdentifier: Constants.ViewControllerIdentifiers.LandingViewController)
                    }
                    else
                    {
                        _ = CustomAlertController.alert(title: "Alert", message: dict["message"] as! String)
                    }
                }
                else
                {
                    _ = CustomAlertController.alert(title: "Alert", message: error!.localizedDescription)
                }
            })
        }
    }
    
    //MARK:- TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        currentTxtFld = textField
        return true
    }
    
    //MARK:- Picker view delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return domainList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return domainList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.hostNameTxtFld.text = domainList[row]
    }
    
    func doneButtonClicked()
    {
        self.view.endEditing(true)
    }
    
    func addDoneButtonToTextField()
    {
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(LoginViewController.doneButtonClicked))
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbarDone.items = [flexSpace,barBtnDone] // You can even add cancel button too
        self.hostNameTxtFld.inputAccessoryView = toolbarDone
        self.tenantIdTxtFld.inputAccessoryView = toolbarDone
        userNameTxtFld.inputAccessoryView = toolbarDone
        passwordTxtFld.inputAccessoryView = toolbarDone
        
        let projectPickerView:UIPickerView = UIPickerView()
        projectPickerView.frame.size.height = 125
        projectPickerView.delegate = self
        projectPickerView.dataSource = self
        self.hostNameTxtFld.inputView = projectPickerView
        
            self.pickerView(projectPickerView, didSelectRow: 0, inComponent: 0)
    }
    
    //MARK:- Private Function
    
    fileprivate func bindToKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyBoardObserver()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillHide()
    {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
    func keyboardWillChange(notification: NSNotification)
    {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let currentViewFrame = currentTxtFld.convert(currentTxtFld.bounds, to: getAppDelegate().window)
        let bottomView = currentViewFrame.origin.y + currentViewFrame.height
        if bottomView > targetFrame.origin.y
        {
            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
                self.view.frame.origin.y = targetFrame.origin.y - bottomView
            },completion: nil)
        }
    }
    
    private func saveLoginDetail(employeeDetail : NSDictionary)
    {
        let detail = employeeDetail["detail"] as! [String : Any]
        var detailDict : [String : Any] = [
            Constants.UserDefaultsKey.DBName : self.tenantIdTxtFld.text!,
            Constants.UserDefaultsKey.UserName : self.userNameTxtFld.text!,
            Constants.UserDefaultsKey.Password : self.passwordTxtFld.text!,
            Constants.UserDefaultsKey.HostName : self.hostNameTxtFld.text!,
            Constants.UserDefaultsKey.IsManager : detail["manager"] as! Bool,
            Constants.UserDefaultsKey.UserFirstName : detail["first_name"] as! String,
            Constants.UserDefaultsKey.UserLastName : detail["last_name"] as! String,
            Constants.UserDefaultsKey.UserId : detail["user_id"] as! Int
        ]
        if let imageString = detail["image"] as? String
        {
            if let imageData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters)
            {
                detailDict[Constants.UserDefaultsKey.UserImage] = imageData
            }
        }
        saveDetailsToUserDefault(detailDict: detailDict)
    }
}
