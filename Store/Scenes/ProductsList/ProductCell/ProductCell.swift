//
//  ProductCell.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func removeProduct(for cell: ProductCell)
    func addProduct(for cell: ProductCell)
}

class ProductCell: UITableViewCell {

    @IBOutlet weak var prodImageView: UIImageView!
    @IBOutlet weak var prodTitleLbl: UILabel!
    @IBOutlet weak var stockLbl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var selectedQuantityLbl: UILabel!
    @IBOutlet weak var quantityModifierView: UIView!
    
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
    }
    
    func setupUI(){
        quantityModifierView.layer.cornerRadius = 5
        quantityModifierView.layer.borderWidth = 1
        quantityModifierView.layer.borderColor = UIColor.lightGray.cgColor
        
        prodImageView.clipsToBounds = true
        prodImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        prodImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        prodImageView.contentMode = .scaleAspectFill
    }
    
    func reload(with product: ProductModel) {
        
        NetworkManager.shared.downloadImage(from: product.thumbnail) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView?.image = image
            }
        }
        prodTitleLbl.text = product.title
        stockLbl.text = "\(product.stock)"
        descrLbl.text = "\(product.description)"
        priceLbl.text = "\(product.price)$"
        selectedQuantityLbl.text = "\(product.selectedAmount ?? 0)"
    }
    
    private func setImage(from url: String) {
        
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.prodImageView.image = image
            }
        }
    }
    
    @IBAction func addProduct(_ sender: Any) {
        delegate?.addProduct(for: self)
    }
    
    @IBAction func removeProduct(_ sender: Any) {
        delegate?.removeProduct(for: self)
    }
}
