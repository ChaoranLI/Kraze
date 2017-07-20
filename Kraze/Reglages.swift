//
//  Reglages.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 28/06/17.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseAuth


class ReglagesVC: UIViewController, MFMailComposeViewControllerDelegate{
    
    func quitSettings(){
        performSegue(withIdentifier: "closeSettings", sender: self)
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
    }

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImageSettings: UIImageView!
    
   /* private func   setupNavigationBarItems(){
        
        print(123)
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        UINavigationBar.appearance().barTintColor = UIColor.black
        
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "clearicon"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
        
        navigationController?.navigationBar.backgroundColor = .white
        
        
        navigationItem.titleView = titleImageView
        
        
        let quitButton = UIButton(type: .system)
        quitButton.setImage(#imageLiteral(resourceName: "quiticon"), for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: quitButton)
        
        self.view.addSubview(navBar);

    }*/
    
    func setNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.black

        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50))
        let navItem = UINavigationItem(title: "Réglages")
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white

        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: nil, action: #selector(done))
        let myBtn: UIButton = UIButton()
        myBtn.setImage(UIImage(named: "quiticon"), for: .normal)
        myBtn.frame = CGRect(x:0, y:0, width:70, height:70)
        myBtn.addTarget(self, action: #selector(done), for: .touchUpInside)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: myBtn), animated: true)

        navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func done(_sender:Any) {
        performSegue(withIdentifier: "closeSettings", sender: self)

        
    }
    
    override func viewDidLoad() {
        
        let username = self.username
        let userImageSettings = self.userImageSettings
        
        self.setNavigationBar()
    
        let logOutbutton = UIButton(frame:CGRect(x: 330, y: 70, width: 30, height: 30))
        logOutbutton.setImage(UIImage(named: "LogOut"), for: .normal)
        logOutbutton.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
        self.view.addSubview(logOutbutton)
        super.viewDidLoad()
        
        //Pull Facebook photo
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        print(user!.uid)
        ref.child("FacebookUsers").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? [String: String] else { return }
            print(value)
            let id = value["id"] as! String
            let firstname = value["Firstname"] as! String
            let lastname = value["Lastname"] as! String
            let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
            let data = NSData(contentsOf:url! as URL)
            userImageSettings?.image = UIImage(data: data! as Data)
            let name = firstname + " " + lastname
            username?.text = name
        }){ (error) in
            print(error.localizedDescription)
        }
        
        self.userImageSettings.layer.cornerRadius = self.userImageSettings.frame.size.width / 2;
        self.userImageSettings.clipsToBounds = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func returnAction(sender: UIButton!) {
        print("Log out!!!")
        do{
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        performSegue(withIdentifier: "logout", sender: self)
    }
    //Barre de navigation
   
    @IBAction func backToMap(_ sender: Any) {
        performSegue(withIdentifier: "closeSettings", sender: self)
    }
   
    
    @IBOutlet weak var userProfile: UIImageView!
    
    //Image et nom du user
  
    
    //Switchs du filtre
    @IBOutlet weak var switchClub: UISwitch!
    @IBOutlet weak var switchEpicerie: UISwitch!
    @IBOutlet weak var switchDistribAuto: UISwitch!
    @IBOutlet weak var switchRestaurant: UISwitch!
    @IBOutlet weak var switchStationService: UISwitch!
    
    //Boutons conditions d'utilisation et report de pb
    @IBOutlet weak var buttonMesInfos: UIButton!
    @IBAction func buttonapropos(_ sender: Any) {
        performSegue(withIdentifier: "toCGU", sender: nil)
    }
    
    @IBOutlet weak var buttonReportProbleme: UIButton!
    
    //Les trois fonctions suivantes permettent l'envoi d'un mail
    @IBAction func sendEmail(_ sender: Any) {
        print(MFMailComposeViewController.canSendMail()) //print a Boolean indicating whether the current device is able to send email
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["contact@kraze.fr"])
            mail.setSubject("Rapport d'erreur")
            mail.setMessageBody("<p>This is test Mail!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            let email = "test@test.com"
            if let url = URL(string: "mailto:\(email)"){
                UIApplication.shared.open(url)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            self.allertInfo(_title: "Mail Info", _message: "Mail is sent successfuly", _actionTitle: "OK")
            print("Mail sent")
        case .failed:
            self.allertInfo(_title: "Mail Info", _message: "Mail isn't sent.",
                            _actionTitle: "OK")
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
    }
    
    
    func allertInfo(_title:String, _message:String, _actionTitle:String) {
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: _actionTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}



