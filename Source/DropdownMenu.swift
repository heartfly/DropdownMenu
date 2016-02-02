//
//  DropdownMenu.swift
//  DropdownMenu
//
//  Created by qxh on 16/1/22.
//  Copyright © 2016 qxh. All rights reserved.
//

import UIKit

// MARK: - DropdownMenu Mixin
@objc protocol DropdownMenuMixin {
    //navigationBar title menu
    optional var titleDropdownMenu: DropdownMenu { get set }
    optional func setupTitleDropdownMenu(items: [String])
    
    //navigationBar title multisection menu
    optional var multiSectionTitleDropdownMenu: DropdownMenu { get set }
    optional func setupMultiSectionTitleDropdownMenu(items: [String])
    
    //navigationBar right menu
    optional var rightDropdownMenu: DropdownMenu { get set }
    optional func setupRightDropdownMenu(items: [String])
}

// Providing Default Implementations of DropdownMenuMixin
extension DropdownMenuMixin where Self: UIViewController {
    var titleDropdownMenu: DropdownMenu {
        get {
            var bounds = self.view.bounds
            bounds.origin.y = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.sharedApplication().statusBarFrame.size.height
            let menu = DropdownMenu(frame: bounds, type: .Grid, position: .Middle, items: []) { (indexPath, item) -> Void in
                if let titleView = self.navigationItem.titleView as? TappableTitleView {
                    titleView.title = item
                }
            }
            self.navigationItem.titleView = TappableTitleView(title: self.title, tapHandler: { [unowned menu] () -> Void in
                menu.toggle()
                
                })
            self.view.addSubview(menu)
            return menu
        }
    }
    
    func setupTitleDropdownMenu(items: [String]) {
        self.titleDropdownMenu.items = items
    }
    
    var rightDropdownMenu: DropdownMenu {
        get {
            var bounds = self.view.bounds
            bounds.origin.y = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.sharedApplication().statusBarFrame.size.height
            let menu = DropdownMenu(frame: bounds, type: .Table, position: .Right, items: []) { (indexPath) -> Void in
                
            }
            self.navigationItem.titleView = TappableTitleView(title: self.title, tapHandler: { [unowned menu] () -> Void in
                menu.toggle()
                
                })
            self.view.addSubview(menu)
            return menu
        }
    }
    
    func setupRightDropdownMenu(items: [String]) {
        self.rightDropdownMenu.items = items
    }
    
    var multiSectionTitleDropdownMenu: DropdownMenu {
        get {
            var bounds = self.view.bounds
            bounds.origin.y = (self.navigationController?.navigationBar.bounds.height)! + UIApplication.sharedApplication().statusBarFrame.size.height
            let menu = DropdownMenu(frame: bounds, type: .Grid, position: .Middle, sections: []) { (indexPath) -> Void in
                
            }
            self.navigationItem.titleView = TappableTitleView(title: self.title, tapHandler: { [unowned menu] () -> Void in
                menu.toggle()
                
                })
            self.view.addSubview(menu)
            return menu
        }
    }
    
    func setupMultiSectionTitleDropdownMenu(sections: [(title: String, items: [String])]) {
        self.multiSectionTitleDropdownMenu.sections = sections
    }
}

// MARK: - Dropdownable protocol
protocol Dropdownable {
    var backgroundView: UIView { get set } //a mask background View
    var isShown: Bool { get set }
    
    func show()
    func hide()
    func toggle()
    
    func showMenu()
    func hideMenu()
}

// Providing Default Implementations of Dropdownable
extension Dropdownable where Self: UIView {
    func show() {
        if self.isShown == false {
            self.showMenu()
        }
    }
    
    func hide() {
        if self.isShown == true {
            self.hideMenu()
        }
    }
    
    func toggle() {
        if self.isShown == true {
            self.hideMenu()
        } else {
            self.showMenu()
        }
    }
}

// Drop down view type
enum DropdownMenuType {
    case Grid // show as Grid
    case Table // show as Table
}

// Drop down position
enum DropdownMenuPostion {
    case Middle // at middle
    case Right // at right
}

// MARK: - DropdownMenu Control
let DropdownCollectionViewCellIdentifier:String = "DropdownCollectionViewCell"

class DropdownMenu: UIView, Dropdownable, UICollectionViewDataSource, UICollectionViewDelegate {

    var type: DropdownMenuType = .Table
    var position: DropdownMenuPostion = .Middle
    var width: CGFloat = UIScreen.mainScreen().bounds.width // menu width
    var items: [String] = [] {
        didSet {
            self.reloadData()
        }
    }// menu item titles (for Table type)
    var sections: [(title: String, items: [String])] = [] // menu sections ( for CollectionType)
    var isShown: Bool = false
    var tableView: UITableView?
    let margin: CGFloat = 5.0
    let cellHeight: CGFloat = 40.0
    var didSelectItemHandler: (indexPath: NSIndexPath, item: String) -> Void = { _ in }
    
    lazy var backgroundView: UIView = {
        let _backgroundView = UIView(frame: self.bounds)
        _backgroundView.backgroundColor = UIColor.blackColor()
        _backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        let backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "hideMenu");
        _backgroundView.addGestureRecognizer(backgroundTapRecognizer)
        
