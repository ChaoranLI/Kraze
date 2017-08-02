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
//UIViewController
class MapVC: UIViewController, GMSMapViewDelegate, UISearchBarDelegate, UITableViewDelegate{
	fileprivate var markerArray = [MapMarker]()
	fileprivate let mapUtils = MapUtils()
	
	private var mySearchBar : UISearchBar!
	private var mapViewFirst : GMSMapView!
	private var myTableView : UITableView!
	
	private var latitude = 48.86
	private var longitude = 2.34
	
	var receviedString = String()
	//afficher le nom d'opérateur,le temps,la batterie
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
	
	func openSettings(sender: AnyObject) {
		performSegue(withIdentifier: "toSettings", sender: nil)
	}
	
	override func loadView() {
		super.loadView()
		
		
        let camera = GMSCameraPosition.camera(withLatitude:latitude, longitude:longitude, zoom: 14.0)
		let mapViewFirst = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
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
		
		
		
		let profil = UIButton(frame:CGRect(x: 10, y: 70, width: 60, height: 60))
		//profil.setImage(UIImage(named: "images"), for: .normal)
		profil.layer.cornerRadius = 0.5 * profil.bounds.size.width
		profil.clipsToBounds = true
		profil.addTarget(self, action: #selector(openSettings(sender:)), for: .touchUpInside)
		self.view.addSubview(profil)
		//Recover Facebook Image
		var ref: DatabaseReference!
		ref = Database.database().reference()
		let user = Auth.auth().currentUser
		//print(user!.uid)
		ref.child("FacebookUsers").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
			// Get user value
			guard let value = snapshot.value as? [String: String] else { return }
			//print(value)
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
		
		
		ref.child("Clubs").observe(.value, with: { (snapshot) in
			for child in snapshot.children{
				let snap = child as! DataSnapshot
				let value = snap.value as? [String: Any]
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
				
				if club_marker.position.latitude == self.latitude{
					club_marker.iconView?.tintColor = UIColor.red
				}
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
		self.showclubs()
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		performSegue(withIdentifier: "seguetoTableView", sender: nil)
	}
	
	
	/*
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		myTableView.isHidden = false
		performSegue(withIdentifier: "seguetoTableView", sender: nil)
		
	}
	*/
	
	
	
	func configure(){
		let screenSize = UIScreen.main.bounds
		let screenWidth = screenSize.width
		mySearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
		mySearchBar.placeholder = "Club,Adresse"
		mySearchBar.showsCancelButton = true
		mySearchBar.delegate = self
		mySearchBar.showsCancelButton = false
		self.view.addSubview(mySearchBar)
		mySearchBar.barStyle = UIBarStyle.black
		mySearchBar.isTranslucent = true
		
		myTableView = UITableView(frame: CGRect(x: 0, y: 65, width: screenWidth, height: 100))
		myTableView.delegate = self
		self.view.addSubview(myTableView)
		myTableView.isHidden = true
	}
	
	func showclubs(){
		var ref: DatabaseReference!
		ref = Database.database().reference()
		ref.child("Clubs").observe(.value,with: { (snapshot) in
			for child in snapshot.children{
				let snap = child as! DataSnapshot
				let value = snap.value as? [String: Any]
				let club_name = value?["Name"] as! String
				let club_lat = value?["Latitude"]
				let club_long = value?["Longitude"]
				if (club_name == self.receviedString){
					print("this one \(club_name)")
					self.latitude = club_lat as! CLLocationDegrees
					self.longitude = club_long as! CLLocationDegrees
					self.loadView()
					self.configure()
					return
				
				}else{
					//print("On ne trouve pas")
				}
			}
		}){ (error) in
			print(error.localizedDescription)
		}
	}
	
}
extension MapVC{
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		//bandeau aperçu
		print("HI")
		return true
	}
}
