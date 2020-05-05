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
            
            task.resume()
        }
    }
}
