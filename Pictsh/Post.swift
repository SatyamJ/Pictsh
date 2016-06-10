//
//  Post.swift
//  Pictsh
//  PlayMovieViewController.swift
//  MovieManagerCoreData
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

class Post: NSObject {
    var id: String?
    var author: String?
    var media: PFFile?
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    var createdAt: NSDate?
    
    init(pfObjectReceived: PFObject) {
        if let id = pfObjectReceived.objectId{
            self.id = id
        }
        
        if let author = pfObjectReceived["author"] as? String{
            self.author = author
        }
        
        if let media = pfObjectReceived["media"] as? PFFile{
            self.media = media
        }
        
        if let caption = pfObjectReceived["caption"] as? String{
            self.caption = caption
        }
        
        if let likesCount = pfObjectReceived["likesCount"] as? Int{
            self.likesCount = likesCount
        }
        
        if let commentsCount = pfObjectReceived["commentCount"] as? Int{
            self.commentsCount = commentsCount
        }
        
        if let createdAt = pfObjectReceived.createdAt{
            self.createdAt = createdAt
        }
    }
    /*
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser()?.username // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock(completion)
    }
    
    
    // Method to convert UIImage to PFFile
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    */
}
