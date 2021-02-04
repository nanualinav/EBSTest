//
//  ItemsViewController.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import UIKit
import SVProgressHUD
import RealmSwift

class ItemsViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // properties
    let kCellIdentifier = "ItemTableViewCell"
    var items: [Item]?
    var favItems: Results<ProductItem>?
    var realm: Realm = try! Realm()
    
    var existsMoreRecords = true
    var isFetching = false
    var page = 0
    var limit = 10
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customize()
        self.getItems(offset: self.offset, limit: self.limit)
    }
    
    func customize() {
        self.tableView.register(UINib(nibName: self.kCellIdentifier, bundle: nil), forCellReuseIdentifier: self.kCellIdentifier)
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        
        self.title = "Produse"
        
        let barButton = UIBarButtonItem(image: UIImage(named: "wishlist_empty"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(showFavourites))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func showFavourites() {
        let vc = FavoriteItemsViewController()
        vc.isFavItem = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Server
    
    func getItems(offset: Int, limit: Int) {
        SVProgressHUD.show()
        
        RequestHandler.getItems(with: offset, limit: limit, success: { (items) in
            self.existsMoreRecords = items.count == self.limit
            
            if self.page == 0 {
                self.items = items
            } else {
                self.items?.append(contentsOf: items)
            }
            
            SVProgressHUD.dismiss()
            self.isFetching = false
            self.tableView.reloadData()
            
        }, fail: { (error) in
            SVProgressHUD.dismiss()
            self.isFetching = false
            self.show(message: error.message, title: "Error")
        })
    }
}

extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.kCellIdentifier, for: indexPath) as! ItemTableViewCell
        cell.item = self.items?[indexPath.row]
        cell.isFavourite = false
        
        cell.customeDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ItemDetailsViewController()
        vc.item = self.items?[indexPath.row]
        vc.isFavItem = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isFetching = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
            
            if self.isFetching == false, self.existsMoreRecords == true {
                self.page += 1
                self.offset = self.limit * self.page
                self.getItems(offset: self.offset, limit: self.limit)
            }
        }
    }
}

extension ItemsViewController: ItemCellDelegate {
    
    func didSelectRemoveFromFavourites(item: ProductItem?, cell: ItemTableViewCell) {
        
    }
    
    
    func didSelectFavourite(forItem: Item?, cell: ItemTableViewCell) {
        
        let productItem = ProductItem()
        productItem.ID = forItem?.ID ?? 0
        productItem.title = forItem?.title ?? ""
        productItem.desc = forItem?.description ?? ""
        productItem.image = forItem?.image ?? ""
        productItem.price = forItem?.price ?? 0.0
        productItem.salePercent = forItem?.salePercent ?? 0.0
        productItem.details = forItem?.details ?? ""
        
        try! realm.write {
            realm.add(productItem)
                        
            cell.isFavourite = true
            
            NotificationCenter.default.post(name: Notification.Name(NotificationKey.productListsShouldRefresh), object: nil)
        }
        self.tableView.reloadData()
    }
}

