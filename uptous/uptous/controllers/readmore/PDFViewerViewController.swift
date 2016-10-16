//
//  PDFViewerViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/25/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class PDFViewerViewController: GeneralViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var data: Feed!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: data.newsItemUrl!)
        
        //Create the document for the viewer when the segue is performed.
//        var viewer = segue.destinationViewController as PDFKBasicPDFViewer
//        
//        //Load the document (pdfUrl represents the path on the phone of the pdf document you wish to load)
//        var document = PDFKDocument(contentsOfFile: pdfUrl!, password: nil)
//        viewer.loadDocument(document)
        
        
        //let url : NSURL! = NSURL(string: "http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf")
        webView.loadRequest(NSURLRequest(URL: url!))
        
        
        
        let req = NSURLRequest(URL: url!)
        webView.delegate = self
        //here is the sole part
        webView.scalesPageToFit = true
        webView.contentMode = .ScaleToFill
        webView.loadRequest(req)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("Webview fail with error \(error)");
    }
    
    
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("Webview started Loading")
       // ActivityIndicator.show()

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("Webview did finish load")
        //ActivityIndicator.hide()

    }
    
    
    
    //MARK: - Button Action
    @IBAction func backBtnClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
