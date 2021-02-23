//
//  UIlabel+factories.swift
//  NextDoorChef
//
//  Created by Nazar Herych on 14.04.2020.
//  Copyright © 2020 NextDoorChef. All rights reserved.
//

import UIKit

extension UILabel {
    private class func makeCommon() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }
    
    class func makeHeader(withSize size: CGFloat = 30) -> UILabel {
        let label: UILabel = .makeCommon()
        label.font = UIFont(name: "Avenir-Heavy", size: size)
        return label
    }
    
    class func makeSubheader(withSize size: CGFloat = 18) -> UILabel {
        let label: UILabel = .makeCommon()
        label.font = UIFont(name: "Avenir-Medium", size: size)
        return label
    }
    
    class func makeRegular(withSize size: CGFloat = 16) -> UILabel {
        let label: UILabel = .makeCommon()
        label.font = UIFont(name: "Avenir", size: size)
        return label
    }
    
    class func make(withFont font: UIFont?) -> UILabel {
        let label: UILabel = .makeCommon()
        label.font = font
        return label
    }
}
