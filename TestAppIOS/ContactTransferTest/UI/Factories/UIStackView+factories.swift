//
//  UIStackView+factories.swift
//  NextDoorChef
//
//  Created by Nazar Herych on 14.04.2020.
//  Copyright © 2020 NextDoorChef. All rights reserved.
//

import UIKit

extension UIStackView {
    class func makeStack(axis: NSLayoutConstraint.Axis = .horizontal, arrangedSubviews: [UIView] = []) -> UIStackView {
        let view = UIStackView(arrangedSubviews: arrangedSubviews)
        view.axis = axis
        return view
    }
    
    @discardableResult
    func setDistribution(_ distribution: Distribution) -> UIStackView {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    func setAlignment(_ alignment: Alignment) -> UIStackView {
        self.alignment = alignment
        return self
    }
}
