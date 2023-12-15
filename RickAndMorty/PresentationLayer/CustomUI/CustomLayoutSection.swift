//
//  File.swift
//  RickAndMorty
//
//  Created by Sonata Girl on 13.12.2023.
//

import UIKit

// MARK: - Custom Layout section create method

final class CustomLayoutSection {
    static let shared = CustomLayoutSection()
    
    // MARK: Init
    
    private init() {}
   
    func create() -> NSCollectionLayoutSection {
       let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let insetSize: CGFloat = 10
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
            heightDimension: .absolute(420)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.supplementaryContentInsetsReference = .safeArea
        layoutSection.contentInsets = contentInsets
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
