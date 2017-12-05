//
//  ViewController.swift
//  ios-sample-drawer
//
//  Created by Owen on 2017/12/05.
//  Copyright © 2017年 owen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var drawerView: DrawerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawerView.open()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

