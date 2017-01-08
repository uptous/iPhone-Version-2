//
//  PDFViewerViewController.swift
//  uptous
//
//  Created by Roshan Gita  on 9/25/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class PDFViewerViewController: GeneralViewController,ReaderViewControllerDelegate {

    @IBOutlet weak var webView: UIWebView!
    var data: Feed!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: data.newsItemUrl!)
        
        PDFDownload.loadFileAsync(url: url! as NSURL, completion:{(path) in
            print("pdf downloaded to: \(path)")
            if path.1 == nil {
                // Get the directory contents urls (including subfolders urls)
                if let document = ReaderDocument.withDocumentFilePath(path.0, password: "") {
                    let readerViewController: ReaderViewController = ReaderViewController(readerDocument: document)
                    readerViewController.delegate = self
                    // Set the ReaderViewController delegate to self
                    self.navigationController!.pushViewController(readerViewController, animated: true)
                }
            } else {
                print(path.1?.localizedDescription ?? "Error Occured")
            }
        })
    }
    
    func dismiss(_ viewController: ReaderViewController!) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Button Action
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
