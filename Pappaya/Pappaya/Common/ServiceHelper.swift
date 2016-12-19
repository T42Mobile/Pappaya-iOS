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
    var returnValue : AnyObject?
}

class ServiceHelper: NSObject
{
    class func authendicateLogin(userName : String, password : String, completionHandler : (NSDictionary? , NSError?) -> Void?)
    {
        let dictionary : NSDictionary = [
            Constants.UserDefaultsKey.UserFirstName : "Thirumal" , Constants.UserDefaultsKey.UserLastName : "Sivakumar" , Constants.UserDefaultsKey.IsManager : true
        ]
        completionHandler(dictionary, nil)
    }
    
    func serviceCall()
    {
        let parameters = ["name": "", "password": ""] as Dictionary<String, String>
        
        //create the url with URL
        let url = URL(string: "http://myServerName.com/api")! //change the url       
        
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
        
        
    }
    
    func webServiceCall(urlRequest : URLRequest , completionHandler : @escaping (WebServiceDataModel) -> Void?)
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
                        print(json)
                        webServiceData.returnValue = json as AnyObject?
                    }
                    else
                    {
                        webServiceData.error = NSError(domain: "Pappaya", code: 101, userInfo: [NSLocalizedFailureReasonErrorKey : "Invalid data"])
                    }
                }
                catch
                {
                    webServiceData.error = NSError(domain: "Pappaya", code: 101, userInfo: [NSLocalizedFailureReasonErrorKey : "Invalid data"])
                    print("error in JSONSerialization")
                }
            }
            DispatchQueue.global(qos: .userInitiated).async
                {
                completionHandler(webServiceData)
            }
        })
        task.resume()
    }
}
