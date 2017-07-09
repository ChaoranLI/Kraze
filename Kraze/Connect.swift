//
//  Connect.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 11/04/2017.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit

class Connect: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
		//var loginButton = LoginButton(readPermissions: [.publicProfile])
		//loginButton.center = CGPoint(x:190.0, y:300.0)
		let newCenter = CGPoint(x: self.view.frame.width / 2 , y: (self.view.frame.height / 2)-70 )
		loginButton.center = newCenter
		view.addSubview(loginButton)
		
        // Do any additional setup after loading the view.
    
	}
	
	// fonction login
	@IBAction func userLoginTapped(_ sender: Any) {
		
		let userEmail = self.userEmail.text
		let userPassword = self.userPassword.text
		let userEmailStored = UserDefaults.standard.string(forKey: "userEmail")
		let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword")
		
		if(userEmailStored == userEmail!)
		{
			if(userPasswordStored == userPassword!)
			{
				//login succesful
				UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
				UserDefaults.standard.synchronize()
				//self.dismiss(animated: true, completion: nil)
				self.performSegue(withIdentifier: "segueConnecter", sender: nil)
				
			}else{
				displayMyAlertMessage(userMessage: "Password is wrong")
				return;
			}
		}else{
			displayMyAlertMessage(userMessage: "Email does not exist")
			return;
		}
		/*if(userEmailStored == userEmail || userPasswordStored == userPassword)
		{
			performSegue(withIdentifier: "segueToMap", sender: nil)
		}*/
		/*if(userEmailStored == userEmail && userPasswordStored == userPassword)
		{
			performSegue(withIdentifier: "segueToMap", sender: nil)
		}*/
		
	}
	// fonction facebook login
	func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
		print("Logged in!")
		//id, name, first_name, last_name, picture.type(large), email, updated_time,age_range
		FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name,email"]).start(completionHandler: {(connection, result, error) -> Void in
			if (error == nil){
				if let userDict = result as? NSDictionary {
					//let first_Name = userDict["first_name"] as! String
					//let last_Name = userDict["last_name"] as! String
					//let id = userDict["id"] as! String
					//let email = userDict["email"] as! String
					//let age_range = userDict["age_range"] as! [String: Int], min = age_range["min"]
					//print(first_Name)
					//print(last_Name)
					//print(id)
					//print(email)
					//print(min as Any)
					print(userDict)
					let username = userDict["name"] as! String
					let useremail = userDict["email"] as! String
					print(username as Any)
					print(useremail as Any)
				}
			}
		})
		performSegue(withIdentifier: "fbsegue", sender: nil)
	}
	func loginButtonDidLogOut(_ loginButton: LoginButton) {
		print("User Logged Out")
	}
	
	//Creat a alert view
	func displayMyAlertMessage(userMessage:String)
	{
		let myAlert  = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
		
		let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:nil)
		
		myAlert.addAction(okAction)
		
		self.present(myAlert, animated:true, completion:nil)
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

