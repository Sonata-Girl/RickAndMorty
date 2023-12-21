//
//  extension+UIView.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 20.12.2023.
//

import UIKit

extension UIView {
    func addShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds.insetBy(dx: -1, dy: -1),
            cornerRadius: 6
        ).cgPath
    }
}
