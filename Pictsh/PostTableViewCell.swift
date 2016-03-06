//
//  PostTableViewCell.swift
//  Pictsh
//
//  Created by Satyam Jaiswal on 3/5/16.
//  Copyright © 2016 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postUsername: UILabel!
    
    @IBOutlet weak var postImage: PFImageView!
    
    @IBOutlet weak var postTimeInterval: UILabel!
    
    @IBOutlet weak var postCaption: UILabel!
    
    @IBOutlet weak var userProfileImage: PFImageView!
    
    
    var post: PFObject?{
        didSet{
            self.postUsername.text = "\(post!["author"])"
            self.postImage.file = post!["media"] as? PFFile
            self.postImage.loadInBackground()
            
            if let caption = post!["caption"]{
                self.postCaption.text = caption as! String
            }
            
            if let date = post?.createdAt{
                self.postTimeInterval.text = NSDate().offsetFrom(date)
            }
            
            
            if let username = post!["author"]{
                let query = PFQuery(className: "_User")
                query.whereKey("username", equalTo: username)
                
                query.getFirstObjectInBackgroundWithBlock { (user: PFObject?, error: NSError?) -> Void in
                    if(error == nil) {
                        if let file = user!["media"]{
                            self.userProfileImage.file = file as? PFFile
                            self.userProfileImage.loadInBackground()
                        }
                    } else {
                        print("user not found")
                    }
                }
            }
            

            
            
            // fetch data asynchronously
            /*
            userQuery.findObjectsInBackgroundWithBlock { (user: [PFObject], error: NSError?) -> Void in
                if let user = user {
                    self.posts = posts
                } else {
                    print("Error while fetching posts: \(error?.localizedDescription)")
                }
            }*/
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        var query:PFQuery=PFQuery(className: "_User");
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                for(var i=0;i<objects!.count;i++){
                    var object=objects![i] as PFObject;
                    var name = object.objectForKey("username") as! String;
                    print(name);
                    
                }
            }
        }*/
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
