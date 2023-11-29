//
//  CryptoViewModel.swift
//  CryptoRxMVVM
//
//  Created by Ramazan Burak Ekinci on 29.11.2023.
//  ViewModel in MVVM

import Foundation
import RxSwift
import RxCocoa

class CryptoViewModel {
    let cryptos : PublishSubject<[Crypto]> = PublishSubject()
    let error : PublishSubject<String> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    func requestData (){
        //indicaitor start is loading
        self.loading.onNext(true)
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!
        WebService().downloadCurrency(url: url) { result in
            //indicatior stop
            self.loading.onNext(false)
            switch result{
            case .success(let cryptos):
                //is succes
                self.cryptos.onNext(cryptos)
            case.failure(let error):
                //is failure 2
                switch error {
                case .parsingError:
                    // 1 - pars failure
                    self.error.onNext("Parsing Errpor")
                case .serviceError:
                    // 2 - Server failure
                    self.error.onNext("Server Eroor")
                }
            }
        }
    }
}
