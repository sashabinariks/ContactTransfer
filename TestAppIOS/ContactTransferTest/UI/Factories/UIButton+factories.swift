//
//  UIButton+factories.swift
//  NextDoorChef
//
//  Created by Nazar Herych on 15.04.2020.
//  Copyright © 2020 NextDoorChef. All rights reserved.
//

import UIKit

extension UIButton {
    class func make(withIcon icon: UIImage?) -> UIButton {
        let button = UIButton()
        button.setImage(icon, for: .normal)
        return button
    }
    
    class func make(title: String?, tintColor: UIColor = .black) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(tintColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        return button
    }
    
    class func makeBordered(withTintColor color: UIColor, title: String) -> UIButton {
        let button = make(title: title)
        button.setTitleColor(color, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1
        return button
    }
}

