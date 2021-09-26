//
//  TImerCollection.swift
//  AsyncMessaginng
//
//  Created by Hari Bista on 9/23/21.
//  Copyright © 2021 Hari Bista. All rights reserved.
//

import Foundation

class FetchStockPriceDataManager {
    enum FetchingStratery {
        case TIME_INTERVAL, RECURSIVE, NONE
    }
    
    let timeInterval: UInt32 = 2
    
    /* temporary helper properties and methods */
    private let url = URL(string: "https://raw.githubusercontent.com/harikrishnabista/SimpleApiCaller/master/QuestionsList.json")!

    private func getRandomPrice() -> Int {
        return Int.random(in: 100...500)
    }
    
    private func getDummyListOfStocks() -> [Stock] {
        var result:[Stock] = []
        for ticker in activeFetchTickers {
            let stock = Stock(ticker: ticker,
                              price: Double(self.getRandomPrice()),
                              dayHigh: 100,
                              dayLow: 50)
            result.append(stock)
        }
        return result
    }

    // real useful properties and methods
    public static let shared = FetchStockPriceDataManager()
    private weak var delegate: StockUpdatable?
    private var activeFetchTickers: [String] = []
    private var dataTask: URLSessionDataTask?
    
    var fetchingStrategy = FetchingStratery.NONE
    
    func setFetchingStrategy(newStrategy: FetchingStratery){
        self.fetchingStrategy = newStrategy
    }
    
    private func fetchWithRecursion() {
        // when we make real api we need to pass list of tickers to server
        print("Fetching result for: \(self.activeFetchTickers)")
        print("")
        
        self.dataTask = ApiCaller<DummyDecodable>().callApi(url: self.url) { result in
            switch result {
            case .success( _):
                self.delegate?.updated(stocks: self.getDummyListOfStocks())
            case .failure( _):
                self.delegate?.updated(stocks: self.getDummyListOfStocks())
            }
            
            if self.fetchingStrategy == .RECURSIVE {
                self.fetchWithRecursion()
                sleep(self.timeInterval)
            }
        }
    }
    
    var timer: Timer?
    private func fetchWithTimer(){
        // when we make real api we need to pass list of tickers to server
        print("Fetching result for: \(self.activeFetchTickers)")
        print("")
        
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.timeInterval), repeats: true) { (timer) in
            self.dataTask = ApiCaller<DummyDecodable>().callApi(url: self.url) { result in
                switch result {
                case .success( _):
                    self.delegate?.updated(stocks: self.getDummyListOfStocks())
                case .failure( _):
                    self.delegate?.updated(stocks: self.getDummyListOfStocks())
                }
            }
        }
    }
    
    func updateActiveFetchTickers(tickers:[String], delegate: StockUpdatable){
        self.delegate = delegate
        self.activeFetchTickers = tickers

        if self.fetchingStrategy == FetchingStratery.TIME_INTERVAL {
            self.fetchWithTimer()
        } else if self.fetchingStrategy == .RECURSIVE {
            self.fetchWithRecursion()
        } else {
            print("fetch strategy none")
        }
    }
    
    func stopFetch(){
        self.dataTask?.cancel()
        self.timer?.invalidate()
        FetchStockPriceDataManager.shared.fetchingStrategy = .NONE
    }
}
