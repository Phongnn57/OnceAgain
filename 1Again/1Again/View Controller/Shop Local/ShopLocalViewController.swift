//
//  ShopLocalViewController.swift
//  1Again
//
//  Created by Nam Phong on 7/1/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import UIKit

class ShopLocalViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, FilterViewDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var menuView: FilterView!
    @IBOutlet weak var applyFilterView: ApplyFilterView!
    
    var searchBar: UISearchBar!
    var tableview: UITableView!
    var hud: MBProgressHUD!
    private let cellIdentifier = "ShopLocalCollectionCell"
    var items: [ItemObject]!
    var nextLink: String!
    var totalRecord: String!
    var filterStr: String!
    
    //data
    var categories:[CategoryObject]! = [CategoryObject]()
    var distances:[DistanceObject]! = [DistanceObject]()
    var conditions:[ConditionObject]! = [ConditionObject]()
    var tableData: [AnyObject]! = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.menuView.delegate = self
        self.createSearchBar()
        self.configTableview()
        setMenuButtonAction(menuBtn)
        configCollectionView()
        items = [ItemObject]()
        nextLink = String()
        totalRecord = String()
        filterStr = String()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func loadData() {
        ItemObject.getShopLocalDataFromStringURL(Constant.MyUrl.homeURL.stringByAppendingString("forSale_listJSONV4.php?userid=\(NSUserDefaults.standardUserDefaults().integerForKey(Constant.UserDefaultKey.activeUserId))"), completionClosure: { (resultItems, totalRecord, nextLink) -> () in
            self.items = resultItems
            self.totalRecord = totalRecord
            self.nextLink = nextLink
            self.collectionview.reloadData()
        })
    }
    
    func initData() {
        let distanceList = [["< 10 Miles", "10"], ["< 20 Miles", "20"], ["> 50 Miles", "50"], ["< 100 Miles", "100"], ["< 150 Miles", "150"]]
        let conditionList = [["All Conditions", ""], ["New with Tags", "A"], ["New", "B"], ["Like New", "C"], ["Very Good", "D"], ["Good", "E"], ["Satisfactory", "F"]]
        
        for str in distanceList {
            let distanceObj = DistanceObject(sTitle: str[0], sId: str[1])
            self.distances.append(distanceObj)
        }
        
        for str in conditionList {
            let conditionObj = ConditionObject(sConId: str[1], sConTitle: str[0])
            self.conditions.append(conditionObj)
        }
        

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
        self.collectionview.userInteractionEnabled = false
        self.collectionview.alpha = 0.5
        self.menuView.showViewFromSuperView()
        self.applyFilterView.showViewFromSuperView()
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
    
    func getCondition() -> String {
        if self.conditions[0].selected {
            return ""
        } else {
            var returnStr = ""
            for condition in self.conditions {
                if condition.selected {
                    returnStr = returnStr.stringByAppendingString(condition.conId)
                }
            }
            print("condition: \(returnStr)")
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
    
    func showHUD() {
        self.hud = MBProgressHUD(view: self.view)
        self.hud.delegate = self
        self.hud.labelText = "Loading"
        self.view.addSubview(self.hud)
        self.hud.show(true)
    }
    
    func hideHUD() {
        self.hud.hide(true)
        self.hud.removeFromSuperview()
    }
    
    @IBAction func applyFilterAction(sender: AnyObject) {
        if self.menuView.hidden == false {self.hideAllFilter()}
        self.showHUD()
        ItemAPI.getItemList("forSale_listJSONV4.php", search: self.searchBar.text, condition: self.getCondition(), category: self.getCategory(), distance: self.getDistance(), completion: { (nextLink, totalRecord, items) -> Void in
            self.nextLink = nextLink
            self.totalRecord = totalRecord
            self.items = items
            self.collectionview.reloadData()
            self.hideHUD()
        }) { (error) -> Void in
            print(error)
            self.hideHUD()
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
    
    func hideTableView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.tableview.hidden = true
            self.tableview.center.y -= 1000
        })
    }
    
    func didSelectButtonAtIndex(index: Int) {
        if index != -1 {
            let maxHeight = self.applyFilterView.frame.origin.y - self.menuView.frame.origin.y - 45
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
            print(tblHeight)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableview.hidden = false
                self.tableview.frame = CGRectMake(0, self.menuView.frame.origin.y + 45, self.view.frame.width, tblHeight)
                
                }, completion: { (finished: Bool) -> Void in
                self.tableview.reloadData()
            })
        } else {
            self.hideTableView()
        }
    }
    
    func createSearchBar() {
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, 320, 44))
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.searchBar.sizeToFit()
        self.navigationItem.titleView = self.searchBar
    }
    
    func loadMoreData() {
        if self.totalRecord.toInt() > self.items.count {
            var additionData: [ItemObject] = []
            self.showHUD()
            
            ItemAPI.getItemList(self.nextLink, search:  self.searchBar.text, condition: self.getCondition(), category: self.getCategory(), distance: self.getDistance(), completion: { (nextLink, totalRecord, items) -> Void in
                additionData = items
                self.nextLink = nextLink
                self.totalRecord = totalRecord
                for item in additionData {
                    self.items.append(item)
                }
                additionData.removeAll(keepCapacity: false)
                self.collectionview.reloadData()
                self.hideHUD()
            }, failure: { (error) -> Void in
                print(error)
                self.hideHUD()
            })
            

//            ItemObject.getShopLocalDataFromStringURL(Constant.MyUrl.homeURL + self.nextLink, completionClosure: { (resultItems, totalRecord, nextLink) -> () in
//                additionData = resultItems
//                self.nextLink = nextLink
//                self.totalRecord = totalRecord
//                for item in additionData {
//                    self.items.append(item)
//                }
//                additionData.removeAll(keepCapacity: false)
//                self.collectionview.reloadData()
//            })
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
//        if self.items.count == 0 {
//            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.collectionview.frame.size.width, self.collectionview.frame.size.height))
//            messageLabel.text = "No data is currently available."
//            messageLabel.textColor = UIColor.blackColor()
//            messageLabel.textAlignment = .Center
//            messageLabel.sizeToFit()
//            self.collectionview.backgroundView = messageLabel
//        } else {
//            self.collectionview.backgroundView = nil
//        }
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopLocalCollectionCell
        
        let item = items[indexPath.row]
        cell.setupCellBasedOnItem(item)
        if indexPath.row == items.count - 1 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadMoreData()
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.size.width/2 - 15, height: UIScreen.mainScreen().bounds.size.width/2 + 50)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        if item.category != "15" {
            let shopLocalDetailController = ShopLocalDetailViewController()
            shopLocalDetailController.tmpItemID = item.id
            
//            let shopLocalDetailController = ShopLocalDetailTableViewController()
//            shopLocalDetailController.tmpItemID = item.id
            
            self.navigationController?.pushViewController(shopLocalDetailController, animated: true)
        } else {
            self.addCountByClickingAds(item.id)
            let adsViewController = AdsViewViewController()
            adsViewController.urlStr = item.description
            self.navigationController?.pushViewController(adsViewController, animated: true)
        }
    }
    
    func addCountByClickingAds(itemId: String) {
        let url = "http://theconsignmentclub.com/adclickcount_update.php?id=\(itemId)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error == nil {
                println("SUCCESS UPDATE ADS CLICK COUNT")
            } else {
                println("ERROR: \(error)")
            }
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
            cell.textLabel?.text = self.conditions[indexPath.row].conTitle
            if self.conditions[indexPath.row].selected == true {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
}
