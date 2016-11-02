//
//  Utilities.swift
//  FlashCardTakeTwo
//
//  Created by Mark Cohen on 5/30/16.
//  Copyright © 2016 Mark Cohen. All rights reserved.
//

import UIKit

class Utilities
{
    class func enableButton(button: UIButton, enable: Bool)
    {
        button.enabled = enable
        buttonBorder(button)
    }
    
    class func buttonBorder(button: UIButton)
    {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = button.currentTitleColor.CGColor
    }
}
