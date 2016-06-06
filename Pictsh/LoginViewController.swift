//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickLoginButton(sender: AnyObject) {
        self.closeKeypad()
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error{
                print("Login error: \(error.localizedDescription)")
                self.showAlert("Login Error", alertMessage: error.localizedDescription)
            }else{
                print("Login successful")
                self.performSegueWithIdentifier("loginSuccessSegue", sender: sender)
            }
        }
    }
    
    
    @IBAction func onClickSignupButton(sender: AnyObject) {
        closeKeypad()
        let enteredUsername = self.usernameTextField.text
        let enteredPassword = self.passwordTextField.text
        
        if enteredUsername?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
            self.showAlert("Sign-up Error", alertMessage: "username cannot be empty")
        } else if enteredPassword?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
            self.showAlert("Sign-up Error", alertMessage: "password cannot be empty")
        } else {
            let newUser = PFUser()
            newUser.username = self.usernameTextField.text
            newUser.password = self.passwordTextField.text
            
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    self.showAlert("Error!", alertMessage: error.localizedDescription)
                } else {
                    print("User Registered successfully")
                    self.performSegueWithIdentifier("loginSuccessSegue", sender: nil)
                }
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
    
    @IBAction func onTapBackground(sender: AnyObject) {
        self.closeKeypad()
    }
    
    func closeKeypad(){
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
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
