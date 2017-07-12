//
//  MainVC.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 27/04/2017.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth

class MainVC: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate{

    @IBOutlet weak var FacebookLogin: FBSDKLoginButton!
    @IBOutlet weak var userLoginEmail: UITextField!
    @IBOutlet weak var userLoginPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let facebookLogin = self.FacebookLogin
        facebookLogin?.delegate = self
        facebookLogin?.readPermissions = ["email", "public_profile"]
        
        
        let userLoginEmail = self.userLoginEmail
        let userLoginPassword = self.userLoginPassword
        userLoginEmail?.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])
        userLoginEmail?.textColor = UIColor.white
        userLoginPassword?.attributedPlaceholder = NSAttributedString(string: "Mot de passe", attributes: [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])
        userLoginPassword?.textColor = UIColor.white
        
        if let clearButton = userLoginEmail?.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            clearButton.setImage(templateImage, for: .highlighted)
            // Finally, set the image color
            clearButton.tintColor = .white
        }
        if let clearButton = userLoginPassword?.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            clearButton.setImage(templateImage, for: .highlighted)
            // Finally, set the image color
            clearButton.tintColor = .white
        }
        
        userLoginEmail?.delegate = self
        userLoginPassword?.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    @IBAction func userLoginTapped(_ sender: Any) {
        let userLoginEmail = self.userLoginEmail.text
        let userLoginPassword = self.userLoginPassword.text
        Auth.auth().signIn(withEmail: userLoginEmail!, password: userLoginPassword!) { (user, error) in
            if error != nil{
                print(error)
                self.displayMyAlertMessage(userMessage: "L'email n'exist pas ou le mot de passe incorrect")
                return
            }else{
                print("Vous avez bien connecté")
                self.performSegue(withIdentifier: "segueConnecter", sender: self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil{
                print(user)
                self.performSegue(withIdentifier: "segueConnecter", sender: self)
            }else {
                print("not signed in")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayMyAlertMessage(userMessage:String)
    {
        let myAlert  = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated:true, completion:nil)
        
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
        }
        showInformation()
    }
    func showInformation(){
        let accessToken = FBSDKAccessToken.current()
        let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil{
                print("Something went wrong with our FB user:", error)
                return
            }
            print("Successfully logged in with our FB user:", user)
            guard let uid = user?.uid else{
                return
            }
            let ref: DatabaseReference!
            ref = Database.database().reference(fromURL: "https://kraze-935a0.firebaseio.com/")
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name, id, picture.type(large)"]).start(completionHandler:  { (connection, result, error) -> Void in
                if error != nil{
                    print("Failed to start graph request:", error)
                    return
                }
                let userdict = result as! NSDictionary
                let firstName = userdict["first_name"] as! String
                let lastName = userdict["last_name"] as! String
                let email = userdict["email"] as! String
                let id = userdict["id"] as! String
                print(firstName)
                print(lastName)
                print(email)
                print(userdict)
                let usersReference = ref.child("FacebookUsers").child(uid)
                let values = ["Firstname": firstName, "Lastname": lastName, "email": email, "id" :id]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil{
                        print(err)
                        return
                    }
                    print("Saved user successfully into Firebase db")
                })
                
            })
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

}
