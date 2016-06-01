
import Foundation
import RxSwift

extension UICollectionView {
    private struct AssociatedKeys {
        static var StoredDataSource = "rx_storedDataSource"
    }
    
    var rx_storedDataSource: UICollectionViewDataSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.StoredDataSource) as? UICollectionViewDataSource
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.StoredDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UICollectionView {
    
    public func rx_autoUpdate<Element, Cell: UICollectionViewCell>
                             (items: CollectionItem<Element>,
                              identifier: String,
                              type: Cell.Type = Cell.self,
                              configureCell: ((Int, Cell, Element) -> Void)) -> Disposable {
        self.rx_storedDataSource = RxCollectionViewSingleSectionDataSource<Element, Cell>(
            items: items,
            identifier: identifier,
            configureCell: configureCell
        )
        self.dataSource = self.rx_storedDataSource
        
        return items.rx_changeEvent
                    .map { changeEvent in
                        return (changeEvent.type, changeEvent.indexes.map { NSIndexPath(forRow: $0, inSection: 0) })
                    }
                    .observeOn(MainScheduler.instance)
                    .subscribeNext { changeEvent in
                        self.performBatchUpdates({ 
                            switch changeEvent.0 {
                            case .Insert:
                                self.insertItemsAtIndexPaths(changeEvent.1)
                            case .Remove:
                                self.deleteItemsAtIndexPaths(changeEvent.1)
                            case .Update:
                                self.reloadItemsAtIndexPaths(changeEvent.1)
                            }
                        }, completion: nil)
                    }
    }
}