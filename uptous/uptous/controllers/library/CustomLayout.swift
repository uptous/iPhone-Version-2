//
//  Created by Pete Callaway on 08/01/2015.
//  Copyright (c) 2015 Dative Studios. All rights reserved.
//

import UIKit


class CustomLayout: UICollectionViewFlowLayout {
    
    var numberOfItemsPerRow: Int = 3 {
        didSet {
            invalidateLayout()
        }
    }
    
    override func prepare() {
        super.prepare()
        
        if let collectionView = self.collectionView {
            var newItemSize = itemSize

            // Always use an item count of at least 1 and convert it to a float to use in size calculations
           /* if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 480:
                    print("iPhone Classic")
                    numberOfItemsPerRow = 2
                case 960:
                    numberOfItemsPerRow = 2
                case 1136:
                    numberOfItemsPerRow = 2
                case 1334:
                    print("iPhone 6 or 6S")
                    numberOfItemsPerRow = 3
                case 2208:
                    print("iPhone 6+ or 6S+")
                    numberOfItemsPerRow = 3
                default:
                    print("unknown")
                }
            }*/
            let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
            
            // Calculate the sum of the spacing between cells
            let totalSpacing = minimumInteritemSpacing * (itemsPerRow - 1.0)
            
            // Calculate how wide items should be
            /*if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 480:
                    print("iPhone Classic")
                    newItemSize.width = 100
                    if itemSize.height > 0 {
                        let itemAspectRatio = itemSize.width / itemSize.height
                        newItemSize.height = (newItemSize.width / itemAspectRatio) + 10
                    }
                case 960:
                    print("iPhone 4 or 4S")
                    newItemSize.width = 70
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    newItemSize.width = 70
                case 1334:
                    print("iPhone 6 or 6S")
                    newItemSize.width = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / itemsPerRow
                    
                case 2208:
                    print("iPhone 6+ or 6S+")
                    newItemSize.width = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / itemsPerRow
                default:
                    print("unknown")
                }
            }*/
            newItemSize.width = (collectionView.bounds.size.width - sectionInset.left - sectionInset.right - totalSpacing) / itemsPerRow
            
            // Use the aspect ratio of the current item size to determine how tall the items should be
            if itemSize.height > 0 {
                let itemAspectRatio = itemSize.width / itemSize.height
                newItemSize.height = (newItemSize.width / itemAspectRatio) + 10
            }
            
            // Set the new item size
            itemSize = newItemSize
        }
    }
}
