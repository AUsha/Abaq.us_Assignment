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
    var pendingTasks = [TaskModel]()
    var doneTasks = [TaskModel]()
    var deletedDoneTasks = [TaskModel]()
    
    var taskViewModel = TasksViewModel()
    
    let colorString = "#0091D0"
    
    
    var tabs = [ViewPagerTab(title: "PENDING", image: nil), ViewPagerTab(title: "Done", image: nil)]
    
    let pendingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingViewController") as! PendingViewController
    
    let doneViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoneViewController") as! DoneViewController
    
    let addView = Bundle.main.loadNibNamed(AddTaskView.nibName(), owner: AddTaskView(), options: nil)?.first as! AddTaskView
    var transparentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.topItem?.title = "TASKS"
        navigationController?.navigationBar.barTintColor =  UIColor(hexString: "#F5B041")
        self.navigationController?.navigationBar.isTranslucent = false
        self.showProgressIndicator()
        self.taskViewModel.getTasksData()
        registerViewModelListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.doneViewController.deleteCell = {
            selectedJobIds in
            self.deletedDoneTasks.removeAll()
            if let deletedIds = selectedJobIds {
                self.deletedDoneTasks.append(contentsOf: deletedIds)
            }
            if self.deletedDoneTasks.count != 0 {
                self.deleteButtonNavItem()
            }
            else {
                self.hideNavItems()
            }
        }
        
        self.doneViewController.resumeCell = {
            unSelectedJobIds in
            if let deletedIds = unSelectedJobIds {
                self.deletedDoneTasks.removeAll(where: {deletedIds.contains($0)})
            }
            if self.deletedDoneTasks.count != 0 {
                self.deleteButtonNavItem()
            }
            else {
                self.hideNavItems()
            }
        }
        self.pendingViewController.tasksStateChange = {
            changeIds in
            if let deletedIds = changeIds {
                self.pendingTasks.removeAll(where: {deletedIds.contains($0)})
                self.doneTasks.append(contentsOf: deletedIds)
                self.updatePendingTasks()
            }
        }
        self.doneViewController.tasksStateChange = {
            changeIds in
            if let deletedIds = changeIds {
                self.doneTasks.removeAll(where: {deletedIds.contains($0)})
                self.pendingTasks.append(contentsOf: deletedIds)
                self.updatePendingTasks()
            }
        }
    }
    
    func updatePendingTasks() {
        self.pendingViewController.pendingTasks = self.pendingTasks
        self.pendingViewController.tableView.reloadData()
        if self.doneViewController.tableView != nil {
            self.doneViewController.doneTasks = self.doneTasks
            self.doneViewController.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideProgressIndicator()
    }
    
    func registerViewModelListeners() {
        self.taskViewModel.isTasksSucceeded.bind {
            (success) in
            if success {
                if let tasks = self.taskViewModel.taskModel{
                    for tasks in tasks {
                        if tasks.status == 1 {
                            self.doneTasks.append(tasks)
                        }
                        else {
                            self.pendingTasks.append(tasks)
                        }
                        
                    }
                    self.hideProgressIndicator()
                    
                }
            }
        }
        
    }
    func createTabs() {
        
        let tabs1 = [ViewPagerTab(title: "PENDING", image: nil),
                     ViewPagerTab(title: "DONE", image: nil)]
        tabs = tabs1
        addViewPager()
    }
    
    func addButtonNavItem() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskView))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    func deleteButtonNavItem() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteDoneItems))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func deleteDoneItems() {
        self.doneTasks.removeAll(where: { self.deletedDoneTasks.contains($0) })
        self.hideUnhideDoneTableView()
        self.doneViewController.doneTasks = self.doneTasks
        if self.deletedDoneTasks.count == 0 {
            self.deletedDoneTasks.removeAll()
            self.doneViewController.matchesSelectedJobs.removeAll()

            self.hideNavItems()
        }
        self.doneViewController.tableView.reloadData()
    }
    
    func hideNavItems() {
        navigationItem.rightBarButtonItems?.removeAll()
    }
    
    func hideUnhideDoneTableView() {
        if self.doneViewController.doneTasks.count == 0 {
            self.doneViewController.tableView.isHidden = true
            self.doneViewController.noTasksLabel.isHidden = false
        }
    }
    @objc func addTaskView() {
        guard let window = UIApplication.shared.windows.last else { return }
        transparentView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        addView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
        addView.delegate = self
        addView.titleTexTField.text = ""
        
        transparentView.addSubview(addView)
        window.addSubview(transparentView)
    }
    
    
    func addViewPager() {
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        options = ViewPagerOptions(viewPagerWithFrame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        options.tabType = ViewPagerTabType.basic
        options.isTabHighlightAvailable = true
        options.isEachTabEvenlyDistributed = true
        options.fitAllTabsInView = true
        options.tabViewTextHighlightColor = UIColor.white
        options.tabViewTextFont = UIFont.boldSystemFont(ofSize: 18)
        options.tabViewTextDefaultColor =  UIColor.white
        options.tabIndicatorViewBackgroundColor = UIColor.white
        options.tabViewBackgroundDefaultColor = UIColor(hexString: "#F39C12")
        options.tabViewBackgroundHighlightColor = UIColor(hexString: "#F39C12")
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
        DispatchQueue.main.async {
            self.progressBar?.hide(animated: true)
            self.createTabs()
            
        }
    }
}

extension ViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        if index == 0{
            addButtonNavItem()
        }
        else {
            if self.deletedDoneTasks.count == 0 {
                self.hideNavItems()
            }
            else {
                deleteButtonNavItem()
            }
        }
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
            addButtonNavItem()
            self.pendingViewController.pendingTasks = self.pendingTasks
            return pendingViewController
        }
        if self.deletedDoneTasks.count == 0 {
            self.hideNavItems()
        }
        else {
            deleteButtonNavItem()
        }
        self.doneViewController.doneTasks = self.doneTasks
        self.hideUnhideDoneTableView()
        return doneViewController
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
}
extension ViewController: AddTaskViewProtocol {
    func addTasks() {
        transparentView.removeFromSuperview()
        let post = TaskModel()
        post.title = self.addView.titleTexTField.text
        self.pendingViewController.pendingTasks.append(post)
        self.pendingViewController.tableView.reloadData()
    }
}

