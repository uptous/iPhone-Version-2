//
//  DataConnectionManager.swift
//  uptous
//
//  Created by Roshan Gita  on 10/20/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class DataConnectionManager: NSObject {
    
    // POST
    class func requestPOSTURL(api:String, para:Parameters ,success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void) {
        
        ActivityIndicator.show()
        
        print("RequestPOSTURL api = " + api)
        
        AF.request(api, method: .post,parameters: para, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:AFDataResponse<Any>) in
            
            ActivityIndicator.hide()
            print("RequestPostURL: result: \(response.result)")
            switch(response.result) {
                
            case .success(let result):
                success(result as AnyObject)
                break
                
            case .failure(let error):
                /*if response.result.isFailure {
                 let error : Error = response.result.error!
                 failure(error)
                 }*/
                
                //let message : String
                if let httpStatusCode = response.response?.statusCode {
                    if (httpStatusCode == 401) {
                        self.relogin()
                    }
                    //switch(httpStatusCode) {
                    //case 400:
                        //message = "Username or password not provided."
                    //case 401:
                        //message = "Incorrect password for user '."
                        //self.relogin()
                        
                    //default :
                        //message = ""
                    //}
                } else {
                        failure(error)
                }
                // display alert with error message
                break
            }

        }
    }
    
    // GET
    class func requestGETURL(api:String, para: [String : String] ,success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        
         ActivityIndicator.show()
        
        print("RequestGETURL api = " + api)
         
        AF.request(api, method: .get, parameters: nil, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:AFDataResponse<Any>) in
            
            ActivityIndicator.hide()
            switch response.result {
            case .success(let result):
                success(result)
                break
                
            case .failure(let error):
                
                //let message : String
                if let httpStatusCode = response.response?.statusCode {
                    if (httpStatusCode == 401) {
                        self.relogin()
                    }
                    //switch(httpStatusCode) {
                    //case 400:
                    //    message = "Username or password not provided."
                    //case 401:
                    //    message = "Incorrect password for user '."
                    //    self.relogin()
                    //
                    //default :
                    //    message = ""
                    //}
                } else {
                    failure(error)
                }
                // display alert with error message
                break
            
            }
        }
    }
    
    class func relogin() {
        
        let alert = UIAlertController(title: "Alert", message: "Password changed. Please login again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alert) in
           // let login = LoginViewController(nibName: "LoginViewController", bundle: nil)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navController = appDelegate.window?.rootViewController as? UINavigationController
            navController?.popToRootViewController(animated: true)
            
          
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    // GET

        
    class func requestGETURL1(api:String, para: [String : String] ,success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        
        print("RequestGETURL1 api = " + api)
        
        AF.request(api, method: .get, parameters: nil, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:AFDataResponse<Any>) in
            
            switch(response.result) {
            case .success(let result):
                success(result)
                break
                
            case .failure(let error):
                //let message : String
                if let httpStatusCode = response.response?.statusCode {
                    if (httpStatusCode == 401) {
                        self.relogin()
                    }
                    //switch(httpStatusCode) {
                    //case 400:
                    //    message = "Username or password not provided."
                    //case 401:
                    //    message = "Incorrect password for user '."
                    //    self.relogin()
                    //
                    //default :
                    //    message = ""
                    //}
                } else {
                    failure(error)
                }
                // display alert with error message
                break
                
            }
        }
    }
    
    //POST
    class func requestPOSTURL1(api:String, stringPost:String ,success:@escaping ([String: Any]) -> Void) {
        
        print("RequestPOSTURL1 api = " + api)
        let username = UserPreferences.LoginID
        let password = UserPreferences.Password
        
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let api1 = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let urlpost = URL(string: api1!)
        
        ActivityIndicator.show()
        let data = stringPost.data(using: String.Encoding.utf8)
        
        let request = NSMutableURLRequest(url: urlpost!)
        
        let jsonString = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
        request.httpBody = jsonString?.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error)->Void in
            ActivityIndicator.hide()
            if let response1 = response as? HTTPURLResponse {
                if response1.statusCode == 401 {
                    self.relogin()
                }
            }
            if response == nil {
                return
            }
            
            //let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            let result = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            print("RequestPostURL1: result: \(result!)")
            
            success(result!)
        })
        task.resume()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

