//
//  SignUpViewViewController.swift
//  
//
//  Created by Xuan Tung Nguyen on 11/04/2017.
//
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import Firebase
import FirebaseAuth
        //FBSDKLoginButtonDelegate
class SignUpViewViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate{
    // variable in the inscription scene
    @IBOutlet weak var UserFirstName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userPasswordConfirm: UITextField!
    // variable in the main scene
    @IBOutlet weak var userLoginEmail: UITextField!
    @IBOutlet weak var userLoginPassword: UITextField!
    
    @IBOutlet weak var Navigation: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set facebook login button
        
        let loginbutton = FBSDKLoginButton()
        loginbutton.frame = CGRect(x: 130, y: 200, width: 100, height: 30)
        view.addSubview(loginbutton)
        loginbutton.delegate = self
        loginbutton.readPermissions = ["email", "public_profile"]
        
        
        
        //set attributes for textfield of Main scene
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
        
        //set attributes for textfield of Inscription scene
        let UserFirstName = self.UserFirstName
        let userLastName = self.userLastName
        let userEmail = self.userEmail
        let userPassword = self.userPassword
        let userPasswordConfirm = self.userPasswordConfirm
        UserFirstName?.attributedPlaceholder = NSAttributedString(string: "Prénom", attributes: [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])
        UserFirstName?.textColor = UIColor.white
        userLastName?.attributedPlaceholder = NSAttributedString(string: "Nom", attributes: [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])
        userLastName?.textColor = UIColor.white
        userEmail?.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])
        userEmail?.textColor = UIColor.white
        userPassword?.attributedPlaceholder = NSAttributedString(string: "Mot de passe", attributes: [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])
        userPassword?.textColor = UIColor.white
        userPasswordConfirm?.attributedPlaceholder = NSAttributedString(string: "Vérification", attributes: [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
            ])
        userPasswordConfirm?.textColor = UIColor.white
        
        // set color of clear button
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
        if let clearButton = userEmail?.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            clearButton.setImage(templateImage, for: .highlighted)
            // Finally, set the image color
            clearButton.tintColor = .white
        }
        if let clearButton = userPassword?.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            clearButton.setImage(templateImage, for: .highlighted)
            // Finally, set the image color
            clearButton.tintColor = .white
        }
        if let clearButton = userPasswordConfirm?.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            clearButton.setImage(templateImage, for: .highlighted)
            // Finally, set the image color
            clearButton.tintColor = .white
        }
        
        //set delegate for UItext
        userLoginEmail?.delegate = self
        userLoginPassword?.delegate = self
        UserFirstName?.delegate = self
        userLastName?.delegate = self
        userEmail?.delegate = self
        userPassword?.delegate = self
        userPasswordConfirm?.delegate = self
    }
    
    
    //keyboard hidden
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //configurate navigation bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // checkbox for the button to change the image
    @IBAction func checkbox(_ sender: UIButton) {
        if (sender.isSelected == true)
        {
            sender.setImage(UIImage(named: "Checkbox"), for: UIControlState.normal)
            sender.isSelected = false;
        }
        else
        {
            sender.setImage(UIImage(named: "Checked_checkbox"), for: UIControlState.normal)
            sender.isSelected = true;
        }
    }
    
    
    // Inscription fonction(firebase)
    @IBAction func registerButtonClicked(_ sender: Any) {
        let userFirstName =  self.UserFirstName.text;
        let  userLastName = self.userLastName.text;
        let  userEmail = self.userEmail.text;
        let userPassword = self.userPassword.text;
        let   userPasswordConfirm = self.userPasswordConfirm.text;
        //let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let mailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z.-]+\\.[A-Za-z]{2,64}"
        let passwordPattern = "(?=.*[A-Z]{1,})(?=.*?[0-9]{1,}).{8,}"
        //let passwordPattern = ""/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&.])[A-Za-z\d$@$!%*?&.]{6, 20}/""
        //let passwordPattern = ""^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$""
        let matcherMail = MyRegex(mailPattern)
        let matcherPassword = MyRegex(passwordPattern)
            
        //let URL_USER_REGISTER = "http://api.kraze.fr/v1/register/"
        // Check for Empty Fields
        if( (userEmail?.isEmpty)! || (userPassword?.isEmpty)! || (userPasswordConfirm?.isEmpty)! || (userFirstName?.isEmpty)! || (userLastName?.isEmpty)!)
        {
            // Display error message
            displayMyAlertMessage(userMessage: "Please complete all fields")
            return;
        }
        if(userPassword != userPasswordConfirm)
        {
            // Check if passwords match
            displayMyAlertMessage(userMessage: "Passwords do not match")
            return;
        }
            // check if email is correct
        if !(matcherMail.match(input: userEmail!)) {
            displayMyAlertMessage(userMessage: "Email n'est pas correct")
            return;
        }
        if !(matcherPassword.match(input: userPassword!)) {
            displayMyAlertMessage(userMessage: "Votre mot de passe doit contenir au minimum 8 caractères dont une majuscule et un chiffre")
            return;
        }
        
        //Display confirmation Registration alert message
        let myAlert = UIAlertController(title: "Alert", message: "Registration Successful", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default){ action in
            self.dismiss(animated: true,completion: nil)
        }
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion:nil)
        
        // register user into firebase
        Auth.auth().createUser(withEmail: userEmail!, password: userPassword!) { (user, error) in
            if error != nil{
                print(error)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            // successfully register user
            let ref: DatabaseReference!
            ref = Database.database().reference(fromURL: "https://kraze-935a0.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["Firstname": userFirstName, "Lastname": userLastName, "email": userEmail, "password" : userPassword]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err)
                    return
                }
                print("Saved user successfully into Firebase db")
            })
        }
    }
    
    //Creat a alert view
    func displayMyAlertMessage(userMessage:String)
    {
        let myAlert  = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated:true, completion:nil)
        
    }
    
    // In the main scene, button login(firebase)
    @IBAction func userLoginTapped(_ sender: Any) {
        let userLoginEmail = self.userLoginEmail.text
        let userLoginPassword = self.userLoginPassword.text
        Auth.auth().signIn(withEmail: userLoginEmail!, password: userLoginPassword!) { (user, error) in
            if error != nil{
                print(error)
                return
            }else{
            print("Vous avez bien connecté")
            self.performSegue(withIdentifier: "segueConnecter", sender: self)
            }
        }
    }
    
    //function: transfer infors of Inscription(json) to server
    @IBAction func Afficher(_ sender: Any) {
        let userFirstName = self.UserFirstName.text
        let userLastName = self.userLastName.text
        let userEmail = self.userEmail.text
        let userPassword = self.userPassword.text
        let userPasswordConfirm = self.userPasswordConfirm.text
        // set un array
        let parameters = ["FirstName": userFirstName!,
                          "LastName": userLastName!,
                          "Email": userEmail!,
                          "Password": userPassword!,
                          "PasswordConfirm": userPasswordConfirm!]
        print(parameters)
        //let string = NSString(data: body!, encoding: String.Encoding.utf8.rawValue)
        guard let url = NSURL(string: "https://jsonplaceholder.typicode.com/posts") else{ return }
        var request = URLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // change array to jsondata
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }

    @IBAction func confirmBDD(_ sender: Any) {
        let userLoginEmail = self.userLoginEmail.text
        let userLoginPassword = self.userLoginPassword.text
        let parameters = ["Email": userLoginEmail!,
                          "Password": userLoginPassword!]
        print(parameters)
        guard let url = NSURL(string: "https://jsonplaceholder.typicode.com/posts") else{ return }
        var request = URLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // change array to jsondata
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    //  match for email/password
    struct MyRegex {
        let regex: NSRegularExpression?
        
        init(_ pattern: String) {
            regex = try? NSRegularExpression(pattern: pattern,
                                             options: .caseInsensitive)
        }
        
        func match(input: String) -> Bool {
            if let matches = regex?.matches(in: input,
                                                    options: [],
                                                    range: NSMakeRange(0, (input as NSString).length)) {
                return matches.count > 0
            } else {
                return false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
