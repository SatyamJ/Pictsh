//
//  SignupViewController.swift
//  Pictsh
//
//  Created by Satyam Jaiswal on 3/5/16.
//  Copyright © 2016 Satyam Jaiswal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var newNameField: UITextField!
    
    @IBOutlet weak var newUsernameField: UITextField!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var newEmailField: UITextField!
    
    @IBOutlet weak var registerbutton: UIButton!
    
    @IBOutlet weak var newPoster: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chooseDP = UITapGestureRecognizer(target: self, action: Selector("instantiateImagePicker"))
        self.newPoster.addGestureRecognizer(chooseDP)
        self.newPoster.userInteractionEnabled = true

        // Do any additional setup after loading the view.
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
            //let editedImage = self.resize(originalImage, newSize: CGSize(width: 300, height: 180))
            //self.newpostImage.image = originalImage
            self.newPoster.image = originalImage
            // Do something with the images (based on your use case)
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func onTapRegisterButton(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = newUsernameField.text
        newUser.password = newPasswordField.text
        newUser.email = newEmailField.text
        
        newUser.setObject(self.newNameField.text!, forKey: "name")
        
        let imageData = UIImageJPEGRepresentation(self.newPoster.image!, 0.05)
        let imageFile = PFFile(name:"image.jpg", data:imageData!)
        //imageFile!.save()
        //let file = getPFFileFromImage(self.newPoster.image!)
        newUser.setObject( imageFile!, forKey: "media")
        
        //newUser.
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("New user created")
                //self.performSegueWithIdentifier("registrationSuccessSegue", sender: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
                /*
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") //as! UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
                */
            }else{
                print("Error in signup: \(error?.localizedDescription)")
                if error?.code == 202{
                    self.showAlert("Username is already taken", alertMessage: "Choose another username")
                }else{
                    self.showAlert("Error", alertMessage: "Check the entries")
                }
            }
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        if registerbutton === sender {
            print("segue called")
            
            let newUser = PFUser()
            newUser.username = newUsernameField.text
            newUser.password = newPasswordField.text
            newUser.email = newEmailField.text
            
            newUser.setObject(self.newNameField.text!, forKey: "name")
            
            let imageData = UIImageJPEGRepresentation(self.newPoster.image!, 0.05)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            //imageFile!.save()
            //let file = getPFFileFromImage(self.newPoster.image!)
            newUser.setObject( imageFile!, forKey: "media")
            
            //newUser.
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    print("New user created")
                    self.performSegueWithIdentifier("registrationSuccessSegue", sender: nil)
                    
                }else{
                    print("Error in signup: \(error?.localizedDescription)")
                    if error?.code == 202{
                        self.showAlert("Username is already taken", alertMessage: "Choose another username")
                    }else{
                        self.showAlert("Error", alertMessage: "Check the entries")
                    }
                }
            }
        }*/
    }
    

}
