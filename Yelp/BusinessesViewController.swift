//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,filterViewControllerDelegate ,UISearchBarDelegate, UIScrollViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    
    var businesses: [Business]!
    var nameText = ""
    var address = ""
    var miles = ""
    var  reviewcounts : NSNumber!
    var starimageURL: NSURL!
    var bigimageURL: NSURL!
    
    
    override func viewDidLoad() {
        //create a searchBar in navigation controller
        var searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
                
            }
        })
        
        /* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        
        for business in businesses {
        print(business.name!)
        print(business.address!)
        }
        }
        */
        searchBar.delegate = self
        Search("Restaurants")
    }
    var inputText = ""
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        inputText = searchText
        Search(inputText)
        
        tableView.reloadData()
    }
    
    
    func Search(searchTerm: String) {
        Business.searchWithTerm(searchTerm, sort: .Distance, categories: [], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            if(searchTerm != ""){
                self.businesses = businesses
            }
            self.tableView.reloadData()
        }
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell", forIndexPath: indexPath) as! TableCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let busi = businesses![indexPath.row]
        nameText = busi.name!
        address = busi.address!
        miles = busi.distance!
        reviewcounts = busi.reviewCount
        starimageURL = busi.ratingImageURL
        bigimageURL = busi.imageURL
        
        //print(starimageURL)
        self.performSegueWithIdentifier("toDetail", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filter"  {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filterViewController = navigationController.topViewController as! FilterViewController
            filterViewController.delegate = self
        }
        
        if segue.identifier == "toDetail"  {
            let detialViewControllerInstance = segue.destinationViewController as! DetailViewController
            detialViewControllerInstance.addressText = address
            detialViewControllerInstance.nameText = nameText
            detialViewControllerInstance.reviewCountsText = String(reviewcounts)
            detialViewControllerInstance.BigImageURL = bigimageURL
            detialViewControllerInstance.starImageURL = starimageURL
            detialViewControllerInstance.milesText = miles
            
        }
        
        
    }
    
    func filtersViewController(filtersViewController: FilterViewController, didUpdateFilters filters: [String : AnyObject]) {
        var categories = filters["categories"] as! [String]
        Business.searchWithTerm("Restaurants", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
    }
    //implement infinite Scroll
    
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // ... Code to load more results ...
                Search("Restaurants")
            }
        }
    }
}


