//
//  CaptureViewController.swift
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

protocol ContentSharing {
    func updatePostCollection(post: Post)
}

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var newpostImage: UIImageView!
    
    @IBOutlet weak var newpostCaption: UITextField!
    
    @IBOutlet weak var shareButton: UIButton!
    
    static var delegate: ContentSharing?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shareButton.enabled = false
        
        let chooseImage = UITapGestureRecognizer(target: self, action: #selector(CaptureViewController.instantiateImagePicker))
        self.newpostImage.addGestureRecognizer(chooseImage)
        self.newpostImage.userInteractionEnabled = true
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func instantiateImagePicker(){
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = self.resize(originalImage, newSize: CGSize(width: 300, height: 180))
            //self.newpostImage.image = originalImage
            self.newpostImage.image = editedImage
            self.shareButton.enabled = true
            
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFit
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    @IBAction func onTapShareButton(sender: AnyObject) {
        self.closeKeypad()
        if self.newpostImage != UIImage(named: "upload_photo"){
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "sharing.."
            hud.labelFont.fontWithSize(10)
            
            let post = PFObject(className: "Post")
            
            // Add relevant fields to the object
            post["media"] = getPFFileFromImage(self.newpostImage.image) // PFFile column type
            post["author"] = PFUser.currentUser()?.objectId // Pointer column type that points to PFUser
            post["caption"] = self.newpostCaption.text
            post["likesCount"] = 0
            post["commentsCount"] = 0
            
            post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
                if let error = error{
                    hud.labelText = "Error occurred"
                    print("Upload error: \(error.localizedDescription)")
                }else{
                    self.newpostCaption.text = ""
                    self.newpostImage.image = UIImage(named: "upload_photo")
                    hud.labelText = "Posted!"
                    self.shareButton.enabled = false
                    CaptureViewController.delegate?.updatePostCollection(Post(pfObjectReceived: post))
                }
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    func showAlert(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func closeKeypad(){
        self.newpostCaption.resignFirstResponder()
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
