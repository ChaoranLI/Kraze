//
//  CheckBox.swift
//  Kraze
//
//  Created by Xuan Tung Nguyen on 13/04/2017.
//  Copyright © 2017 Xuan Tung Nguyen. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    // images 
    let checkedImage = UIImage(named:"checked_checkbox")! as UIImage
    let unCheckedImage = UIImage(named: "checkbox")! as UIImage
    
    //bool property 
    
    var isChecked:Bool = false{
        didSet{
            if isChecked == true{
            self.setImage(checkedImage, for: .normal)
            }
            else{
                self.setImage(unCheckedImage, for: .normal)
            }
    }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: Selector(("buttonClicked")), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    func buttonClicked(sender:UIButton){
        if(sender == self){
            if isChecked == true{
                isChecked = false
                }
            else{
                isChecked = true
}
}
}
}
