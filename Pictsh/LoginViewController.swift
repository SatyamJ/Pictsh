//
//  LoginViewController.swift
//  Pictsh
//
//  Created by Satyam Jaiswal on 3/5/16.
//  Copyright © 2016 Satyam Jaiswal. All rights reserved.
//

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
            if user != nil {
                print("Login successful")
                self.performSegueWithIdentifier("loginSuccessSegue", sender: nil)
                
                /*
                //creating toast
                let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height-100, 300, 35))
                let x = UILabel(frame: CGRect(x: <#T##Double#>, y: <#T##Double#>, width: <#T##Double#>, height: <#T##Double#>))
                toastLabel.backgroundColor = UIColor.blackColor()
                toastLabel.textColor = UIColor.whiteColor()
                toastLabel.textAlignment = NSTextAlignment.Center;
                self.view.addSubview(toastLabel)
                toastLabel.text = "Login successful"
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 10;
                toastLabel.clipsToBounds  =  true
                /*UIView.animateWithDuration(4.0, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    
                    toastLabel.alpha = 0.0
                    
                })*/
                UIView.animateWithDuration(4, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        toastLabel.alpha = 0.0
                    }, completion: { (bool) -> Void in
                        
                })*/
                
            }else{
                print("Login error: \(error?.localizedDescription)")
                self.showAlert("User does not exist", alertMessage: "Username or passowrd is incorrect")
            }
        }
    }
    
    
    @IBAction func onClickSignupButton(sender: AnyObject) {
        self.closeKeypad()
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        //newUser.
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("New user created")
                self.performSegueWithIdentifier("loginSuccessSegue", sender: nil)
            }else{
                print("Error in signup: \(error?.localizedDescription)")
                if error?.code == 202{
                    self.showAlert("Username is already taken", alertMessage: "Choose another username")
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
    
    @IBAction func unwindToLoginScreenfromRegister(sender: UIStoryboardSegue){
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(vc, animated: true, completion: nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") //as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        if PFUser.currentUser() == nil {
            print("User logged out successfully")
        }*/
        print("unwind called")
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
