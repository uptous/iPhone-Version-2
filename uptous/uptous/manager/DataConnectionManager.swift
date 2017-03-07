//
//  DataConnectionManager.swift
//  uptous
//
//  Created by Roshan Gita  on 10/20/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class DataConnectionManager: NSObject {
    
    // POST
    class func requestPOSTURL(api:String, para:Parameters ,success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void) {
        
        ActivityIndicator.show()
        Alamofire.request(api, method: .post,parameters: para, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result)
            print(response)
            ActivityIndicator.hide()
            switch(response.result) {
                
            case .success(_):
                if response.result.isSuccess {
                    let result = response.result.value
                    success(result as AnyObject)
                }
                break
                
            case .failure(_):
                /*if response.result.isFailure {
                 let error : Error = response.result.error!
                 failure(error)
                 }*/
                
                let message : String
                print(response.response?.statusCode)
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        message = "Username or password not provided."
                    case 401:
                        message = "Incorrect password for user '."
                        self.relogin()
                        
                    default :
                        message = ""
                    }
                } else {
                    if response.result.isFailure {
                        let error : Error = response.result.error!
                        failure(error)
                    }
                }
                // display alert with error message
                break
                
            }

        }
    }
    
    // GET
    class func requestGETURL(api:String, para: [String : String] ,success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        print(appDelegate.loginHeaderCredentials)
         ActivityIndicator.show()
        Alamofire.request(api, method: .get, parameters: nil, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result)
            print(response)
            
            ActivityIndicator.hide()
            switch(response.result) {
            case .success(_):
                if response.result.isSuccess {
                    let result = response.result.value 
                    success(result)
                }
                break
                
            case .failure(_):
                /*if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }*/
                
                let message : String
                print(response.response?.statusCode)
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        message = "Username or password not provided."
                    case 401:
                        message = "Incorrect password for user '."
                        self.relogin()
                        
                    default :
                        message = ""
                    }
                } else {
                    if response.result.isFailure {
                        let error : Error = response.result.error!
                        failure(error)
                    }
                }
                // display alert with error message
                break
            
            }
        }
    }
    
    class func relogin() {
        
        let alert = UIAlertController(title: "Alert", message: "Password changed. Please login again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
           // let login = LoginViewController(nibName: "LoginViewController", bundle: nil)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navController = appDelegate.window?.rootViewController as? UINavigationController
            navController?.popToRootViewController(animated: true)
            
          
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    // GET
    class func requestGETURL1(api:String, para: [String : String] ,success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(api, method: .get, parameters: nil, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result)
            print(response)
            
            switch(response.result) {
            case .success(_):
                if response.result.isSuccess {
                    let result = response.result.value
                    success(result)
                }
                break
                
            case .failure(_):
                let message : String
                print(response.response?.statusCode)
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        message = "Username or password not provided."
                    case 401:
                        message = "Incorrect password for user '."
                        self.relogin()
                        
                    default :
                        message = ""
                    }
                } else {
                    if response.result.isFailure {
                        let error : Error = response.result.error!
                        failure(error)
                    }
                }
                // display alert with error message
                break
                
            }
        }
    }
    
    
    //MARK:-Upload Profile Image
    class func uploadImageOne(api:String,img: UIImage){
        let username = "asmithutu@gmail.com"
        let password = "alpha123"
        
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])

        
       // let imageData = UIImageJPEGRepresentation(Utility.scaleUIImageToSize(img, size: CGSize(width: 120, height: 120)), 0.6)?.base64EncodedString()
        
        let imageData = UIImageJPEGRepresentation(img, 0.9)?.base64EncodedString()//UIImageJPEGRepresentation(0.9, img)?.base64EncodedString()
        
        print(imageData?.description)
        let stringPost = "photo=" + ("\(imageData!)")
        
        
        
        
        if imageData != nil{
            let api1 = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlpost = NSURL(string: api1!)
            let request = NSMutableURLRequest(url: urlpost as! URL)
            
            
            
            request.httpMethod = "POST"
            
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
              print("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
            
            let body = NSMutableData()
            
            // Title
            /*body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append("Hello World".data(using: String.Encoding.utf8, allowLossyConversion: true)!)*/
            let data = stringPost.data(using: String.Encoding.utf8)
            // Image
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(data!)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            
            request.httpBody = body as Data
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error)->Void in
                //using breaking point to show data
                print(response)
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
                
                //let data1 = text.data(using: .utf8)
                let t1 = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                //success(t1!)
            })
            task.resume()
        }
        
        
    }
    //POST
    class func requestPOSTURL1(api:String, stringPost:String ,success:@escaping ([String: Any]) -> Void) {
        
        //UserPreferences.LoginID = username
        //UserPreferences.Password = password
        let username = UserPreferences.LoginID //UserDefaults.standard.value(forKey: "email") as? String//"asmithutu@gmail.com"
        let password = UserPreferences.Password //UserDefaults.standard.value(forKey: "password") as? String
        print(username)
        
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let api1 = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let urlpost = NSURL(string: api1!)
        
        ActivityIndicator.show()
        let data = stringPost.data(using: String.Encoding.utf8)
        
        let request = NSMutableURLRequest(url: urlpost as! URL)
        
        let jsonString = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
        request.httpBody = jsonString?.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error)->Void in
            ActivityIndicator.hide()
            //using breaking point to show data
            if let response1 = response as? HTTPURLResponse {
                if response1.statusCode == 401 {
                    self.relogin()
                }
            }
            if response == nil {
                return
            }
            
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            
            let result = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
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

