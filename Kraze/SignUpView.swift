//
//  SignUpView.swift
//  Pods
//
//  Created by Xuan Tung Nguyen on 11/04/2017.
//
//

import Foundation
import FacebookLogin

func viewDidLoad() {
    let loginButton = LoginButton(readPermissions: [ .PublicProfile ])
    loginButton.center = view.center
    
    view.addSubview(loginButton)
}
