//
//  ShopLocalViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, FilterViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var menuView: FilterView!
    @IBOutlet weak var applyFilterView: ApplyFilterView!
    
    var firstLoad: Bool = true
    var searchBar: UISearchBar!
    var tableview: UITableView!
    private let cellIdentifier = "ShopLocalCollectionCell"
    var items: [Item]!
    var nextLink: String!
    var totalRecord: Int = 0
    var counter: String!
    var page: String!
    var filterStr: String!
    var loadMore: Bool = true
    
    //data
    var categories:[CategoryObject]! = [CategoryObject]()
    var distances:[DistanceObject]! = [DistanceObject]()
    var conditions:[Seller]! = [Seller]()
    var tableData: [AnyObject]! = [AnyObject]()
    
    var tableHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.menuView.delegate = self
        self.createSearchBar()
        self.configTableview()
        setMenuButtonAction(menuBtn)
        configCollectionView()
        items = [Item]()
        nextLink = String()
        filterStr = String()
        self.counter = String()
        self.page = String()
        
        self.navigationController?.navigationBar.translucent = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstLoad {
            self.firstLoad = !self.firstLoad
            self.loadData()
        }
    }
    
    func loadData() {
        self.collectionview.alpha = 0
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        
        ItemAPI.getShopLocal("0", counter: "0", category: nil, search: nil, miles: nil, condition: nil, completion: { (items, nextLink, counter, page, totalRecord, loadMore) -> Void in
            self.items = items
            self.totalRecord = totalRecord
            self.nextLink = nextLink
            self.counter = counter
            self.page = page
            self.collectionview.alpha = 1
            self.collectionview.reloadData()
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }) { (error) -> Void in
            self.view.makeToast(error)
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }

    }
    
    func initData() {
        let distanceList = [["< 10 Miles", "10"], ["< 20 Miles", "20"], ["> 50 Miles", "50"], ["< 100 Miles", "100"], ["< 150 Miles", "150"]]

        for str in distanceList {
            let distanceObj = DistanceObject(sTitle: str[0], sId: str[1])
            self.distances.append(distanceObj)
        }

        self.conditions = SellerManager.sharedInstance.sellers
        var allSeller = Seller()
        allSeller.id = "-1"
        allSeller.displayName = "All Seller"
        self.conditions.insert(allSeller, atIndex: 0)
        
        self.categories = CategoryManager.sharedInstance.categories
        let category = CategoryObject(sCatId: -1, sCatDescription: "All Category")
        self.categories.insert(category, atIndex: 0)
    }
    
    func configTableview() {
        self.tableview = UITableView(frame: CGRectMake(0, -1000, UIScreen.mainScreen().bounds.size.width, 400))
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.view.addSubview(self.tableview)
        self.tableview.hidden = true
    }

    func hideAllFilter() {
        self.collectionview.alpha = 1
        self.collectionview.userInteractionEnabled = true
        if !self.tableview.hidden {
            self.hideTableView()
        }
        self.menuView.hideViewFromSuperView()
        self.applyFilterView.hideViewFromSuperView()
    }
    
    func showAllFilter() {
//        self.collectionview.userInteractionEnabled = false
//        self.collectionview.alpha = 0.5
        self.menuView.showViewFromSuperView(self.collectionview.frame.origin.y)
        self.applyFilterView.showViewFromSuperView(self.collectionview.frame.height - 30)
    }
    
    @IBAction func doFilterAction(sender: AnyObject) {
        if self.menuView.hidden == true {
            self.showAllFilter()
        } else {
            self.hideAllFilter()
        }
    }
    
    func getCategory() -> String{
        var returnStr = ""
        for category in self.categories {
            if category.catId >= 0 && category.selected == true {
                returnStr = returnStr.stringByAppendingString("\(category.catId)")
                break
            }
        }
        print("category: \(returnStr)")
        return returnStr
    }
    
    func getCondition() -> [String]! {
        if self.conditions[0].selected {
            return []
        } else {
            var returnStr: [String] = []
            for condition in self.conditions {
                if condition.selected {
                    returnStr.append(condition.id!)
                }
            }
            return returnStr
        }
    }
    
    func getDistance() -> String {
        var returnStr = ""
        for  distance in self.distances {
            if distance.selected {
                returnStr = distance.id
            }
        }
        print("distance: \(returnStr)")
        return returnStr
    }

    @IBAction func applyFilterAction(sender: AnyObject) {
        if self.menuView.hidden == false {self.hideAllFilter()}
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Loading...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        
        
        ItemAPI.getShopLocal("0", counter: "0", category: self.getCategory(), search: self.searchBar.text, miles: self.getDistance(), condition: self.getCondition(), completion: { (items, nextLink, counter, page, totalRecord, loadMore) -> Void in
            self.page = page
            self.counter = counter
            self.nextLink = nextLink
            self.totalRecord = totalRecord
            self.items = items
            self.collectionview.reloadData()
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }) { (error) -> Void in
            self.view.makeToast(error)
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchBar.resignFirstResponder()
            self.applyFilterAction("")
            return false
        }
        return true
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.loadData()
    }
    
    func hideTableView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.tableview.hidden = true
            self.tableview.center.y = -1000
        })
    }
    
    func didSelectButtonAtIndex(index: Int) {
        self.menuView.userInteractionEnabled = false
        if index != -1 {
            var maxHeight = self.applyFilterView.frame.origin.y - self.menuView.frame.origin.y - 45
//            if maxHeight > self.tableHeight {
//                maxHeight = self.tableHeight
//            }
            var tblHeight = maxHeight
            if index == 1 {
               tblHeight = CGFloat(self.distances.count * 44)
                self.tableData = self.distances
            } else if index == 2 {
                tblHeight = CGFloat(self.conditions.count * 44)
                self.tableData = self.conditions
            } else if index == 0 {
                tblHeight = CGFloat(self.categories.count * 44)
                self.tableData = self.categories
            }
            
            if tblHeight > maxHeight {tblHeight = maxHeight}

            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.menuView.hidden = false
                self.tableview.hidden = false
                self.tableview.frame = CGRectMake(0, self.menuView.frame.origin.y + 45, self.view.frame.width, tblHeight)
                self.tableview.reloadData()
                }, completion: { (finished: Bool) -> Void in
                
            })
            
            print(self.menuView.frame)
        } else {
            self.hideTableView()
        }
        self.menuView.userInteractionEnabled = true
    }
    
    func createSearchBar() {
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, 320, 44))
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.searchBar.sizeToFit()
        self.navigationItem.titleView = self.searchBar
    }
    
    func loadMoreData() {
        if self.totalRecord > self.items.count && self.loadMore{
            var additionData: [Item] = []
            
            MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Load more", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
            
            ItemAPI.getShopLocal(self.page, counter: self.counter, category: nil, search: nil, miles: nil, condition: nil, completion: { (items, nextLink, counter, page, totalRecord, loadMore) -> Void in
                additionData = items
                for item in additionData {
                    self.items.append(item)
                }
                self.counter = counter
                self.page = page
                self.collectionview.reloadData()
                self.loadMore = loadMore
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                }) { (error) -> Void in
                    self.view.makeToast(error)
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            }
        }
    }
    
    //Mark: COLLECTION VIEW METHODS
    
    func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:10,left:10,bottom:10,right:10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        collectionview.setCollectionViewLayout(layout, animated: true)
        collectionview.backgroundColor = UIColor(rgba:"#F0F0F0")
        collectionview.userInteractionEnabled = true
        collectionview.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopLocalCollectionCell
        
        let item = items[indexPath.row]
        cell.setupCellBasedOnItem(item)
        if indexPath.row == items.count - 2 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadMoreData()
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = UIScreen.mainScreen().bounds.size.width/2 - 15.0
        return CGSize(width: width, height: width*4/3 + 65)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.searchBar.endEditing(true)
        self.hideTableView()
        self.hideAllFilter()
        let item = items[indexPath.row]
        if item.category != "15" {
            let shopLocalDetailController = ShopLocalDetailViewController()
            shopLocalDetailController.tmpItemID = item.itemID
            self.navigationController?.pushViewController(shopLocalDetailController, animated: true)
        } else {
            
            ItemAPI.updateAdsClickingCount(item.itemID!, completion: { () -> Void in
                let adsViewController = AdsViewViewController()
                adsViewController.urlStr = item.description
                self.navigationController?.pushViewController(adsViewController, animated: true)
            }, failure: { (error) -> Void in
                self.view.makeToast(error)
            })
        }
    }

    //MARK: TABLEVIEW METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CellMenu"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell!
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        cell.selectionStyle = .None
        if self.menuView.selectedIndex == 0 {
            cell.textLabel?.text = self.categories[indexPath.row].catDescription
            if self.categories[indexPath.row].selected == true {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else if self.menuView.selectedIndex == 1 {
            cell.textLabel?.text = self.distances[indexPath.row].title
            if self.distances[indexPath.row].selected == true {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = self.conditions[indexPath.row].displayName!
            } else {
                cell.textLabel?.text = self.conditions[indexPath.row].displayName! + "(" + self.conditions[indexPath.row].distance! + " miles )"
            }
            
            if self.conditions[indexPath.row].selected == true {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchBar.endEditing(true)
//        self.view.endEditing(true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        
        if self.menuView.selectedIndex == 0 {
            if indexPath.row == 0 {
                if self.categories[0].selected {
                    for var i = 0; i < self.categories.count; i++ {
                        self.categories[i].selected = false
                    }
                } else {
                    for var i = 0; i < self.categories.count; i++ {
                        self.categories[i].selected = true
                    }
                }
            } else {
                for var i = 0; i < self.categories.count; i++ {
                    if indexPath.row == i {
                        self.categories[i].selected = !self.categories[i].selected
                    } else {
                        self.categories[i].selected = false
                    }
                }
            }
        } else if self.menuView.selectedIndex == 1 {
            for var i = 0 ; i < self.distances.count; i++ {
                if i == indexPath.row {
                    self.distances[i].selected = !self.distances[i].selected
                } else {
                    self.distances[i].selected = false
                }
            }
        } else {
            if indexPath.row == 0 {
                if self.conditions[0].selected {
                    for var i = 0; i < self.conditions.count; i++ {
                        self.conditions[i].selected = false
                    }
                } else {
                    for var i = 0; i < self.conditions.count; i++ {
                        self.conditions[i].selected = true
                    }
                }
            } else {
                self.conditions[indexPath.row].selected = !self.conditions[indexPath.row].selected
                self.conditions[0].selected = true
                for var i = 1; i < self.conditions.count; i++ {
                    if self.conditions[i].selected == false {
                        self.conditions[0].selected = false
                        break
                    }
                }
            }
        }
        
        self.tableview.reloadData()
    }
    

    func tapGestureAction (sender: AnyObject){
        self.searchBar.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        self.tableHeight = keyboardFrame.origin.y - self.menuView.frame.origin.y - self.menuView.frame.size.height
        if self.tableview.hidden == false {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableHeight)
            })
        }

    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        self.tableHeight = self.applyFilterView.frame.origin.y - self.menuView.frame.origin.y - self.menuView.frame.size.height
        if self.tableHeight > CGFloat(self.tableData.count * 44) {
            self.tableHeight = CGFloat(self.tableData.count * 44)
        }
        if self.tableview.hidden == false {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableHeight)
            })
        }
    }
}
