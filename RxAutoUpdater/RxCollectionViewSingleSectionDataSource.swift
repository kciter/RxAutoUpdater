
import Foundation
import UIKit

public class RxCollectionViewSingleSectionDataSource<Element, Cell: UICollectionViewCell>: RxCollectionViewDataSource {
    
    public typealias E = Element
    public typealias CellFactory = (Int, Cell, Element) -> Void
    
    public var items: CollectionItem<E>
    public var identifier: String
    public var configureCell: CellFactory
    
    public init(items: CollectionItem<E>, identifier: String, configureCell: CellFactory) {
        self.items = items
        self.identifier = identifier
        self.configureCell = configureCell
        super.init()
    }
    
    override func _numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func _rx_collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func _rx_collectionView(collectionView: UICollectionView,
                                     cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! Cell
        configureCell(indexPath.row, cell, items[indexPath.row])
        return cell
    }
}