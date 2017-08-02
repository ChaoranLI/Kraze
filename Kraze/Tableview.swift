//
//  Tableview.swift
//  Kraze
//
//  Created by 李焯然 on 25/07/2017.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//
import UIKit
import Firebase

class tableView: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    //@IBOutlet weak var searchBar: UISearchBar!
    //var clubs = ["First", "Second", "Third", "Four", "Five", "Six"]
    var clubs = [String]()
    var filterClubs = [String]()
    var stringToPass = String()
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    /*
    func setNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50))
        let navItem = UINavigationItem(title: "Clubs")
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: nil, action: #selector(back))
        let myBtn: UIButton = UIButton()
        myBtn.setImage(UIImage(named: "quiticon"), for: .normal)
        myBtn.frame = CGRect(x:0, y:0, width:70, height:70)
        myBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: myBtn), animated: true)
        
        navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        //self.view.addSubview(navBar)
        self.tableView.addSubview(navBar)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureClubs()
        
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        
        let searchBar = self.searchController.searchBar
        searchBar.delegate = self
        
        self.tableView.tableFooterView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        //self.searchController.dimsBackgroundDuringPresentation = false
        
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        definesPresentationContext = true
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            //return self.clubs.count
            return 0
        } else{
            return self.filterClubs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell()
        
        if tableView == self.tableView{
            cell.textLabel?.text = self.clubs[indexPath.row]
        } else{
            cell.textLabel?.text = self.filterClubs[indexPath.row]
        }
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //Filter through the clubs
        self.filterClubs = self.clubs.filter { (club: String) -> Bool in
            if club.lowercased().contains(self.searchController.searchBar.text!.lowercased()){
                return true
            }else{
                return false
            }
        }
        //Update the results TableView
        self.resultsController.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stringToPass = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
        //print(stringToPass)
        performSegue(withIdentifier: "segueBacktoMap", sender: self)
    }
    
    func configureClubs(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Clubs").observe(.value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let value = snap.value as? [String: Any]
                let club_name = value?["Name"] as! String
                
                self.clubs.append(club_name)
            }
            
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBacktoMap" {
            let destinationVC = segue.destination as! MapVC
            destinationVC.receviedString = self.stringToPass
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "seguetoMap", sender: nil)
    }
}
