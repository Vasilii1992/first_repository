//
//  ViewController + Extentions.swift
//  Restaurant
//
//  Created by Василий Тихонов on 08.06.2024.
//

import UIKit

extension MainView {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            loaderAnimationView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            loaderAnimationView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 160),
            loaderAnimationView.widthAnchor.constraint(equalToConstant: 150),
            loaderAnimationView.heightAnchor.constraint(equalToConstant: 300)
                   
        ])
    }
    
     func createLayoutSection(group: NSCollectionLayoutGroup,
                                       behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                                       interGroupSpacing: CGFloat,
                                       supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
                                       contentInsetsReference: UIContentInsetsReference) -> NSCollectionLayoutSection {
          let section = NSCollectionLayoutSection(group: group)
          section.orthogonalScrollingBehavior = behavior
          section.interGroupSpacing = interGroupSpacing
          section.boundarySupplementaryItems = supplementaryItems
          section.supplementaryContentInsetsReference = contentInsetsReference
          return section
      }
      
      
       func createSaleSection() -> NSCollectionLayoutSection {
          
          let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1)))
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.15),
                                                                       heightDimension: .fractionalHeight(0.33)),
                                                                       subitems: [item])
          
          let section = createLayoutSection(group: group,
                                            behavior: .groupPaging,
                                            interGroupSpacing: 5,
                                            supplementaryItems: [],
                                            contentInsetsReference: .automatic)
              section.contentInsets = .init(top: -60, leading: 0, bottom: -10, trailing: 0)
          return section
      }
      
       func createCategorySection() -> NSCollectionLayoutSection {
          
      let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25),
                                                          heightDimension: .fractionalHeight(1)))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .fractionalHeight(0.1)),
                                                                       subitems: [item])
          group.interItemSpacing = .flexible(10)
          
          let section = createLayoutSection(group: group,
                                            behavior: .none,
                                            interGroupSpacing: 10,
                                            supplementaryItems: [suplementaryHeaderItem()],
                                            contentInsetsReference: .automatic)
              section.contentInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
          
          return section
      }
      
       func createFoodForCategorySection() -> NSCollectionLayoutSection {
          
          let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                              heightDimension: .fractionalHeight(1)))
          let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.75),
                                                                       heightDimension: .fractionalHeight(0.35)),
                                                                       subitems: [item])
          
          let section = createLayoutSection(group: group,
                                            behavior: .continuous,
                                            interGroupSpacing: 10,
                                            supplementaryItems: [suplementaryHeaderItem()],
                                            contentInsetsReference: .automatic)
              section.contentInsets = .init(top: -100, leading: 10, bottom: 0, trailing: 0)
          
          return section
  }
      
       func suplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
          .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                  heightDimension: .estimated(28)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
      }
}
