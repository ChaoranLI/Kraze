//
//  MapMarker.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 01/06/2017.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol MapMarker: AnyObject
{
    var markerCoordinate: CLLocationCoordinate2D { get set }
    var markerTitle: String { get set }
    var markerColour: UIColor { get set }
    var markerClusterTitle: String { get set }
    var markerClusterColour: UIColor { get set }
    var markerClusterCount: Int { get set }
    
    var markerHashValue: Int { get }
    func isEqualToMarker(_ v: MapMarker) -> Bool
}
