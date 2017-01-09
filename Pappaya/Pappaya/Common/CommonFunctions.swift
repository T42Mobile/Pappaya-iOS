//
//  CommonFunctions.swift
//  Pappaya
//
//  Created by Thirumal on 28/11/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView custom functions

/**
 Set border color and border width for any UIView class 
 
 - Parameter view : UIView - UIView for which border color and border width to be set.
 - Parameter borderColor : UIColor - Color of border
 - Parameter borderWidth : CGFloat - Border width (EX : 1.0 , 2.0)
 */

func setBorderColorForView(_ view : UIView , borderColor : UIColor , borderWidth : CGFloat)
{
    view.layer.borderColor = borderColor.cgColor
    view.layer.borderWidth = borderWidth
    view.layer.masksToBounds = true
}

/**
 Set cornerRadius for any UIView class
 
 - Parameter view : UIView - UIView for which cornerRadius to be set.
 - Parameter cornerRadius : CGFloat - cornerRadius (EX : 1.0 , 2.0)
 */

func setCornerRadiusForView(_ view : UIView , cornerRadius : CGFloat)
{
    view.layer.cornerRadius = cornerRadius
    view.layer.masksToBounds = true
}

/**
 Set Shadow effect for any UIView class
 
 - Parameter view : UIView - UIView for which cornerRadius to be set.
 - Parameter cornerRadius : CGFloat - cornerRadius (EX : 1.0 , 2.0)
 */

func setShadowForView(_ view : UIView , cornerRadius : CGFloat , shadowOpacity : Float)
{
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 2
    view.layer.shadowOpacity = shadowOpacity
}

// MARK: - Color functions

/**
 Get the color for given hexa Int 
 
 - Parameter netHex : Int - Hexa decimal value (Ex: 0xFFFFFF)
 - Returns UIColor
    
*/

func getUIColorForHexaCode(_ netHex:Int) -> UIColor
{
    return UIColor(red: CGFloat((netHex >> 16) & 0xff) / 255.0, green: CGFloat((netHex >> 8) & 0xff) / 255.0, blue: CGFloat(netHex & 0xff) / 255.0, alpha: 1.0)
}

/**
 Get the color for given hexa String
 
 - Parameter hex:String - Hexa decimal value (Ex: ffffff)
 - Returns UIColor
 
 */

func getUIColorForHexaString(_ hex:String) -> UIColor
{
    
    var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines as CharacterSet).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

/**
 Get the color for given RGB value
 
 - Parameter red : CGFloat - Value for red code
 - Parameter green : CGFloat - Value for green code
 - Parameter blue : CGFloat - Value for blue code
 - Returns UIColor
 */

func getUIColorForRGB(_ red : CGFloat , green : CGFloat , blue : CGFloat) -> UIColor
{
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
}

// MARK: - General function

/**
  Get the instance of the appDelegate for application
 
 - Returns AppDelegate instance of the application
*/

func getAppDelegate() -> AppDelegate
{
    return UIApplication.shared.delegate as! AppDelegate
}

/**
 Change the root view controller of application window
 
 - Parameter viewControllerIdentifier : String - ViewController identifier of destination view controller
 */

func setViewControllerAsRootView(_ viewControllerIdentifier : String)
{
    if let window = getAppDelegate().window
    {
        
        let storyboard = window.rootViewController?.storyboard
        let desiredViewController = storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier)
        
        let snapshot:UIView = window.snapshotView(afterScreenUpdates: true)!
        desiredViewController?.view.addSubview(snapshot)
        
        window.rootViewController = desiredViewController
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview()
        })
    }
}

/**
 Get the main screen bounds of the window
    
 - Returns : CGRect
 */

func getMainScreenFrame() -> CGRect
{
    return UIScreen.main.bounds
}

/**
  Set Status bar backGround color  
 
 - Parameter color: UIColor - Status bar color
*/

func setStatusBarBackgroundColor(_ color: UIColor) {
    
    guard  let statusBar = (UIApplication.shared.value(forKey: "statusBar") as? UIView) else {
        return
    }
    statusBar.backgroundColor = color
}

/**
 Get the Average color from the given image
 
 - Parameter image : UIImage - Image for which average color has to be find.
 - Returns UIColor - Average color from image if no color is found white color will be returned
*/

func getAverageColorFromImage(_ image : UIImage) -> UIColor
{
    let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
    let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    
    let info = CGImageAlphaInfo.premultipliedLast.rawValue
    if let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info)
    {
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        if rgba[3] > 0
        {
            let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
            let multiplier: CGFloat = alpha / 255.0
            return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
        }
        else
        {
            return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
        }
    }
    
    return UIColor.white
}

