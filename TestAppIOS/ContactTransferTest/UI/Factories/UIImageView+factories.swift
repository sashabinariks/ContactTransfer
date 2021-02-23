//
//  UIImageView+factories.swift
//  NextDoorChef
//
//  Created by Nazar Herych on 21.04.2020.
//  Copyright © 2020 NextDoorChef. All rights reserved.
//

import UIKit

extension UIImageView {
    class func make(with contentMode: UIView.ContentMode = .scaleAspectFit) -> Self {
        let imageView = self.init()
        imageView.contentMode = contentMode
        return imageView
    }
}
