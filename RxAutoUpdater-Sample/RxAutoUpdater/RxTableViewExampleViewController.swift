//
//  RxTableViewExampleViewController.swift
//  Parking
//
//  Created by LeeSunhyoup on 2016. 5. 24..
//  Copyright © 2016년 Lee Sun-Hyoup. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxTableViewExampleViewController: UIViewController {
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var items = TableItem<String>(["Lee Sun-Hyoup", "kciter", "RxSwift", "Reactive"])

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToRx()
    }
    
    func bindToRx() {
        let animationTypes = RxTableViewAnimationType(insertAnimation: .Left, deleteAnimation: .Right, reloadAnimation: .None)
        tableView.rx_autoUpdate(items, animationTypes: animationTypes, identifier: "Cell") { index, cell, item in
            cell.textLabel?.text = item
        }.addDisposableTo(disposeBag)
        
        addButton.rx_tap
            .subscribeNext {
                self.items.append("E")
            }.addDisposableTo(disposeBag)
        
        removeButton.rx_tap
            .subscribeNext {
                self.items.removeLast()
            }.addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .subscribeNext { indexPath in
                self.items[indexPath.row] = "Changed!"
            }.addDisposableTo(disposeBag)
    }
}