func createImageFromView(_ view : UIView) -> UIImage
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img!
}

func setRootViewControllerForWindow(landingViewIdentifier : String)
{
    let appDelegate = getAppDelegate()
    let storyboard = UIStoryboard(name: Constants.StoryBoardIdentifiers.Main, bundle: nil)
    
    let mainViewController = storyboard.instantiateViewController(withIdentifier: landingViewIdentifier) as! SlideDelegateViewController
    
    let leftViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.UserSideMenuViewController) as! UserSideMenuViewController
    
    appDelegate.rootNavigationController = UINavigationController(rootViewController: mainViewController)
    
    leftViewController.userLandingVC = appDelegate.rootNavigationController
    
     appDelegate.slideMenuController = SlideMenuController(mainViewController:appDelegate.rootNavigationController, leftMenuViewController: leftViewController)
    appDelegate.slideMenuController.automaticallyAdjustsScrollViewInsets = true
    appDelegate.slideMenuController.delegate = mainViewController

    let window = appDelegate.window!
    window.rootViewController = appDelegate.slideMenuController
    window.makeKeyAndVisible()
}

func changeRootNavigationController(landingViewIdentifier : String)
{
    let appDelegate = getAppDelegate()
    let storyboard = UIStoryboard(name: Constants.StoryBoardIdentifiers.Main, bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: landingViewIdentifier) as! SlideDelegateViewController
    
    appDelegate.rootNavigationController.popToRootViewController(animated: false)
    appDelegate.rootNavigationController.pushViewController(mainViewController, animated: false)
    appDelegate.slideMenuController.delegate = mainViewController
}

//MARK:- Date Functions

func getDisplayDate(fromDate : Date , toDate : Date) -> NSAttributedString
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM y"
    
    let attributedString = NSMutableAttributedString()
    
    attributedString.append(NSAttributedString(string: dateFormatter.string(from: fromDate), attributes: [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13) ]))
    
    attributedString.append(NSAttributedString(string: "\n\n To \n\n", attributes: [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 11) ]))
        
    attributedString.append(NSAttributedString(string: dateFormatter.string(from: toDate), attributes: [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 13) ]))
    
    return attributedString
}

func convertDateFromString(dateString : String , dateFormate : String) -> Date
{
    let dateFormatter = getDateFormatterInFormat(formatString: dateFormate)
    if let date = dateFormatter.date(from: dateString)
    {
        return date
    }
    return Date().dateWithOutTime()
}

func getDisplayDateFromDateString(fromDate : String , toDate : String) -> NSAttributedString
{
    let fromDateObject = convertDateFromString(dateString: fromDate, dateFormate: Constants.DateConstants.DateFormatFromServer)
    let toDateObject = convertDateFromString(dateString: toDate, dateFormate: Constants.DateConstants.DateFormatFromServer)
    return getDisplayDate(fromDate: fromDateObject, toDate: toDateObject)
}

func saveDetailsToUserDefault(detailDict : [String : Any])
{
    UserDefaults.standard.setValuesForKeys(detailDict)
    UserDefaults.standard.synchronize()
}

func getStringForKeyFromUserDefaults(key : String) -> String
{
    if let value = UserDefaults.standard.string(forKey: key)
    {
        return value
    }
    return ""
}


func getBoolValueForKey(key : String) -> Bool
{
    return UserDefaults.standard.bool(forKey: key)
}

func getDateFormatterInCommonFormat() -> DateFormatter
{
    return getDateFormatterInFormat(formatString: Constants.DateConstants.CommonDateFormat)
}

func getDateFormatterInFormat(formatString : String) ->DateFormatter
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatString
    dateFormatter.timeZone = Constants.DateConstants.CommonTimeZone
    return dateFormatter
}

func convertDateFromServerString(dateString : String) -> Date
{
    return convertDateFromString(dateString: dateString, dateFormate: Constants.DateConstants.DateFormatFromServer)
}

func convertDateToString(date : Date , format : String) -> String
{
    let dateFormatter = getDateFormatterInFormat(formatString: format)
    return dateFormatter.string(from: date)
}

func checkInternetConnection() -> Bool
{
    if let reachabilityStatus = Reachability()?.isReachable
    {
        return reachabilityStatus
    }
    return false
}

func getViewControllerWithIdentifier(identifier : String) -> UIViewController
{
    return UIStoryboard(name: Constants.StoryBoardIdentifiers.Main, bundle: nil).instantiateViewController(withIdentifier: identifier)
}








