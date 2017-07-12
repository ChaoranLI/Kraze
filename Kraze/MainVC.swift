//
//  MainVC.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 27/04/2017.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var userLoginEmail: UITextField!
    @IBOutlet weak var userLoginPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
