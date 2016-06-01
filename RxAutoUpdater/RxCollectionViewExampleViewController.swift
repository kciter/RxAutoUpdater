//
//  RxCollectionViewExampleViewController.swift
//  Parking
//
//  Created by LeeSunhyoup on 2016. 5. 18..
//  Copyright © 2016년 lee sang gyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxCollectionViewExampleViewController: UIViewController {
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    var items = CollectionItem<UIColor>([UIColor.blackColor(),
                                         UIColor.yellowColor(),
                                         UIColor.redColor(),
                                         UIColor.greenColor(),
                                         UIColor.brownColor()])
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindToRx()
    }
    
    func bindToRx() {
        collectionView.rx_autoUpdate(items, identifier: "Cell") { index, cell, item in
            cell.backgroundColor = item
        }.addDisposableTo(disposeBag)
        
        collectionView.rx_modelSelected(UIColor)
            .subscribeNext { color in
                print(color.description)
            }.addDisposableTo(disposeBag)

        collectionView
            .rx_itemSelected
            .subscribeNext { indexPath in
                self.items[indexPath.row] = UIColor(red: CGFloat(random()%255)/255.0,
                                                    green: CGFloat(random()%255)/255.0,
                                                    blue: CGFloat(random()%255)/255.0,
                                                    alpha: 1)
            }.addDisposableTo(disposeBag)
        
        addButton.rx_tap
            .subscribeNext {
                self.items.append(
                    UIColor(
                        red: CGFloat(random()%255)/255.0,
                        green: CGFloat(random()%255)/255.0,
                        blue: CGFloat(random()%255)/255.0,
                        alpha: 1
                    )
                )
            }.addDisposableTo(disposeBag)
        
        removeButton.rx_tap
            .subscribeNext {
                self.items.removeFirst()
            }.addDisposableTo(disposeBag)
    }
}
