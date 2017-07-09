//
//  SignUpView.swift
//  
//
//  Created by Xuan Tung Nguyen on 11/04/2017.
//
//

import Foundation
import FacebookLogin

func viewDidLoad() {
    let loginButton = LoginButton(readPermissions: [ .publicProfile ])
    loginButton.center = SignUpView.center
    
    view.addSubview(loginButton)
}
