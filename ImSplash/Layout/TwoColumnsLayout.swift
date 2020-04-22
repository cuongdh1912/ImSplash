//
//  TwoColumnsLayout.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/22/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
import Foundation
class TwoColumnsLayout: UICollectionViewLayout {
    // is used to call TwoColumnsLayoutDelegate method
    weak var delegate: TwoColumnsLayoutDelegate?
    // set number of columns
    private let numberOfColumns = 2
    // padding of cells
    private let cellPadding: CGFloat = 6
    private let loadMoreHeight: CGFloat = 44
    // attributes
    private var attributes: [UICollectionViewLayoutAttributes] = []
    // height of collectionview
    private var contentHeight: CGFloat = 0
    // width of collectionview
    private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
        return 0
    }
    let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    // get content size of collection view
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
  
    override func prepare() {
        // check attributes, & collection
        guard let collectionView = collectionView else { return }
        if !attributes.isEmpty {
            attributes.removeAll()
        }
        // width of each column
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        // width of photo
        let photoWidth = columnWidth - cellPadding * 2
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        // loop to calculate frames of all cells
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            // get ratio of photo
            let ratioHeighPerWidth = CGFloat(delegate?.getPhotoRatioHeightPerWidth(indexPath: indexPath) ?? 1)
            // get photo height from its width & ratio
            let photoHeight = photoWidth * ratioHeighPerWidth
            // height of cell's frame
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                             y: yOffset[column],
                             width: columnWidth,
                             height: height)
            // inset of frame of cell
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            // attribute of cell
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            attributes.append(attribute)

            // max of content height
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            var minY = yOffset[0]
            column = 0
            for i in 1..<numberOfColumns {
                if minY > yOffset[i] {
                    minY = yOffset[i]
                    column = i
                }
            }
        }
        // for load more section
        if collectionView.numberOfSections > 1 {
            // generate index path
            let indexPath = IndexPath(item: 0, section: 1)
            // generate frame for load more row
            let frame = CGRect(x: 0,
                             y: contentHeight,
                             width: contentWidth,
                             height: loadMoreHeight)
            // increase content height
            contentHeight += loadMoreHeight
            // inset of frame of cell
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            // attribute of cell
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            attributes.append(attribute)
        }
    }
    // get layout attribute for rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // attributes for rect
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        // Loop through the attributes and look for items in the rect
        for attribute in attributes {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    // get layout attribute for item
    //
    // -Parameter indexPath: index path of collectionview
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath.item]
    }
}
