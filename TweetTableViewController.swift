//
//  TweetTableViewController.swift
//  TwitterSearcher
//
//  Created by Huiyuan Ren on 15/12/15.
//  Copyright © 2015年 Huiyuan Ren. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var SearchTextField: UITextField! {
        didSet{
            SearchTextField.delegate = self
            SearchTextField.text = searchText
            
        }
    }
    var lastSuccessfulRequest : TwitterRequest?
    
    var nextRequestToAttemt:  TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!,count: 50)
            }else{
                return nil
            }
        }else{
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        if(searchText != nil){
            if let request = nextRequestToAttemt{
                request.fetchTweets { (resultTweet) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if (resultTweet.count >  0){
                            self.tweets.insert(resultTweet, atIndex: 0)
                            self.tableView.reloadData()
                            sender.endRefreshing()
                            
                        }
                    }
                }
            }
        }
        else{
            sender.endRefreshing()
        }
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == SearchTextField){
            textField.resignFirstResponder()
            searchText = textField.text
            return true
        }
        return false
    }
    
    var searchText : String? = "#USC" {
        didSet{
            lastSuccessfulRequest = nil
            SearchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    var tweets = [[Tweet]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh(self.refreshControl!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard{
        static let CellReuseIdentifier = "Tweet"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        // Configure the cell...

        return cell
    }
    
    func refresh() {
        if(searchText != nil){
            if let request = nextRequestToAttemt{
              request.fetchTweets { (resultTweet) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if (resultTweet.count >  0){
                        self.tweets.insert(resultTweet, atIndex: 0)
                        self.tableView.reloadData()
                        
                    }
                }
            }
            }
            }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
