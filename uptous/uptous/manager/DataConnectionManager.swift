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
        
        Alamofire.request(api, method: .post,parameters: para, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result)
            print(response)
            switch(response.result) {
                
            case .success(_):
                if response.result.isSuccess {
                    let result = response.result.value
                    success(result as AnyObject)
                }
                break
                
            case .failure(_):
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }
                break
            }
        }
    }
    
    // GET
    class func requestGETURL(api:String, para: [String : String] ,success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(api, method: .get, parameters: para, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:DataResponse<Any>) in
            
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
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }
                break
                
            }
        }
    }
    
    class func requestGETURL1(api:String, para: Parameters ,success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(api, method: .post, parameters: para, encoding: URLEncoding.default, headers: appDelegate.loginHeaderCredentials).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result)
            print(response)
            switch(response.result) {
                
            case .success(_):
                if response.result.isSuccess {
                    let result = response.result.value
                    success(result as AnyObject)
                }
                break
                
            case .failure(_):
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }
                break
            }
        }
    }

    
    
}
