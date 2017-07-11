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
import FirebaseStorage
import FBSDKLoginKit
import FBSDKCoreKit

class MapVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	
    @IBOutlet weak var retour: UIButton!
	fileprivate var markerArray = [MapMarker]()
	fileprivate let mapUtils = MapUtils()
	//afficher le nom d'opérateur,le temps,la batterie
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

	let changeImage: UIButton = {
		let changeimage = UIButton(frame:CGRect(x: 150, y: 20, width: 30, height: 30))
		let userCurrent = Auth.auth().currentUser
		let uid = userCurrent?.uid
		let ref: DatabaseReference!
		ref = Database.database().reference(fromURL: "https://kraze-935a0.firebaseio.com/")
		ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
			let value = snapshot.value as? NSDictionary
			let url = value?["profileImageUrl"] as? String
			if url != nil{
				print("URL is not  null")
				print(url)
				let Url = URL(string : url!)
				URLSession.shared.dataTask(with: Url!, completionHandler: { (data, respons, error) in
					if error != nil{
						print(error)
						return
					}
					changeimage.setImage(UIImage(data: data!), for: .normal)
				}).resume()
			}else{
				print("URL is null")
				changeimage.setImage(UIImage(named: "images"), for: .normal)
			}
		})
		//changeimage.setImage(UIImage(named: "images"), for: .normal)
		changeimage.addTarget(self, action: #selector(handleSelectProfileImageView), for: .touchUpInside)
		return changeimage
	}()
	override func loadView() {
		
        let camera = GMSCameraPosition.camera(withLatitude:48.86, longitude:2.34, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		//let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 60, width: 375, height: 667), camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        do{
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json"){
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else{
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.view = mapView
		
		let button = UIButton(frame:CGRect(x: 0, y: 20, width: 30, height: 30))
		button.setImage(UIImage(named: "images"), for: .normal)
		button.addTarget(self, action: #selector(returnAction), for: .touchUpInside)
		self.view.addSubview(button)
		
		/*
		let profil = UIButton(frame:CGRect(x: 50, y: 20, width: 30, height: 30))
		//profil.setImage(UIImage(named: "images"), for: .normal)
		var ref: DatabaseReference!
		ref = Database.database().reference()
		let user = Auth.auth().currentUser
		print(user?.uid)
		ref.child("FacebookUsers").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
			// Get user value
			let value = snapshot.value as! NSDictionary
			print(value)
			let id = value["id"] as! String
			let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
			let data = NSData(contentsOf:url! as URL)
			profil.setImage(UIImage(data: data! as Data), for: .normal)
		}){ (error) in
			print(error.localizedDescription)
		}
		profil.addTarget(self, action: #selector(returnProfile), for: .touchUpInside)
		self.view.addSubview(profil)
		*/
		
		self.view.addSubview(changeImage)
		
		let marker = GMSMarker()
		let markerImage = UIImage(named: "clubmarker")
		let markerView = UIImageView(image: markerImage)
		
	
		
		struct club {
			let name : String
			let long : CLLocationDegrees
			let lat : CLLocationDegrees
		}
    
		let clubs = [
			club(name : "Rex", long:2.3474350000000186, lat : 48.87044479999999),
			club(name : "Salo", long:2.3433646999999382, lat : 48.8691942),
			club(name: "VIP Room", long:2.3331368999999995, lat: 48.8637731),
			club(name: "Macumba", long:2.3443311999999423, lat: 48.85990330000001),
			club(name: "Le Malibv", long:2.347346499999958, lat: 48.8649017),
			club(name: "Les Bains Douches", long:2.3519344999999703, lat: 48.86382800000001),
			club(name: "Le Montana", long:2.332593999999972, lat: 48.8541722),
			club(name: "Germain Club Paradisio", long:2.3365827999999738, lat: 48.85360489999999),
			club(name: "Faust", long:2.313656100000003, lat: 48.86421139999999),
			club(name: "Club des Saints Pères-Don K", long:2.3320889999999963, lat: 48.8569904),
			club(name: "Chez Papillon", long:2.306110799999942, lat: 48.8716438),
			club(name: "Club Montaigne - Maison Blanche", long:2.3030579999999645, lat: 48.86581109999999),
			club(name: "Le Madam", long:2.305839399999968, lat: 48.8710306),
			club(name: "Héritage", long:2.2994648999999754, lat: 48.8739003),
			club(name: "Cartel Club", long:2.2981446000000005, lat: 48.8735934),
			club(name: "Les Planches ", long:2.3109140000000252, lat: 48.871638),
			club(name: "Angie Paris", long:2.3110662000000275, lat: 48.8725153),
			club(name: "Le Baron", long:2.300237799999991, lat: 48.8656501),
			club(name: "Club 49 - Chez Régine", long:2.306110799999942, lat: 48.8716438),
			club(name: "La Carré Ponthieu", long:2.309159300000033, lat: 48.8706404),
			club(name: "Le Queen", long:2.302370300000007, lat: 48.8708398),
			club(name: "Matignon", long:2.3112506999999596, lat: 48.86977900000001),
			club(name: "Chez Raspoutine", long:2.3002707000000555, lat: 48.8716994),
			club(name: "Titty Twister", long:2.3030866000000287, lat: 48.8722019),
			club(name: "Le Hobo", long:2.3042944000000034, lat: 48.8702113),
			club(name: "B75", long:2.336842700000034, lat: 48.8819559),
			club(name: "Folie's Pigalle Paris", long:2.336876899999993, lat: 48.8819903),
			club(name: "La Java", long:2.37382869999999, lat: 48.87107880000001),
			club(name: "Le Gibus", long:2.3663870000000315, lat: 48.86819899999999),
			club(name: "Le Badaboum", long:2.3757507999999916, lat: 48.8534528),
			club(name: "Le Nouveau Casino", long:2.3778158000000076, lat: 48.86588969999999),
			club(name: "Concrete", long:2.375585699999988, lat: 48.8387596),
			club(name: "Le Batofar", long:2.3788474000000406, lat: 48.83270089999999),
			club(name: "Communion (ex Nüba)", long:2.3788474000000406, lat: 48.8412506),
			club(name: "Nuits Fauves", long:2.3704576999999745, lat: 48.84011),
			club(name: "Mix Club", long:2.320959499999958, lat: 48.8427275),
			club(name: "L'Aquarium", long:2.2905335000000377, lat: 48.86219620000001),
			club(name: "Le Duplex", long:2.293083300000035, lat: 48.87380659999999),
			club(name: "L'Arc", long:2.2930628000000297, lat: 2.2930628000000297),
			club(name: "Palais de Tokyo", long:2.2963704999999663, lat: 48.8645723),
			club(name: "Palais Maillot", long:2.2837405999999874, lat: 48.87928729999999),
			club(name: "La Machine du Moulin Rouge", long:2.3323748999999907, lat: 48.8841471),
			club(name: "Le Divan du Monde", long:2.3393934000000627, lat: 48.8824834),
			club(name: "Le Glazart", long:2.3869300000000067, lat: 48.8993004),
			club(name: "La Bellevilloise", long:2.391979900000024, lat: 48.8683252),
			club(name: "Le Bus Palladium", long:2.333333, lat: 48.866667),
			club(name: "Le Globo", long:2.3549434000000247, lat: 48.8701296),
			club(name: "A la Folie", long:2.3852193999999827, lat: 48.8950171),
        ]
        
		for club in clubs{

			let club_marker = GMSMarker()
			let clubimage = UIImage(named: "clubmarker")!.withRenderingMode(.alwaysTemplate)
			let markerView = UIImageView(image: clubimage)
    
			club_marker.position = CLLocationCoordinate2D(latitude: club.lat, longitude: club.long)
			club_marker.title = club.name

			club_marker.snippet = "Hey, this is \(club.name)"
			club_marker.map = mapView
			club_marker.iconView = markerView
		}
		func viewWillAppear(_ animated: Bool)
		{
			super.viewWillAppear(animated)
			
			markerArray = mapUtils.randomLocations(withCount: 25000)//
			
			if let visibleMap = self.view as? GMSMapView {
				mapUtils.generateQuadTreeWithMarkers(markerArray, forVisibleArea: visibleMap)
			}
		}
		
		/*extension ViewController: GMSMapViewDelegate
		{
			func mapView(_ mapView: GMSMapView!, idleAt position: GMSCameraPosition!)
			{
				mapUtils.mainQueue.cancelAllOperations()
				mapUtils.backgroundQueue.cancelAllOperations()
				
				if let visibleMap = self.view as? GMSMapView {
					mapUtils.generateQuadTreeWithMarkers(markerArray, forVisibleArea: visibleMap)
				}
			}*/
		
	}
		
	func mapView(_ mapView: GMSMapView!, didTap marker: GMSMarker!) -> Bool
	{
		mapView.selectedMarker = marker
		return true
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
	
	/*func returnProfile(sender: UIButton!) {
		performSegue(withIdentifier: "seguetoReglage", sender: self)
	}*/
	func returnProfile(sender: UIButton!){
	}
	func handleSelectProfileImageView(){
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		var selectedImageFromPicker: UIImage?
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
			selectedImageFromPicker = editedImage
		}else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
			selectedImageFromPicker = originalImage
		}
		
		if let selectedImage = selectedImageFromPicker{
			changeImage.setImage(selectedImage, for: .normal)
		}
		let imageName = NSUUID().uuidString
		let storageRef = Storage.storage().reference().child("\(imageName).png")
		if let uploadData = UIImagePNGRepresentation(selectedImageFromPicker!){
			storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
				if error != nil {
					print(error)
					return
				}
				if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
					let values = ["profileImageUrl": profileImageUrl]
					self.registerUserIntoDatabase(values: values as [String : AnyObject])
				}
			})
		}
		dismiss(animated: true, completion: nil)
	}
	
	private func registerUserIntoDatabase(values: [String: AnyObject]){
		let userCurrent = Auth.auth().currentUser
		guard let uid = userCurrent?.uid else{
			return
		}
		let ref: DatabaseReference!
		ref = Database.database().reference(fromURL: "https://kraze-935a0.firebaseio.com/")
		let usersReference = ref.child("users").child(uid)
		usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
			if err != nil{
				print(err)
				return
			}
			print("Saved user successfully into Firebase db")
		})
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
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
