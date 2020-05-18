//
//  LoginNVG.swift
//  uptous
//
//  Created by Roshan Gita  on 1/26/17.
//  Copyright © 2017 UpToUs. All rights reserved.
//

import UIKit

class LoginNVG: UINavigationController {

    override func viewDidLoad() {
        print ("loginNVG: viewDidLoad - hiding navigation bar")
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
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
