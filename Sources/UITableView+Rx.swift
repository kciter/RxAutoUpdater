
import Foundation
import RxSwift

extension UITableView {
    private struct AssociatedKeys {
        static var StoredDataSource = "rx_storedDataSource"
    }
    
    var rx_storedDataSource: UITableViewDataSource? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.StoredDataSource) as? UITableViewDataSource
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.StoredDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public struct RxTableViewAnimationType {
    var insertAnimation: UITableViewRowAnimation
    var deleteAnimation: UITableViewRowAnimation
    var reloadAnimation: UITableViewRowAnimation
    
    init(insertAnimation: UITableViewRowAnimation = .Automatic,
         deleteAnimation: UITableViewRowAnimation = .Automatic,
         reloadAnimation: UITableViewRowAnimation = .Automatic) {
        self.insertAnimation = insertAnimation
        self.deleteAnimation = deleteAnimation
        self.reloadAnimation = reloadAnimation
    }
}

public extension UITableView {
    
    public func rx_autoUpdate<Element, Cell: UITableViewCell>
                                      (items: TableItem<Element>,
                                       animationTypes: RxTableViewAnimationType = RxTableViewAnimationType(),
                                       identifier: String,
                                       type: Cell.Type = Cell.self,
                                       configureCell: ((Int, Cell, Element) -> Void)) -> Disposable {
        self.rx_storedDataSource = RxTableViewSingleSectionDataSource<Element, Cell>(
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
                        switch changeEvent.0 {
                        case .Insert:
                            self.insertRowsAtIndexPaths(changeEvent.1, withRowAnimation: animationTypes.insertAnimation)
                        case .Remove:
                            self.deleteRowsAtIndexPaths(changeEvent.1, withRowAnimation: animationTypes.deleteAnimation)
                        case .Update:
                            self.reloadRowsAtIndexPaths(changeEvent.1, withRowAnimation: animationTypes.reloadAnimation)
                        }
                    }
    }
}