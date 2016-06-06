//
//  TabBarViewController.swift
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

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLoginScreen(sender: UIStoryboardSegue){
        PFUser.logOut()
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        //self.window?.rootViewController = vc
        self.dismissViewControllerAnimated(true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") //as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        if PFUser.currentUser() == nil {
            print("User logged out successfully")
        }
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
