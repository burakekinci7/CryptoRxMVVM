//
//  ViewController.swift
//  CryptoRxMVVM
//
//  Created by Ramazan Burak Ekinci on 29.11.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatiorView: UIActivityIndicatorView!
    
    let cryptoVM = CryptoViewModel()
    var cryptoList = [Crypto]()
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // table view initializer
        tableView.dataSource = self
        tableView.delegate = self
        
        //call functions
        setupBinding()
        cryptoVM.requestData()
    }
    
    private func setupBinding(){
        //Used to RX
        //Always use the dispose! memrory
        
        //loading binding
        cryptoVM
            .loading
            .bind(to: self.indicatiorView.rx.isAnimating)
            .disposed(by: dispose)
            
        
        //eroor subscirbe in ViewModel
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe{ errorString in
                print(errorString)
            }.disposed(by: dispose)
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                self.cryptoList = cryptos
                self.tableView.reloadData()
            }.disposed(by: dispose)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //table View how to product
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
    


}

