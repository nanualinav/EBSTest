//
//  ItemTableViewCell.swift
//  EBSTest
//
//  Created by Alina Nanu on 18.01.2021.
//

import UIKit
import Kingfisher
import RealmSwift

protocol ItemCellDelegate {
    func didSelectFavourite(forItem: Item?, cell: ItemTableViewCell)
    func didSelectRemoveFromFavourites(item: ProductItem?, cell: ItemTableViewCell)
}

class ItemTableViewCell: UITableViewCell {
    
    // outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // properties
    var customeDelegate: ItemCellDelegate?
    var isFavourite = false {
        didSet {
            self.favouriteButton.isSelected = self.isFavourite == true
        }
    }
    
    var item: Item? {
        didSet {
            self.productImageView.kf.setImage(with: URL(string: self.item?.image ?? ""))
            self.nameLabel.text = self.item?.title
            self.descriptionLabel.text = self.item?.description
            if let p = self.item?.price, let sale = self.item?.salePercent {
                let salePrice = p - (p * (sale / 100))
                
                self.priceLabel.text = self.item?.salePercent != 0 ? "$ \(salePrice.clean)" : "$ \(p.clean),-"
                
                if self.item?.salePercent != 0 {
                    self.discountLabel.attributedText = "$ \(p.clean),-".strikeThrough()
                }
                else {
                    self.discountLabel.text = ""
                }
            }
        }
    }
    
    var favItem: ProductItem? {
        didSet {
            self.productImageView.kf.setImage(with: URL(string: self.favItem?.image ?? ""))
            self.nameLabel.text = self.favItem?.title
            self.descriptionLabel.text = self.favItem?.desc
            if let p = self.favItem?.price, let sale = self.favItem?.salePercent {
                let salePrice = p - (p * (sale / 100))
                
                self.priceLabel.text = self.favItem?.salePercent != 0 ? "$ \(salePrice.clean)" : "$ \(p.clean),-"
                
                if self.favItem?.salePercent != 0 {
                    self.discountLabel.attributedText = "$ \(p.clean),-".strikeThrough()
                }
                else {
                    self.discountLabel.text = ""
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Actions
    @IBAction func onFavourite(_ sender: Any) {
        self.favouriteButton.isSelected = !self.favouriteButton.isSelected
        
        if let fav = self.favItem {
            self.customeDelegate?.didSelectRemoveFromFavourites(item: fav, cell: self)
        }
            
        if let i = self.item {
            self.customeDelegate?.didSelectFavourite(forItem: i, cell: self)
        }
    }
}
