//
//  SignupViewController.swift
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
import ParseUI
import MBProgressHUD

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    @IBOutlet weak var newNameField: UITextField!
    
    @IBOutlet weak var newUsernameField: UITextField!
    
    @IBOutlet weak var newEmailField: UITextField!
    
    @IBOutlet weak var newPoster: PFImageView!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chooseDP = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.instantiateImagePicker))
        self.newPoster.addGestureRecognizer(chooseDP)
        self.newPoster.userInteractionEnabled = true
        setupUI()
        configureTextView()
    }
    
    func setupUI(){
        if let name = PFUser.currentUser()!["name"] as? String{
            self.newNameField.text = name
            self.navigationItem.title = name
        }else{
            self.newNameField.text = ""
        }
        
        if let email = PFUser.currentUser()?.email{
            self.newEmailField.text = email
        }else{
            self.newEmailField.text = ""
        }
        
        if let username = PFUser.currentUser()?.username{
            self.newUsernameField.text = username
        }else{
            self.newUsernameField.text = ""
        }
        /*
        if let password = PFUser.currentUser()?.password{
            self.newPasswordField.text = password
        }
        */
        
        if let bio = PFUser.currentUser()!["bio"] as? String{
            self.bioTextView.text = bio
        }else{
            self.bioTextView.text = ""
        }
        
        
        if let image = PFUser.currentUser()!["display_picture"] as? PFFile{
            self.newPoster!.file = image
            self.newPoster?.loadInBackground()
        }else{
            self.newPoster.image = UIImage(named: "Generic_Avatar")
        }
    }
    
    func configureTextView(){
        bioTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write something about yourself here"
        placeholderLabel.font = UIFont.italicSystemFontOfSize(bioTextView.font!.pointSize)
        placeholderLabel.sizeToFit()
        bioTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, bioTextView.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = !bioTextView.text.isEmpty
    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = !textView.text.isEmpty
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
            self.newPoster.image = originalImage
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
    
    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOutInBackground()
        let loginVC = storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginVC, animated: true, completion: nil)
    }

    
    @IBAction func onSave(sender: AnyObject) {
        self.closeKeypad()
        if let name = self.newNameField.text {
            PFUser.currentUser()?.setObject(name, forKey: "name")
        }else{
            PFUser.currentUser()?.setObject("", forKey: "name")
        }
        
        if let username = self.newUsernameField.text {
            PFUser.currentUser()?.username = username
        }else{
            PFUser.currentUser()?.username = ""
        }
        
        if let email = self.newEmailField.text {
            PFUser.currentUser()?.email = email
        }else {
            PFUser.currentUser()?.email = ""
        }
        
        
        if let bio = self.bioTextView.text {
            PFUser.currentUser()?.setObject(bio, forKey: "bio")
        }else{
            PFUser.currentUser()?.setObject("", forKey: "bio")
        }
        
        if let poster = self.getPFFileFromImage(self.newPoster.image) {
            PFUser.currentUser()?.setObject(poster, forKey: "display_picture")
        }
    
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "updating"
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
            if let error = error{
                hud.labelText = "Error!"
                print("Error occured while saving user information: \(error.localizedDescription)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.showAlert("Something went wrong", alertMessage: error.localizedDescription)
            }else{
                //print("User information saved")
                hud.labelText = "Done!"
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            }
        })
        
    }
    
    
    @IBAction func onViewAsTapped(sender: AnyObject) {
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "poster.png", data: imageData)
            }
        }
        return nil
    }
    
    func closeKeypad(){
        self.newNameField.resignFirstResponder()
        self.newUsernameField.resignFirstResponder()
        self.newEmailField.resignFirstResponder()
        self.bioTextView.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
