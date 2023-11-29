//
//  WebService.swift
//  CryptoRxMVVM
//
//  Created by Ramazan Burak Ekinci on 29.11.2023.
//  Service MVVM template

import Foundation

//Error Type
enum CryptoError : Error {
    case serviceError
    case parsingError
}

class WebService {
    func downloadCurrency(url: URL, completion: @escaping (Result<[Crypto],CryptoError>) -> () ){
        URLSession.shared.dataTask(with: url) { data, responce, error in
            if let _ = error {
                // server error
                completion(.failure(.serviceError))
            }else if let data = data{
                // get data
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
                if let cryptoList = cryptoList {
                    completion(.success(cryptoList))
                }
            }else {
                // get data , i am not parsing
                completion(.failure(.parsingError))
            }
        }.resume()
    }
}
