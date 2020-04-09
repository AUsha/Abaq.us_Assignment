//
//  ViewController.swift
//  Abaq.us Assignment
//
//  Created by Usha Annadanapu on 07/04/20.
//  Copyright © 2020 Usha Annadanapu. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import MBProgressHUD

class ViewController: UIViewController {
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var progressBar:MBProgressHUD?
    var pendingTasks = [String]()
    var doneTasks = [String]()
    var serviceLayer = ServiceLayer()
    
    var tabs = [ViewPagerTab(title: "PENDING", image: nil), ViewPagerTab(title: "Done", image: nil)]
    
    let pendingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingViewController") as! PendingViewController
    
    let doneViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoneViewController") as! DoneViewController
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.topItem?.title = "TASKS"
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.isTranslucent = false
        self.showProgressIndicator()
        self.serviceLayer.getTasksData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerViewModelListeners()
        self.createTabs()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideProgressIndicator()
    }
    
    func registerViewModelListeners() {
        self.serviceLayer.isTasksSucceeded.bind {
            (success) in
            if success {
                self.pendingTasks.append(contentsOf: self.serviceLayer.pendingTasks)
                self.doneTasks.append(contentsOf: self.serviceLayer.doneTasks)
            }
        }
        
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
    
    func showProgressIndicator(title:String = "") {
        guard let window = UIApplication.shared.windows.last else { return }
        progressBar = MBProgressHUD.showAdded(to: window, animated: true)
        progressBar?.mode = MBProgressHUDMode.indeterminate
        progressBar?.label.text = title
    }
    func hideProgressIndicator() {
        guard let window = UIApplication.shared.windows.last else { return }
        MBProgressHUD.hide(for: window, animated: true)
    }
}

extension ViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
    }
    
    func didMoveToControllerAtIndex(index: Int) {
    }
}
extension ViewController: ViewPagerControllerDataSource {
    func numberOfPages() -> Int {
        return 2
    }
    
    func viewControllerAtPosition(position: Int) -> UIViewController {
        
        if position == 0 {
            sleep(3)
            self.pendingViewController.pendingTasks = self.pendingTasks
            return pendingViewController
        }
        self.doneViewController.doneTasks = self.doneTasks
        return doneViewController
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
}
