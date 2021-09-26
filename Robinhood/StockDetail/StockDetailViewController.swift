//
//  StockDetailViewController.swift
//  AsyncMessaginng
//
//  Created by Hari Bista on 9/24/21.
//  Copyright © 2021 Hari Bista. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    var viewModel: StockDetailViewModel = StockDetailViewModel()
    
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var daysLowPriceLabel: UILabel!
    @IBOutlet weak var daysHighPriceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayStockDetails()
        self.viewModel.fetchStock(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func displayStockDetails(){
        if let stock = self.viewModel.stock {
            self.tickerLabel.text = stock.ticker
            self.priceLabel.text = "$ \(stock.price)"
            self.daysLowPriceLabel.text = "Days Low: $ \(stock.dayLow)"
            self.daysHighPriceLabel.text = "Days High: $ \(stock.dayHigh)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.stopFetch()
    }

}

extension StockDetailViewController: StockUpdatable {
    func updated(stocks: [Stock]) {
        DispatchQueue.main.async {
            self.displayStockDetails()
        }
    }
}
