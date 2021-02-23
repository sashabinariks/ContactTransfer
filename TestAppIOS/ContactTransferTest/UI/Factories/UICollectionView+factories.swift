//
//  UICollectionView+factories.swift
//  NextDoorChef
//
//  Created by Vasyl Mytko on 25.04.2020.
//  Copyright © 2020 NextDoorChef. All rights reserved.
//

import UIKit

extension UICollectionView {
    class func make(scrollDirection: UICollectionView.ScrollDirection = .vertical) -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = scrollDirection
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        
        return collectionView
    }
    
}
