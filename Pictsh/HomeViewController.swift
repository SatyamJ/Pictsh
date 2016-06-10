//
//  HomeViewController.swift
//  Pictsh
//
//  Created by Satyam Jaiswal on 3/5/16.
//  Copyright © 2016 Satyam Jaiswal. All rights reserved.
//

/*
*  My Instuctors and the University have the right to build and evaluate the
* software package for the purpose of determining my grade and program assessment
*
* Purpose: Fulfilling Lab final project submission of
* SER598 - Mobile Systems course
* This assignment demonstrates use of camera roll for uplaoding images to cloud
*
* @author Satyam Jaiswal Satyam.Jaiswal@asu.edu
*         Software Engineering, ASU Poly
*  Created by Satyam Jaiswal
*  Copyright © 2016 Satyam Jaiswal. All rights reserved.
*/

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContentSharing {
    
    @IBOutlet var tableView: UITableView!
    
    var posts: [Post]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CaptureViewController.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = "Pictsh"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.03, blue: 0.03, alpha: 0.9)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        fetchPost()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        fetchPost()
        refreshControl.endRefreshing()
    }
    
    func updatePostCollection(post: Post) {
        self.posts?.insert(post, atIndex: 0)
    }
    
    func fetchPost(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        
        //query.includeKey("_created_at")
        //query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (feeds: [PFObject]?, error: NSError?) -> Void in
            if let feeds = feeds {
                self.posts = []
                for feed in feeds{
                    let post = Post(pfObjectReceived: feed)
                    self.posts?.append(post)
                }
                self.tableView.reloadData()
            } else {
                print("Error while fetching posts: \(error?.localizedDescription)")
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        cell.post = self.posts![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts{
            return posts.count
        }else{
            return 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
