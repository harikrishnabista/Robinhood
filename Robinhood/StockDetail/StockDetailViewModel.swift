//
//  StockDetailViewModel.swift
//  AsyncMessaginng
//
//  Created by Hari Bista on 9/24/21.
//  Copyright © 2021 Hari Bista. All rights reserved.
//

import UIKit

class StockDetailViewModel {
    var stock: Stock?
    
    private weak var delegate: StockUpdatable?
    
    func fetchStock(delegate: StockUpdatable){
        self.delegate = delegate
        
        if let stock = self.stock {
            FetchStockPriceDataManager.shared.updateActiveFetchTickers(tickers: [stock.ticker],
                                                                       delegate: self)
        }
        
    }
    
    func stopFetch(){
        FetchStockPriceDataManager.shared.stopFetch()
    }
    
}

extension StockDetailViewModel : StockUpdatable {
    func updated(stocks: [Stock]) {
        self.stock = stocks.first
        self.delegate?.updated(stocks: stocks)
    }
}
