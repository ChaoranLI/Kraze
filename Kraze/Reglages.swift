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


class ReglagesVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Barre de navigation
    @IBOutlet weak var buttonLogout: UIBarButtonItem!
    @IBOutlet weak var buttonBack: UIBarButtonItem!
    
    //Image et nom du user
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!

    //Switchs du filtre
    @IBOutlet weak var switchClub: UISwitch!
    @IBOutlet weak var switchEpicerie: UISwitch!
    @IBOutlet weak var switchDistribAuto: UISwitch!
    @IBOutlet weak var switchRestaurant: UISwitch!
    @IBOutlet weak var switchStationService: UISwitch!
    
    //Boutons conditions d'utilisation et report de pb
    @IBOutlet weak var buttonMesInfos: UIButton!
    @IBOutlet weak var buttonAPropos: UIButton!
    
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
            print("Mail sent failure: \(error?.localizedDescription)")
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
