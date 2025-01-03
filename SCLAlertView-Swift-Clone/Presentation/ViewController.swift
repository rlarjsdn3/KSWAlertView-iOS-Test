//
//  ViewController.swift
//  SCLAlertView-Swift-Clone
//
//  Created by 김건우 on 1/1/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapButton(_ sender: Any) {
        _ = SCLAlertView().showInfo("Info", subTitle: "This is a simple info alert")
    }
    
}

