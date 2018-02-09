//
//  WebViewViewController.swift
//  uptous
//
//  Created by RoshanMishra on 09/02/18.
//  Copyright © 2018 SPA. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

     @IBOutlet weak var webView: UIWebView!
     var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ActivityIndicator.show()
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    //MARK:- UIWebView Delegate
    func webViewDidStartLoad(webView: UIWebView)
    {
        ActivityIndicator.show()
        
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
        ActivityIndicator.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        ActivityIndicator.hide()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
