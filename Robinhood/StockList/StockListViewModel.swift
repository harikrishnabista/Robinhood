//
//  StockPriceViewModel.swift
//  AsyncMessaginng
//
//  Created by Hari Bista on 9/23/21.
//  Copyright © 2021 Hari Bista. All rights reserved.
//

import Foundation

struct Stock {
    let ticker: String
    let price: Double
    let dayHigh: Double
    let dayLow: Double
}

struct DummyDecodable: Decodable {
    
}

protocol StockUpdatable: class {
    func updated(stocks: [Stock])
}

class StockListViewModel {
    private let availableStocks = ["ABCD", "EFGH", "IJKL", "MNOP", "QRST", "UVWX"]
    var stockList:[Stock] = []
    private weak var delegate: StockUpdatable?
    
    func fetchStockList(delegate: StockUpdatable){
        self.delegate = delegate
        FetchStockPriceDataManager.shared.setFetchingStrategy(newStrategy: .TIME_INTERVAL)
        FetchStockPriceDataManager.shared.updateActiveFetchTickers(tickers: availableStocks,
                                                                   delegate: self)
    }
    
    func stopFetch(){
        FetchStockPriceDataManager.shared.stopFetch()
    }
}

extension StockListViewModel : StockUpdatable {
    func updated(stocks: [Stock]) {
        self.stockList = stocks
        self.delegate?.updated(stocks: stocks)
    }
}
