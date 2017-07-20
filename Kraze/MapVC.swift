//
//  MapVC.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 14/04/2017.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

class MapVC: UIViewController, GMSMapViewDelegate, UISearchBarDelegate, UITableViewDelegate{
	fileprivate var markerArray = [MapMarker]()
	fileprivate let mapUtils = MapUtils()
	
	private var mySearchBar : UISearchBar!
	private var myTableView : UITableView!
	private var mapViewFirst : GMSMapView!
	//afficher le nom d'opérateur,le temps,la batterie
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
	
	func openSettings(sender: AnyObject) {
		performSegue(withIdentifier: "toSettings", sender: nil)
	}
	
	override func loadView() {
		super.loadView()
		
		
        let camera = GMSCameraPosition.camera(withLatitude:48.86, longitude:2.34, zoom: 14.0)
		let mapViewFirst = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapViewFirst.isMyLocationEnabled = true
        mapViewFirst.settings.myLocationButton = true
        mapViewFirst.settings.scrollGestures = true
        mapViewFirst.settings.zoomGestures = true
        do{
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json"){
                mapViewFirst.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else{
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        //self.view = mapView
		mapViewFirst.delegate = self
		self.view.addSubview(mapViewFirst)




	//	let profilebutton = UIButton(frame:CGRect(x: 0, y: 20, width: 30, height: 30))
	//	profilebutton.setImage(UIImage(named: "images"), for: .normal)
	//	profilebutton.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
	//	self.view.addSubview(profilebutton)
		
		
		
		let profil = UIButton(frame:CGRect(x: 10, y: 40, width: 60, height: 60))
		//profil.setImage(UIImage(named: "images"), for: .normal)
		profil.layer.cornerRadius = 0.5 * profil.bounds.size.width
		profil.clipsToBounds = true
		profil.addTarget(self, action: #selector(openSettings(sender:)), for: .touchUpInside)
		self.view.addSubview(profil)
		

		//Recover Facebook Image
		
		var ref: DatabaseReference!
		ref = Database.database().reference()
		let user = Auth.auth().currentUser
		print(user!.uid)
		ref.child("FacebookUsers").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
			// Get user value
			guard let value = snapshot.value as? [String: String] else { return }
			print(value)
			let id = value["id"] as! String
			let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
			let data = NSData(contentsOf:url! as URL)
			profil.setImage(UIImage(data: data! as Data), for: .normal)
		}){ (error) in
			print(error.localizedDescription)
		}
		
		
		
		struct club {
			let name : String
			let long : CLLocationDegrees
			let lat : CLLocationDegrees
		}
    
		/*
		let clubs = [
			club(name : "Rex", long:2.3474350000000186, lat : 48.87044479999999),
			club(name: "Macumba", long:2.3443311999999423, lat: 48.85990330000001),
			club(name: "Le Montana", long:2.332593999999972, lat: 48.8541722),
			club(name: "Faust", long:2.313656100000003, lat: 48.86421139999999),
			club(name: "La Carré Ponthieu", long:2.309159300000033, lat: 48.8706404),
			club(name: "Le Hobo", long:2.3042944000000034, lat: 48.8702113),
			club(name: "B75", long:2.336842700000034, lat: 48.8819559),
			club(name: "La Java", long:2.37382869999999, lat: 48.87107880000001),
			club(name: "Le Gibus", long:2.3663870000000315, lat: 48.86819899999999),
			club(name: "Le Badaboum", long:2.3757507999999916, lat: 48.8534528),
			club(name: "Le Nouveau Casino", long:2.3778158000000076, lat: 48.86588969999999),
			club(name: "Concrete", long:2.375585699999988, lat: 48.8387596),
			club(name: "Le Batofar", long:2.3788474000000406, lat: 48.83270089999999),
			club(name: "Nuits Fauves", long:2.3704576999999745, lat: 48.84011),
			club(name: "Palais Maillot", long:2.2837405999999874, lat: 48.87928729999999),
			club(name: "La Machine du Moulin Rouge", long:2.3323748999999907, lat: 48.8841471),
			club(name: "Le Glazart", long:2.3869300000000067, lat: 48.8993004),
			club(name: "La Bellevilloise", long:2.391979900000024, lat: 48.8683252),
			club(name: "Le Palais Maillot", long:2.2837405999999874, lat: 48.87928729999999),
			club(name:"Chateau de Montlivault", long: 2.2200765000000047, lat:48.8685461)

        ]*/
		
		
		ref.child("Clubs").observe(.value, with: { (snapshot) in
			for child in snapshot.children{
				let snap = child as! DataSnapshot
				let value = snap.value as? [String: Any]
				print(value)
				let club_name = value?["Name"] as! String
				let club_lat = value?["Latitude"]
				let club_long = value?["Longitude"]
				
			
					
				let club_marker = GMSMarker()
				let clubimage = UIImage(named: "clubmarker")!.withRenderingMode(.alwaysTemplate)
				let markerView = UIImageView(image: clubimage)
				markerView.frame = CGRect(x: 0, y: 0, width: 58, height: 103)
				club_marker.position = CLLocationCoordinate2D(latitude: club_lat! as! CLLocationDegrees, longitude: club_long! as! CLLocationDegrees)
				club_marker.snippet = "Hey, this is \(club_name)"
				club_marker.map = mapViewFirst
				club_marker.iconView = markerView
				//club_marker.isTappable = true
				//club_marker.map = mapView
				}
		}){ (error) in
			print(error.localizedDescription)
		}
	

		func viewWillAppear(_ animated: Bool)
		{
			super.viewWillAppear(animated)
			
			markerArray = mapUtils.randomLocations(withCount: 25000)//
			
			if let visibleMap = self.view as? GMSMapView {
				mapUtils.generateQuadTreeWithMarkers(markerArray, forVisibleArea: visibleMap)
			}
		}
		
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.configure()
	}
	/*
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
	{
		//mapView.selectedMarker = marker
		let Marker = mapView.selectedMarker
		print("Marker is tapped")
		let myFirstButton = UIButton()
		myFirstButton.setTitle("✸", for: .normal)
		myFirstButton.frame = CGRect(x: 0, y: 100, width: 50, height: 50)
		myFirstButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		self.view.addSubview(myFirstButton)
		return true
	}
	*/
	
	func done(_sender:Any) {
		performSegue(withIdentifier: "toEvent", sender: self)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		myTableView.isHidden = false
	}
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		mySearchBar.text = ""
		self.view.endEditing(true)
		myTableView.isHidden = true
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let searchWord = self.mySearchBar.text!
		var ref: DatabaseReference!
		ref = Database.database().reference()
		ref.child("Clubs").observe(.value,with: { (snapshot) in
			for child in snapshot.children{
				let snap = child as! DataSnapshot
				let value = snap.value as? [String: Any]
				let club_name = value?["Name"] as! String
				let club_lat = value?["Latitude"]
				let club_long = value?["Longitude"]
				if (club_name == searchWord){
					print("this one \(club_name)")
					
					let cameraa = GMSCameraPosition.camera(withLatitude:club_lat as! CLLocationDegrees, longitude:club_long as! CLLocationDegrees, zoom: 17.0)
					let newCoorCam = GMSCameraUpdate.setCamera(cameraa)
					self.mapViewFirst?.animate(with: newCoorCam)
					//self.mapViewFirst.animate(to: camera)
					//let newCoor = CLLocationCoordinate2D(latitude: club_lat as! CLLocationDegrees,longitude: club_long as! CLLocationDegrees)
					//let newCoorCam = GMSCameraUpdate.setTarget(newCoor)
					//self.mapViewFirst?.animate(with: newCoorCam)
					return
					
				}else{
					print("On ne trouve pas")
				}
			}
		}){ (error) in
			print(error.localizedDescription)
		}
		
		mySearchBar.text = ""
		self.view.endEditing(true)
		myTableView.isHidden = true
	}
	func configure(){
		mySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 370, height: 40))
		mySearchBar.placeholder = "Club,Adresse"
		mySearchBar.showsCancelButton = true
		mySearchBar.delegate = self
		self.view.addSubview(mySearchBar)
		
		myTableView = UITableView(frame: CGRect(x: 0, y: 40, width: 370, height: 60))
		myTableView.isHidden = true
		self.view.addSubview(myTableView)
		
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	/*
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		performSegue(withIdentifier: "toEvent", sender: nil)
		return true
	}
	*/
	
	
	//override
	/*	override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
/*extension MapVC{
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
	{
		mapUtils.mainQueue.cancelAllOperations()
		mapUtils.backgroundQueue.cancelAllOperations()
		
		if let visibleMap = self.view as? GMSMapView {
			mapUtils.generateQuadTreeWithMarkers(markerArray, forVisibleArea: visibleMap)
		}
	}}
*/
