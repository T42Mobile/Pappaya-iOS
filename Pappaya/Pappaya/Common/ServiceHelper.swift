//
//  ServiceHelper.swift
//  Pappaya
//
//  Created by Thirumal on 15/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class WebServiceDataModel: NSObject
{
    var error : Error?
    var returnValue : Any?
}

class ServiceHelper: NSObject
{
    static let sharedInstance = ServiceHelper()
    
    //MARK:- Login
    
    func authendicateLogin(userName : String, password : String, dbName : String ,completionHandler : @escaping (NSDictionary? , NSError?) -> Void?)
    {
        let urlRequest = getUrlRequestWithUrl(urlString: Constants.ServiceApi.Login, hostName : dbName, postData: ["db" : dbName,"login" : userName, "password" : password])
        webServiceCall(urlRequest: urlRequest, completionHandler:{ (serviceResultModel) -> Void in
                completionHandler(serviceResultModel.returnValue as? NSDictionary,serviceResultModel.error as NSError?)
        })
    }
    
    //MARK:- Time Sheet
    
    func getListOfTimeSheet(completionHandler : @escaping (NSDictionary? , NSError?) -> Void?)
    {
        let urlRequest = getUrlRequestWithUrl(urlString: Constants.ServiceApi.TimeSheetList, hostName : getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.DBName), postData: getDefaultLoginDetail())
        webServiceCall(urlRequest: urlRequest, completionHandler:{ (serviceResultModel) -> Void in
            completionHandler(serviceResultModel.returnValue as? NSDictionary,serviceResultModel.error as NSError?)
        })
    }
    
    func createTimeSheetForPeriod(fromDate : Date , toDate : Date, completionHandler : @escaping (NSDictionary? , NSError?) -> Void?)
    {
        var createPostData = getDefaultLoginDetail()
        createPostData["name"] = TimeSheetBL.sharedInstance.getWeekNameForDates(fromDate: fromDate)
        createPostData["from_date"] = convertDateToString(date: fromDate, format: Constants.DateConstants.DateFormatFromServer)
        createPostData["to_date"] = convertDateToString(date: toDate, format: Constants.DateConstants.DateFormatFromServer)
        createPostData["lines"] = []
        print(createPostData)
        let urlRequest = getUrlRequestWithUrl(urlString: Constants.ServiceApi.CreateTimeSheet, hostName : getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.DBName), postData: createPostData)
        webServiceCall(urlRequest: urlRequest, completionHandler:{ (serviceResultModel) -> Void in
            completionHandler(serviceResultModel.returnValue as? NSDictionary,serviceResultModel.error as NSError?)
        })
    }
    
    func updateTimeSheetForId(sheetId : Int, lines : [NSDictionary], completionHandler : @escaping (NSDictionary? , NSError?) -> Void?)
    {
        var updatePostData = getDefaultLoginDetail()
        updatePostData["lines"] = lines
        updatePostData["sheet_id"] = sheetId
        let urlRequest = getUrlRequestWithUrl(urlString: Constants.ServiceApi.UpdateTimeSheet, hostName : getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.DBName), postData: updatePostData)
        webServiceCall(urlRequest: urlRequest, completionHandler:{ (serviceResultModel) -> Void in
            completionHandler(serviceResultModel.returnValue as? NSDictionary,serviceResultModel.error as NSError?)
        })
    }
    
    func updateStatusForTimeSheetId(sheetId : Int, status : String, completionHandler : @escaping (NSDictionary? , NSError?) -> Void?)
    {
        var updatePostData = getDefaultLoginDetail()
        updatePostData["state"] = status
        updatePostData["sheet_id"] = sheetId
        let urlRequest = getUrlRequestWithUrl(urlString: Constants.ServiceApi.UpdateTimeSheetStatus, hostName : getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.DBName), postData: updatePostData)
        webServiceCall(urlRequest: urlRequest, completionHandler:{ (serviceResultModel) -> Void in
            completionHandler(serviceResultModel.returnValue as? NSDictionary,serviceResultModel.error as NSError?)
        })
    }
    
    func getDefaultLoginDetail() -> [String : Any]
    {
       return [
        "db" : getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.DBName),
               "login" : getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.UserName),
               "password" : getStringForKeyFromUserDefaults(key: Constants.UserDefaultsKey.Password)
        ]
    }
    
    func getUrlRequestWithUrl(urlString : String,hostName : String, postData : [String : Any]) -> URLRequest
    {
        let parameters =
            [
                "jsonrpc":"2.0","method":"call","id":"2","params":postData
                ] as Dictionary<String, Any>
        
        //create the url with URL
        let url = URL(string: "https://" + hostName + Constants.ServiceApi.DomainUrl + "/mobile/" + urlString)!
        
//        let url = URL(string: "http://" + Constants.ServiceApi.DomainUrl + "/mobile/" + urlString)!
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func webServiceCall(urlRequest : URLRequest , completionHandler : @escaping (WebServiceDataModel) -> Void?)
    {
        if checkInternetConnection()
        {
            //create the session object
            let session = URLSession.shared
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: urlRequest , completionHandler: { data, response, error in
                
                let webServiceData = WebServiceDataModel()
                if error != nil
                {
                    webServiceData.error = error
                }
                else
                {
                    do
                    {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        {
                            
                            if let result = json["result"]
                            {
                                webServiceData.returnValue = result
                            }
                            else
                            {
                                print(json)
                                webServiceData.error = self.getLocalErrorWithCode(errorCode: 103, errorMessage: "Internal server error, Please try again later.")
                            }
                        }
                        else
                        {
                            webServiceData.error = self.getLocalErrorWithCode(errorCode: 102, errorMessage: "Json error, Please try again later.")
                        }
                    }
                    catch
                    {
                        webServiceData.error = self.getLocalErrorWithCode(errorCode: 101, errorMessage: "Invalid Data, Please try again later.")
                    }
                }
                DispatchQueue.main.async(){
                    completionHandler(webServiceData)
                }
            })
            task.resume()
        }
        else
        {
            let serviceError = WebServiceDataModel()
            serviceError.error = self.getLocalErrorWithCode(errorCode: 100, errorMessage: "No Internet connection, Please try again later.")
            completionHandler(serviceError)
        }
    }
    
    func getLocalErrorWithCode(errorCode : Int, errorMessage : String) -> NSError
    {
       return NSError(domain: "Pappaya", code: errorCode, userInfo: [NSLocalizedDescriptionKey : errorMessage])
    }
}
