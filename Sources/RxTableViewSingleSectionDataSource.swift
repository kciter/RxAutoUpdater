
import Foundation
import UIKit

public class RxTableViewSingleSectionDataSource<Element, Cell: UITableViewCell>: RxTableViewDataSource {
    
    public typealias E = Element
    public typealias CellFactory = (Int, Cell, Element) -> Void
    
    public var items: TableItem<E>
    public var identifier: String
    public var configureCell: CellFactory
    
    public init(items: TableItem<E>, identifier: String, configureCell: CellFactory) {
        self.items = items
        self.identifier = identifier
        self.configureCell = configureCell
        super.init()
    }
    
    override func _rx_tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func _rx_tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: Cell? = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell
        cell = cell ?? Cell()
        configureCell(indexPath.row, cell!, items[indexPath.row])
        return cell!
    }
}