//
//  PaddingLabel.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 12.12.2023.
//
#warning("Clear")
import UIKit

// MARK: - Custom label with insets

 final class PaddingLabel: UILabel {
    
    private var insets = UIEdgeInsets()
    
    required init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)) {
        super.init(frame: CGRect.zero)
        self.insets = insets
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}
