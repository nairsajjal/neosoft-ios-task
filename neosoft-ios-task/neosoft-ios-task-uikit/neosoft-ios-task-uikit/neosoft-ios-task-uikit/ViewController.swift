//
//  ViewController.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 26/07/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mainVc = MainViewController()
        addChild(mainVc)
        view.addSubview(mainVc.view)
        mainVc.didMove(toParent: self)
    }


}

