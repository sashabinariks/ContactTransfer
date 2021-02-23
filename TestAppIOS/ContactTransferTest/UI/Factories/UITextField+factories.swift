//
//  UITextField+factories.swift
//  NextDoorChef
//
//  Created by Nazar Herych on 16.04.2020.
//  Copyright © 2020 NextDoorChef. All rights reserved.
//

import UIKit

extension UITextField {
    class func make() -> Self {
        let view = self.init()
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        view.leftViewMode = .always
        view.rightViewMode = .always
        
        view.layer.setCornerRadius(width: 8)
        view.layer.setBorder(width: 1, color: .black)
        
        return view
    }
    
    class func makeRegulardWith(fontSize: CGFloat = 16, placeholder: String? = nil) -> Self {
        let view = self.make()
        
        view.font = UIFont(name: "Avenir", size: fontSize)
        view.placeholder = placeholder
        view.backgroundColor = .white
        view.textColor = .black
        
        return view
    }
    
    class func makeMediumdWith(fontSize: CGFloat = 16, placeholder: String? = nil) -> Self {
        let view = self.make()
        
        view.font = UIFont(name: "Avenir-Medium", size: fontSize)
        view.placeholder = placeholder
        view.backgroundColor = .white
        view.textColor = .black
        
        return view
    }
    
    class func makeHeavyWith(fontSize: CGFloat = 16, placeholder: String? = nil) -> Self {
        let view = self.make()
        
        view.font = UIFont(name: "Avenir-Heavy", size: fontSize)
        view.placeholder = placeholder
        view.backgroundColor = .white
        view.textColor = .black
        
        return view
    }
}
