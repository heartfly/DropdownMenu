//
//  ViewController.swift
//  DropdownMenu
//
//  Created by 邱星豪 on 02/02/2016.
//  Copyright (c) 2016 邱星豪. All rights reserved.
//

import UIKit
import DropdownMenu

class ViewController: UIViewController, DropdownMenuMixin { // Adding DropdownMenuMixin conformance 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Smart"
        self.setupTitleDropdownMenu(["Smart", "Latest", "Neareast", "Most Popular"])//call setupTitleDropdownMenu to create a dropdown menu, the first parameter is the menu items list
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

