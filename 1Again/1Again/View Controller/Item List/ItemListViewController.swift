//
//  ItemListViewController.swift
//  1Again
//
//  Created by Nam Phong on 6/30/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ItemListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    
    
    private let cellIdentifier = "ItemListCell"
    var resultSearchController = UISearchController()
    var items: [Item]!
    var tmpItems: [Item]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = [Item]()
        tmpItems = [Item]()
        setMenuButtonAction(menuBtn)
        self.edgesForExtendedLayout = UIRectEdge.None;
        tableview.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resultSearchController.searchBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if items.count <= 0 {
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            ItemAPI.getItemList({ (items) -> Void in
                self.items = items
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                self.tableview.reloadData()
                self.createSearchBar()
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active {
            return tmpItems.count
        }
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ItemListCell
        
        var item: Item!
        
        if resultSearchController.active {
            item = tmpItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        cell.configCellByItem(item)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "More", handler:{action, indexpath in
            
            self.moveToItemDetailFromIndexPath(indexPath)
            
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Archive", handler:{action, indexpath in
            var item: Item = Item()
            if self.resultSearchController.active {
                item = self.tmpItems[indexPath.row]
                self.tmpItems.removeAtIndex(indexPath.row)
            } else {
                item = self.items[indexPath.row]
                self.items.removeAtIndex(indexPath.row)
            }
            self.tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            ItemAPI.archiveItem(item.itemID!, completion: { () -> Void in
                
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
            })
            
        });
        
        return [deleteRowAction, moreRowAction];
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        moveToItemDetailFromIndexPath(indexPath)
    }
    
    func moveToItemDetailFromIndexPath(indexpath: NSIndexPath) {
        resultSearchController.resignFirstResponder()
        resultSearchController.searchBar.resignFirstResponder()
        resultSearchController.searchBar.hidden = true
        var item: Item!
        if self.resultSearchController.active {
            item = self.tmpItems[indexpath.row]
        } else {
            item = self.items[indexpath.row]
        }
        
        let itemDetailController = ItemDetailController()
        itemDetailController.item = item
        self.navigationController?.pushViewController(itemDetailController, animated: true)
    }
    
    //Mark: SEARCH METHODS
    func createSearchBar() {
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search..."
            
            self.tableview.tableHeaderView = controller.searchBar
            return controller
        })()
        
        
        if items.count > 0 {
            tableview.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
        self.tableview.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        tmpItems.removeAll(keepCapacity: false)
        
        let searchText = searchController.searchBar.text
        
        if searchText != nil && searchText != "" {
            for item in items {
                if item.category!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil || item.description!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil || item.title!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil{
                    tmpItems.append(item)
                }
            }
        } else  {tmpItems = items}
        self.tableview.reloadData()
    }
}
