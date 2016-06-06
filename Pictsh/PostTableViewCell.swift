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
            
            if let caption = post!["caption"] as? String{
                self.postCaption.text = caption
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userProfileImage.layer.borderWidth = 1.0
        self.userProfileImage.layer.masksToBounds = false
        self.userProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.width/2
        self.userProfileImage.clipsToBounds = true
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
