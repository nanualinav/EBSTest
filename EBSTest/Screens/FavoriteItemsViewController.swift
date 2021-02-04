//
//  FavoriteItemsViewController.swift
//  EBSTest
//
//  Created by Alina Nanu on 19.01.2021.
//

import UIKit
import RealmSwift

class FavoriteItemsViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // properties
    var isFavItem = true
    let kCellIdentifier = "ItemTableViewCell"
    let realm = try! Realm()
    lazy var favItems: Results<ProductItem> = { self.realm.objects(ProductItem.self) }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customize()
    }
    
    func customize() {
        self.title = "Produse Favorite"
        
        self.tableView.register(UINib(nibName: self.kCellIdentifier, bundle: nil), forCellReuseIdentifier: self.kCellIdentifier)
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavourites), name: Notification.Name(NotificationKey.productListsShouldRefresh), object: nil)
    }
    
    @objc func updateFavourites() {
        self.favItems = realm.objects(ProductItem.self)
        self.tableView.reloadData()
    }
}

extension FavoriteItemsViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.kCellIdentifier, for: indexPath) as! ItemTableViewCell
        
        cell.favItem = self.favItems[indexPath.row]
        cell.customeDelegate = self
        cell.isFavourite = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ItemDetailsViewController()
        vc.isFavItem = true
        vc.favItem = self.favItems[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteItemsViewController: ItemCellDelegate {
    func didSelectFavourite(forItem: Item?, cell: ItemTableViewCell) {
        
    }
    
    func didSelectRemoveFromFavourites(item: ProductItem?, cell: ItemTableViewCell) {
        if let i = item {
            try! self.realm.write {
                realm.delete(i)
                
                self.tableView.reloadData()
            }
        }
    }
}


