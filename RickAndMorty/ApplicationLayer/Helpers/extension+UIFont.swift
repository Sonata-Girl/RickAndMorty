//
//  extension+UIFont.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 22.12.2023.
//

import UIKit

extension UIFont {
    static func robotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoThin(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Thin", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func karlaLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Karla-Font", size: size) ?? .systemFont(ofSize: size)
    }
}
