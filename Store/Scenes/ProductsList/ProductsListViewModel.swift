//
//  ProductsListViewModel.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation

protocol ProductsListViewModelDelegate: AnyObject {
    func productsFetched()
    func productsAmountChanged()
    func showError(_ error: Error)
}

class ProductsListViewModel {

    weak var delegate: ProductsListViewModelDelegate?
    
    var products: [ProductModel]?
    var totalPrice: Double? { products?.reduce(0) { $0 + $1.price * Double(($1.selectedAmount ?? 0))} }
    
    func viewDidLoad() {
        fetchProducts()
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] response in
            switch response {
            case .success(let products):
                self?.products = products
                self?.delegate?.productsFetched()
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
    
    func addProduct(at index: Int) {
        var product = products?[index]
        guard let selectedAmount = product?.selectedAmount, selectedAmount < product?.stock ?? 0 else {
            print("Product \(String(describing: product?.title)) is out of stock")
                return
            }
        product?.selectedAmount = (products?[index].selectedAmount ?? 0 ) + 1
        delegate?.productsAmountChanged()
    }
    
    func removeProduct(at index: Int) {
        var product = products?[index]
        guard let selectedAmount = product?.selectedAmount, selectedAmount > 0 else {
            print("Quantity of product \(String(describing: product?.title)) is already 0")
            return
        }
        product?.selectedAmount = (products?[index].selectedAmount ?? 0 ) - 1
        delegate?.productsAmountChanged()
    }
}