        return _backgroundView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let _collectionView = UICollectionView(frame: CGRectMake(0, 0, CGFloat(self.width), CGFloat(320)), collectionViewLayout: layout)
        _collectionView.delegate = self
        _collectionView.dataSource = self
        // register CollectionViewCell
        _collectionView.registerClass(UICollectionViewCell.self,
            forCellWithReuseIdentifier: DropdownCollectionViewCellIdentifier)
        _collectionView.backgroundColor = UIColor(red:0.298, green:0.643, blue:0.984, alpha: 1)
        _collectionView.opaque = false
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.showsVerticalScrollIndicator = false
        _collectionView.clipsToBounds = false
        return _collectionView
    }()
    
    init(frame: CGRect, type: DropdownMenuType, position: DropdownMenuPostion, items: [String], sections: [(title: String, items: [String])], didSelectItemHandler: (indexPath: NSIndexPath, item: String) -> Void) {
        
        // Set frame
        super.init(frame: frame)

        self.type = type
        self.position = position
        self.items = items
        self.sections = sections
        self.didSelectItemHandler = didSelectItemHandler
        
        self.clipsToBounds = true
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        self.addSubview(backgroundView)
        self.addSubview(collectionView)
        
        self.hidden = true
    }
    
    convenience init(frame: CGRect, type: DropdownMenuType, position: DropdownMenuPostion, items: [String], didSelectItemHandler: (indexPath: NSIndexPath, item: String) -> Void) {

        self.init(frame: frame, type: type, position: position, items: items, sections: [], didSelectItemHandler: didSelectItemHandler)
    }
    
    convenience init(frame: CGRect, type: DropdownMenuType, position: DropdownMenuPostion, sections: [(title: String, items: [String])], didSelectItemHandler: (indexPath: NSIndexPath, item: String) -> Void) {
        
        self.init(frame: frame, type: type, position: position, items: [], sections: sections, didSelectItemHandler: didSelectItemHandler)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        let layout = UICollectionViewFlowLayout()
        let totalWidth = self.width - self.margin*2
        var cellWidth: CGFloat = 0.0
        var collectionHeight: CGFloat = 0.0
        switch self.type {
        case .Grid:
            if self.items.count > 0 {
                if self.items.count >= 3 {
                    cellWidth = totalWidth/3 - self.margin*2
                    collectionHeight = CGFloat(self.items.count/3+1) * self.cellHeight
                } else  {
                    cellWidth = totalWidth/2 - self.margin*2
                    collectionHeight = self.cellHeight
                }
            } else if self.sections.count > 0 {
                if self.sections[0].1.count >= 3 {
                    cellWidth = totalWidth/3 - self.margin*2
                } else  {
                    cellWidth = totalWidth/2 - self.margin*2
                }
                
                for (_, items) in self.sections {
                    if items.count >= 3 {
                        collectionHeight += CGFloat(self.items.count/3+1) * self.cellHeight
                    } else  {
                        collectionHeight += self.cellHeight
                    }
                    collectionHeight += 30
                }
            }
        case .Table:
            cellWidth = self.width
            collectionHeight = CGFloat(self.items.count) * self.cellHeight
        }
        layout.itemSize = CGSizeMake(CGFloat(cellWidth), self.cellHeight - 10)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical  //scroll direction
        layout.minimumLineSpacing = 5.0  // line spacing
        layout.minimumInteritemSpacing = 5.0 // item spacing
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) // section spacing
        layout.headerReferenceSize = CGSize(width: CGFloat(self.width), height: CGFloat(320))
        self.collectionView.frame = CGRectMake(0, 0, CGFloat(self.width),  CGFloat(320) + collectionHeight)
        self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Dropdownable
    
    func showMenu() {
        self.isShown = true
        
        // Visible menu view
        self.hidden = false
        
        // Change background alpha
        self.backgroundView.alpha = 0
        
        // Animation
        self.collectionView.frame.origin.y = -self.collectionView.frame.size.height
        
        self.superview?.bringSubviewToFront(self)
        
        UIView.animateWithDuration(
            0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.collectionView.frame.origin.y = CGFloat(-320)
                self.backgroundView.alpha = 0.3
            }, completion: nil
        )
    }
    
    func hideMenu() {
        self.isShown = false
        
        // Change background alpha
        self.backgroundView.alpha = 0.3
        
        UIView.animateWithDuration(
            0.2,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                [unowned self] _ in
                self.collectionView.frame.origin.y = CGFloat(-280)
            }, completion: nil
        )
        
        // Animation
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { [unowned self] _ in
            self.collectionView.frame.origin.y = -self.collectionView.frame.size.height
            self.backgroundView.alpha = 0
            }, completion: { [unowned self] _ in
                self.hidden = true
            })
    }
    
    // MARK: - UICollectionViewDataSource
    // CollectionView sections number
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if self.sections.count > 0 {
            return self.sections.count
        }
        return 1
    }
    
    // CollectionView items number
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        if self.sections.count > 0 {
            let (_, items) = self.sections[section]
            return items.count
        }
        return self.items.count
    }
    
    // setup cell
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            DropdownCollectionViewCellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        // show menu title
        var item: String
        if self.sections.count > 0 {
            let (_, items) = self.sections[indexPath.section]
            item = items[indexPath.row]
        } else {
            item = self.items[indexPath.row]
        }
        if let textLabel: UILabel = cell.viewWithTag(10086) as? UILabel {
            textLabel.text = item
        } else {
            let lbl = UILabel(frame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height))
            lbl.backgroundColor = UIColor.whiteColor()
            lbl.layer.borderWidth = 1
            lbl.layer.borderColor = UIColor.grayColor().CGColor
            lbl.textAlignment = NSTextAlignment.Center
            cell.addSubview(lbl)
            lbl.tag = 10086
            lbl.text = item
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var item: String = ""
        if self.sections.count > 0 {
            item = self.sections[indexPath.section].items[indexPath.row]
        } else {
            item = self.items[indexPath.row]
        }
        self.hide()
        self.didSelectItemHandler(indexPath: indexPath, item: item)
    }
}
