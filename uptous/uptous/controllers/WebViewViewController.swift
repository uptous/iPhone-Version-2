//
//  WebViewViewController.swift
//  uptous
//
//  Created by RoshanMishra on 09/02/18.
//  Copyright © 2018 UpToUs. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class WebViewViewController: UIViewController,WKNavigationDelegate {

     var urlString = ""
     var webView : WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loading URL :
        let url = URL(string: urlString)
        /*let request = URLRequest(url: url!)
        ActivityIndicator.show()
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)*/
        
        let svc = SFSafariViewController(url: url!, entersReaderIfAvailable: true)
        //svc.delegate = self as? SFSafariViewControllerDelegate
        self.present(svc, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        ActivityIndicator.hide()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ActivityIndicator.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
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
