//
//  CALayer+setCornerRadius.swift
//  ContactTransferTest
//
//  Created by Nazar Herych on 02.02.2021.
//

import UIKit

extension CALayer {
    func setCornerRadius(width: CGFloat) {
        cornerRadius = width
        masksToBounds = true
    }
}
