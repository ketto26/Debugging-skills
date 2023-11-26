//
//  NetworkManager.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import Foundation
import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Fetch Movies
    func fetchProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        let urlStr = "https://dummyjson.com/products"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                print(error.localizedDescription)
                print("Error here")
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let productsResponse = try JSONDecoder().decode(ProductResponseModel.self, from: data)
                DispatchQueue.main.async{
                completion(.success(productsResponse.products))
                }
            } catch {
                print("Decoding failed with error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Download Image
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard 
                let data = data,
                error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.global().async {
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
}
