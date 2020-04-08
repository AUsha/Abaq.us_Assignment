//
//  ViewController.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 07/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ViewController: UIViewController {

    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var currentPageIndex: Int = 0
    
     var tabs = [ViewPagerTab(title: "PENDING", image: nil), ViewPagerTab(title: "Done", image: nil)]
    
    let pendingTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingTableViewController") as! PendingTableViewController
    
       var doneTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoneTableViewController") as! DoneTableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.topItem?.title = "TASKS"
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.isTranslucent = false


        createTabs()
    }

    func createTabs() {
        
        let tabs1 = [ViewPagerTab(title: "PENDING", image: nil),
                     ViewPagerTab(title: "DONE", image: nil)]
        tabs = tabs1
        addViewPager()

    }
    func addViewPager() {
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        options = ViewPagerOptions(viewPagerWithFrame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        options.tabType = ViewPagerTabType.basic
//        options.tabViewTextFont = Theme.font(.buttonBold)
        options.isTabHighlightAvailable = true
        options.isEachTabEvenlyDistributed = true
        options.fitAllTabsInView = true
        options.tabViewTextHighlightColor = UIColor.white
        options.tabViewTextDefaultColor =  UIColor.white
        options.tabIndicatorViewBackgroundColor = UIColor.white
        options.tabViewBackgroundDefaultColor = UIColor.red
        options.tabViewBackgroundHighlightColor = UIColor.red
        options.tabIndicatorViewHeight = 4
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChild(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParent: self)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}

extension ViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("willMoveToControllerAtIndex to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        currentPageIndex = index
        print("didMoveToControllerAtIndex to page \(index)")
    }
}
extension ViewController: ViewPagerControllerDataSource {
    func numberOfPages() -> Int {
        return 2
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        return pendingTableViewController
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    
//    func numberOfPages() -> Int {
//        return tabs.count
//    }
//
//    func viewControllerAtPosition(position:Int) -> UIViewController {
//        return favouritesController
//
//    }
//
//    func tabsForPages() -> [ViewPagerTab] {
//        return tabs
//    }
//
//    func startViewPagerAtIndex() -> Int {
//        return currentPageIndex
//    }
}
