//
//  File.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

struct SectionSettings {
    let columnAmount: Double
    let isGroup: Bool
    let horizontalScroll: Bool
    
    init(columnAmount: Double = 4,
         horizontalScroll: Bool = false,
         isGroup: Bool = true
    ) {
        self.columnAmount = columnAmount
        self.horizontalScroll = horizontalScroll
        self.isGroup = isGroup
    }
}

// MARK: - Custom Layout section create method

final class CustomLayoutSection {
    static let shared = CustomLayoutSection()
    
    // MARK: Init
    
    private init() {}
   
    func create(with settings: SectionSettings) -> NSCollectionLayoutSection {
       let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / settings.columnAmount),
            heightDimension: .fractionalHeight(1)
        )
        let insetSize: CGFloat = settings.isGroup ? 5 : 2
        let contentInsets = NSDirectionalEdgeInsets.init(
            top: insetSize,
            leading: insetSize,
            bottom: insetSize,
            trailing: insetSize
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = contentInsets
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1 / settings.columnAmount)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.supplementaryContentInsetsReference = .safeArea
        layoutSection.contentInsets = contentInsets
        if settings.horizontalScroll { layoutSection.orthogonalScrollingBehavior = .continuous }
        if settings.isGroup { layoutSection.boundarySupplementaryItems = [headerItem()] }
        return layoutSection
    }
    
    // MARK: Header
    
    private func headerItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(25)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
    }
}
