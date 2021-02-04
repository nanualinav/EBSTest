//
//  ItemDetailsViewController.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import UIKit
import SVProgressHUD

class ItemDetailsViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    // properties
    var item: Item?
    var favItem: ProductItem?
    var isFavItem = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customize()
        self.getItemDetails()
    }
    
    func customize() {
        self.title = self.isFavItem ? self.favItem?.title : self.item?.title
    }
    
    func refreshUI() {
        self.itemImageView.kf.setImage(with: URL(string: self.isFavItem ? self.favItem?.image ?? "" : self.item?.image ?? ""))
        self.nameLabel.text = self.isFavItem ? self.favItem?.title : self.item?.title
        self.descriptionLabel.text = self.isFavItem ? self.favItem?.desc : self.item?.description
        self.detailsLabel.text = self.isFavItem ? self.favItem?.details : self.item?.details
        if let p = self.isFavItem ? self.favItem?.price : self.item?.price, let sale = self.isFavItem ? self.favItem?.salePercent : self.item?.salePercent {
            let salePrice = p - (p * (sale / 100))
            
            self.priceLabel.text = self.isFavItem ? (self.favItem?.salePercent != 0 ? "$ \(salePrice.clean)" : "$ \(p.clean),-") : (self.item?.salePercent != 0 ? "$ \(salePrice.clean)" : "$ \(p.clean),-")
            
            if self.isFavItem ? self.item?.salePercent != 0 : self.favItem?.salePercent != 0 {
                self.discountPriceLabel.attributedText = "$ \(p.clean),-".strikeThrough()
            }
            else {
                self.discountPriceLabel.text = ""
            }
        }
    }
    
    // MARK: - Server
    
    func getItemDetails() {
        SVProgressHUD.show()
        
        if let id = self.isFavItem ? self.favItem?.ID : self.item?.ID {
            RequestHandler.getDetails(for: id) { (response) in
                SVProgressHUD.dismiss()
                self.refreshUI()
                
            } fail: { (error) in
                SVProgressHUD.dismiss()
                self.show(message: error.message, title: "Error")
            }
        }
    }
}
