//
//  SlideDelegateViewController.swift
//  Pappaya
//
//  Created by Thirumal on 02/12/16.
//  Copyright © 2016 Think42labs. All rights reserved.
//

import UIKit

class SlideDelegateViewController: UIViewController, SlideMenuControllerDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addLeftBarButtonWithImage(UIImage(named : "icon-menu")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
