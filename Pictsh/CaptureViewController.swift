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

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var newpostImage: UIImageView!
    
    @IBOutlet weak var newpostCaption: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
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
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            let editedImage = self.resize(originalImage, newSize: CGSize(width: 300, height: 180))
            //self.newpostImage.image = originalImage
            self.newpostImage.image = editedImage
            // Do something with the images (based on your use case)
            
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    @IBAction func onTapShareButton(sender: AnyObject) {
        self.closeKeypad()
        Post.postUserImage(self.newpostImage.image, withCaption: self.newpostCaption.text) { (success: Bool, error: NSError?) -> Void in
            if success{
                self.showAlert("Post successful", alertMessage: "Post successful")
                //self.dismissViewControllerAnimated(true, completion: nil)
                self.newpostCaption.text = ""
                self.newpostImage.image = UIImage(named: "upload_photo")
            }else{
                self.showAlert("Error occurred", alertMessage: "Try again")
                print("Error while posting: \(error?.localizedDescription)")
            }
        }
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
