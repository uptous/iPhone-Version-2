//
//  APIs.swift
//  ibuzz
//


import Foundation
import Just

//MARK: API Status Type
enum StatusType {
    case Error, SUCCESS, Unknown, DUPLICATE
}

struct Status {
    var type: StatusType
    var message: String
}

//MARK: API Response Element

class APIResponse {
    
    private var rawType: String!
    private var rawStatusCode: String!
    private var rawData: AnyObject!
    private var rawMessage: String!
    private var rawDescription: String!
    
    required init() {
        
    }
    
    required init(response: AnyObject) {
        
        print(response)
        rawData = response
        
//        if response["data"]! != nil {
//            rawData = response["data"]!!
//        }
        
        /*if response["type"]! != nil {
            rawType = String(response["type"]!!)
        }
        
        if response["code"]! != nil {
            rawStatusCode = String(response["code"]!!)
        }
        
        if response["message"]! != nil {
            rawMessage = String(response["message"]!!)
        }
        
        if response["data"]! != nil {
            rawData = response["data"]!!
        }
        
        if response["description"]! != nil {
            rawDescription = String(response["description"]!!)
        }*/
    }
    
    var type: String {
        if let type = rawType {
            return type
        }
        
        return "Error"
    }
    
    var status: Status {
        
        var type = StatusType.Unknown
        var message = "Unknown Error"
        
        if let code = rawStatusCode {
            if code != "200" {
                type = StatusType.Error
            } else {
                type = StatusType.SUCCESS
                message = ""
            }
        }
        
        if let msg = rawMessage {
            message = msg
        }
        
        return Status(type: type, message: message)
    }
    
    var isSuccess: Bool {
        return status.type == .SUCCESS
    }
    
    var isError: Bool {
        return status.type == .Error
    }
    
    var isDuplicate: Bool {
        return status.type == .DUPLICATE
    }
    
    var data: AnyObject! {
        
        if let data = rawData {
            return data
        }
        
        return nil
    }
    
    func dataByKey(key: String) -> AnyObject! {
        if let data = self.data {
            if data[key] != nil && data[key]! != nil {
                return data[key]!!
            }
        }
        
        return nil
    }
}

//MARK: API Response
class LoginAPIResponse : APIResponse {
    
    var loginSuccessful: Bool {
        return isSuccess
    }
    
    var userId: UInt64! {
        
        if let data = dataByKey("user_id") {
            return UInt64(String(data))
        }
        
        return nil
    }
}

//MARK:All APIs
class APIs {
    
    enum APIError: ErrorType {
        
        case InvalidResponse(String, Status)
        case GeneralError(String)
    }
    
    //MARK: Sign In
    static func performLogin(email: String, password: String, callback: ((LoginAPIResponse) -> Void)? = nil) {
        
        let credentialData = "\(email):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        Just.get("\(APIs.baseUrl)/auth", headers: ["Authorization": "Basic \(base64Credentials)"]) { (r) in
            return getResponse(r, callback: callback)
        }
    }
    
    //MARK: Feed
    static func feed(email: String, password: String, callback: ((LoginAPIResponse) -> Void)? = nil) {
        
        let credentialData = "\(email):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        Just.get("\(APIs.baseUrl)/feed", headers: ["Authorization": "Basic \(base64Credentials)"]) { (r) in
            return getResponse(r, callback: callback)
        }
    }
    
    //MARK:- Comment Post
    static func postComment(email: String, password: String, api: String,packet:String, callback: ((LoginAPIResponse) -> Void)? = nil) {
        
        let credentialData = "\(email):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        Just.post("\(api)", headers: ["Authorization": "Basic \(base64Credentials)"],params:["contents": packet] ) { (r) in
            print("Raw Post Response:")
            print(r)
            return getResponse(r, callback: callback)
        }
    }
    
    //MARK:- Comment Fetch
    static func fetchComment(email: String, password: String, api: String, callback: ((LoginAPIResponse) -> Void)? = nil) {
        
        let credentialData = "\(email):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        Just.get("\(api)", headers: ["Authorization": "Basic \(base64Credentials)"]) { (r) in
            return getResponse(r, callback: callback)
        }
    }
    
    //MARK:- Fetch Old Reply Fetch
    static func fetchOldReply(email: String, password: String, api: String, callback: ((LoginAPIResponse) -> Void)? = nil) {
        
        let credentialData = "\(email):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        Just.get("\(api)", headers: ["Authorization": "Basic \(base64Credentials)"]) { (r) in
            return getResponse(r, callback: callback)
        }
    }

    
    
    /*//MARK:- Comment Post
    static func postComment(email: String, password: String, api: String,packet:AnyObject, callback: ((LoginAPIResponse) -> Void)? = nil) {
        
        var data = [String: AnyObject]()
        data["contents"] = "Roshan Mishra"
        
    
        print("Sending Packet: \(packet)")
        
//        let username = "contents"
//        let password = "pass"
//        let loginString = NSString(format: "%@ = %@", username, password)
//        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
//        let base64LoginString = loginData.base64EncodedStringWithOptions([])
        
        let credentialData = "\(email):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
             let packet = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            print(packet)
            
            //let data: NSData = str.dataUsingEncoding(NSUTF8StringEncoding)!
            
           
            Just.post("https://www.uptous.com/api/comments/feed/1556209", headers: ["Authorization": "Basic \(base64Credentials)"],params:["contents": "bar Roshan Vir"] ) { (r) in
                print("Raw Post Response:")
                print(r)
                return getResponse(r, callback: callback)
            }
            
        } catch let error as NSError {
            print(error)
            print("Error in JSON conversion: \(error.localizedDescription)")
        }

        

        
    }*/

    
    
   
    
       
    static func getResponse<R: APIResponse>(r: HTTPResult!, callback: ((R) -> Void)?) {
        var response = R()
        
        print("Response: \(r.json)")
        
        if r.json != nil {
            
            if let data = r.json {
                //if data["response"] != nil {
                    response = R(response: data)
                    if callback != nil {
                        callback!(response)
                    }
                //}
                
                /*if data["status"] == nil || String(data["status"]!!) != "200" {
                    if callback != nil {
                        callback!(response)
                    }
                } else {
                    if callback != nil {
                        callback!(response)
                    }
                }*/
            }
            
        } else {
            
            response.rawMessage = r.reason
            print(r.reason)
            if callback != nil {
                callback!(response)
            }
        }
    }
    
    //MARK: Convert Request into JSON
    static func toJSON(json: String) -> AnyObject? {
        let data: NSData = json.dataUsingEncoding(NSUTF8StringEncoding)!
        let anyObj: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        
        return anyObj
    }
    
    static var baseUrl: String {
        return "https://www.uptous.com/api"
        
    }
    
}
