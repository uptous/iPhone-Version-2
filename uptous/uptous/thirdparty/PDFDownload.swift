//
//  PDFDownload.swift
//  NGSwiftPdfReader
//
//  Created by Roshan Mishra on 12/6/16.
//  Copyright © 2016 Nitin Gohel. All rights reserved.
//

import UIKit

class PDFDownload: NSObject {
    
    class func loadFileAsync(url: NSURL, completion:@escaping (_ path:String?, _ error:Error?) -> Void) {
        
        print(url.lastPathComponent ?? "")
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        var destinationUrl: URL
        if let fileName = url.lastPathComponent {
            destinationUrl = documentsUrl.appendingPathComponent(fileName)
        } else {
            destinationUrl = documentsUrl.appendingPathComponent(("Demo.pdf"))
        }
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("file already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if (error == nil) {
                    if let response = response as? HTTPURLResponse {
                        //print("response=\(response)")
                        if response.statusCode == 200 {
                            do {
                                try data?.write(to: destinationUrl, options: .atomic)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    completion((destinationUrl.path), error)
                                }
                            } catch {
                                print("\(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                            }
                        }
                    }
                }else {
                    print("Failure: \(error?.localizedDescription ?? "Failed to Download PDF")");
                    completion(nil, error)
                }
            })
            
            /*let task = session.dataTaskWithRequest(request as URLRequest, completionHandler: { (data: NSData!, response: URLResponse!, error: Error!) -> Void in
             if (error == nil) {
             if let response = response as? NSHTTPURLResponse {
             print("response=\(response)")
             if response.statusCode == 200 {
             if data.writeToURL(destinationUrl, atomically: true) {
             println("file saved [\(destinationUrl.path!)]")
             completion(path: destinationUrl.path!, error:error)
             } else {
             print("error saving file")
             let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
             completion(path: destinationUrl.path!, error:error)
             }
             }
             }
             }
             else {
             print("Failure: \(error.localizedDescription)");
             completion(path: destinationUrl.path!, error:error)
             }
             })*/
            task.resume()
        }
    }
}
