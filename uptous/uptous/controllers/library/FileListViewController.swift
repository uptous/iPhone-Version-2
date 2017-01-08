//
//  FileListViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 12/4/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class FileListViewController: GeneralViewController,ReaderViewControllerDelegate,UIWebViewDelegate {

    var filePath: String!
    @IBOutlet weak var webView: UIWebView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let docUrl = NSURL(string: filePath)
        
        let req = NSURLRequest(url: docUrl! as URL)
        webView.delegate = self
        //here is the sole part
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        webView.loadRequest(req as URLRequest)
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(_ :UIWebView){
        ActivityIndicator.show()
        NSLog("Webview load has started")
    
    }
    func webViewDidFinishLoad(_ :UIWebView){
    
        ActivityIndicator.hide()
        NSLog("Webview load had finished")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

}
