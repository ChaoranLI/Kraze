//
//  Messaging.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 03/07/17.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

//////////////////////////////////

class Message: NSObject{
    var text: String?
    var date: NSDate?
    
    var user: User?
}

class User: NSObject{
    var id: String?
    
    var name: String?
    var profileImageName: String?
}

class Club: NSObject{
    var id: String?
    var name: String?
    
    //var tel: String?
    //var address: String?
    //var timetable: [String:(NSDate, NSDate)]?
    //var prices: [String: String]?
    
    var liveUrl: String?
}

//////////////////////////////////

class Messaging: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var club: Club?
    var clubId: String? //club ou clubId -> à choisir
    
    
    var messages: [Message]?    //didSet
    
    
    func loadMessages(){
        /*let ref = Database.database().reference().child("chat")
         ref.observeEventType(.ChildAdded, withBlock:{ (snapshot) in
         if let dictionnary = snapshot.value as? [String: AnyObject] {
         let message = Message()
         message.setValuesForKeysWithDictionary(dictionary)
         print message.text
         }
         }, withCancelBlock: nil)*/
        
        
        
        let ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Clubs").child("Chateau de Montlivault").child("Event").child("Chat").observe(.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: AnyObject] else { return }
            //print(value)
         let contentChat = value["contentChat"] as? String
         print(contentChat)
            
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    var users: [User]?
    
    private let cellId = "cellId"
    
    func setupData() {
        //fonction à supprimer avec l'arrivée de firebase
        let date = Date() as? NSDate
        
        let user1: User = createNewUser(username: "Hector", profileImage: "hectorpic")
        let message1: Message = createMessageWithText(text: "L'ambiance est dingue, c'est le feu !", user: user1, date: date!)
        
        let user2: User = createNewUser(username: "Ines", profileImage: "inespic")
        let message2: Message = createMessageWithText(text: "Queue interminable! Il faut que je rentre pour Krono", user: user2, date: date!)
        
        let user3: User = createNewUser(username: "Chloe", profileImage: "chloepic")
        let message3: Message = createMessageWithText(text: "Seuls ceux sur liste peuvent rentrer actuellement", user: user3, date: date!)
        
        let user4: User = createNewUser(username: "Bastien", profileImage: "bastienpic")
        
        users = [user1, user2, user3, user4]
        messages = [message1, message2, message3]
        messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
    }
    
    func setNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.15))
        let navItem = UINavigationItem(title: "Live")
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
    
    let videoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    var videoURL: String?
    
    
    func handlePlay() {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        
        ref.child("Clubs").child("Chateau de Montlivault").child("Event").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: AnyObject] else { return }
            print(value)
            self.videoURL = value["videoURL"]! as? String
            print(self.videoURL!)
            
            
        }){ (error) in
            print(error.localizedDescription)
        }
        
        /*
         if let url = URL(string: videoURL!){
         player = AVPlayer(url: url)
         
         playerLayer = AVPlayerLayer(player: player)
         playerLayer?.frame = videoContainer.bounds
         videoContainer.layer.addSublayer(playerLayer!)
         player?.play()
         }*/
    }
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder =
            NSAttributedString(string: "Commentaire", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = UIColor.white
        return textField
    }()
    
    let textFieldBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 1)
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton()
        //btn.setImage(UIImage(named: "sendincon"), for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        btn.backgroundColor = UIColor.lightGray
        return btn
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //Gestion de l'envoi du message
    func handleSend() {
        print(inputTextField.text!)
        let date = Date() as? NSDate
        messages?.append(createMessageWithText(text: inputTextField.text!, user: (users?[3])!, date: date!))
        
        let insertionIndexPath = IndexPath(item: self.messages!.count - 1, section: 0)
        collectionView?.insertItems(at: [insertionIndexPath])
        self.collectionView?.scrollToItem(at: insertionIndexPath, at: .bottom, animated: true)  //ne fonctionne pas
        
        inputTextField.text = ""
        
        //Message uploaded sur firebase
        
        
        
        
        
        
        
        
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    private func setupInputComponents(){
        view.addSubview(messageInputContainerView)
        messageInputContainerView.addSubview(textFieldBubbleView)
        textFieldBubbleView.addSubview(inputTextField)
        textFieldBubbleView.addSubview(sendButton)
        messageInputContainerView.addSubview(userProfileImageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        view.addConstraintsWithFormat(format: "H:|-56-[v0]-8-|", views: textFieldBubbleView)
        view.addConstraintsWithFormat(format: "V:[v0(36)]-8-|", views: textFieldBubbleView)
        
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: inputTextField)
        view.addConstraintsWithFormat(format: "V:[v0]-8-|", views: inputTextField)
        
        view.addConstraintsWithFormat(format: "H:[v0(30)]-3-|", views: sendButton)
        view.addConstraintsWithFormat(format: "V:[v0(30)]-3-|", views: sendButton)
        
        view.addConstraintsWithFormat(format: "H:|-8-[v0(36)]", views: userProfileImageView)
        view.addConstraintsWithFormat(format: "V:[v0(36)]-8-|", views: userProfileImageView)
        
        self.userProfileImageView.image = UIImage(named: "bastienpic")
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 0.5)   //darkGray
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputComponents()
        
        setupData()
        
        view.addSubview(videoContainer)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: videoContainer)
        view.addConstraintsWithFormat(format: "V:|-\(view.frame.height * 0.15)-[v0(\(view.frame.height * 0.35))]", views: videoContainer)
        
        handlePlay()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.setNavigationBar()
        
        //Firebase
        loadMessages()
        
        
        
    }
    
    //Gestion du keyboard
    func handleKeyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            print(keyboardFrame!)
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? (-keyboardFrame!.height) : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()  //animation de l'apparition du clavier
                
            }, completion: { (completed) in
                
                //if isKeyboardShowing {  //les bulles remontent avec le clavier: ne fonctionne pas
                let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                //}
                
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count    //le nombre de messages affichés
        }
        return 0
    }
    
    //permet de creer un message a partir des 3 infos
    func createMessageWithText(text: String, user: User, date: NSDate) -> Message {
        let message = Message()
        message.user = user
        message.text = text
        message.date = date
        return message
    }
    
    func createNewUser(username: String, profileImage: String) -> User {
        let user = User()
        user.name = username
        user.profileImageName = profileImage
        return user
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView.text = messages?[indexPath.item].text
        cell.userNameTextView.text = messages?[indexPath.item].user?.name
        
        if let date = messages?[indexPath.item].date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            
            cell.dateTextView.text = dateFormatter.string(from: date as Date)
        }
        
        if let messageText = messages?[indexPath.item].text, let profileImageName = messages?[indexPath.item].user?.profileImageName, let username = messages?[indexPath.item].user?.name {
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            //estimation du rectangle pour affichage du message et de la bulle
            let size = CGSize(width: view.frame.width - (8 + 40 + 8 + 8 + 8 + 8), height: 1500)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            //estimation du rectangle pour affichage du username
            let size2 = CGSize(width: 150, height: 1000)
            let estimatedFrame2 = NSString(string: username).boundingRect(with: size2, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)], context: nil)
            
            cell.userNameTextView.frame = CGRect(x: 56 + 8, y: 0, width: estimatedFrame2.width + 20, height: estimatedFrame.height + 10)
            
            cell.dateTextView.frame = CGRect(x: 56 + 8 + estimatedFrame2.width + 8, y: 3, width: 55, height: estimatedFrame.height + 10)
            
            cell.messageTextView.frame = CGRect(x: 56 + 8, y: 20, width: view.frame.width - (8 + 40 + 8 + 8 + 8 + 8), height: estimatedFrame.height + 20)
            
            cell.textBubbleView.frame = CGRect(x: 56, y: 0, width: view.frame.width - (8 + 40 + 8 + 8), height: estimatedFrame.height + 20 + 18)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: view.frame.width - (8 + 40 + 8 + 8 + 8 + 8), height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 30 + 8)
        }
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(view.frame.height * 0.5 + 8, 0, 48 + 8, 0)   //décalage de 56px à partir du bas de l'écran et debut du chat a la moitie de l'ecran
    }
}







//Affichage des messages
class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Message"    //par défaut
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let userNameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.text = "Username"    //par défaut
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        return textView
    }()
    
    let dateTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = "00:00"    //par défaut
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor(white: 0.5, alpha: 1)
        return textView
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(userNameTextView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addSubview(dateTextView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(36)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|[v0(36)]", views: profileImageView)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


