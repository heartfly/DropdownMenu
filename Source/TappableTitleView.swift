//
//  TappableTitleView.swift
//  DropdownMenu
//
//  Created by qxh on 16/1/14.
//  Copyright © 2016 qxh. All rights reserved.
//

import UIKit

protocol Tappable {
    var button: UIButton { get set }
    var tapHandler: () -> Void { get set }
    
    func buttonTapped()
}

extension Tappable where Self: UIView {
    func setupButton() {
        self.addSubview(self.button)
        self.button.addTarget(self, action: "buttonTapped", forControlEvents: .TouchUpInside)
    }
    
    func buttonTapped() {
        tapHandler()
    }
}

class TappableTitleView: UIView, Tappable {

    var title: String? = "" {
        willSet {
            if let newValue = newValue {
                self.button.setTitle(newValue + "▽", forState: .Normal)
                self.button.setTitle(newValue + "△", forState: .Selected)
                self.button.selected = false
            }
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton(type: .Custom)
        button.frame = self.bounds
        if let title = self.title {
            button.setTitle(title + "▽", forState: .Normal)
            button.setTitle(title + "△", forState: .Selected)
        }
        
        return button
    }()
    
    var tapHandler: () -> Void = {}
    
    init(title: String?, tapHandler: () -> Void) {
        super.init(frame: CGRectMake(0, 0, 120, 40))
        
        self.title = title
        
        self.setupButton()
        
        self.tapHandler = tapHandler
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func buttonTapped() {
        tapHandler()
        self.button.selected = !self.button.selected
    }
}
