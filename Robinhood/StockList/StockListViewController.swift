//
//  StockListViewController.swift
//  AsyncMessaginng
//
//  Created by Hari Bista on 9/23/21.
//  Copyright © 2021 Hari Bista. All rights reserved.
//

import UIKit

class StockListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = StockListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchStockList(delegate: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.stopFetch()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        self.viewModel.stopFetch()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.viewModel.fetchStockList(delegate: self)
    }
}

extension StockListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.stockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockListTableViewCell", for: indexPath) as! StockListTableViewCell
        cell.display(stock: self.viewModel.stockList[indexPath.row])
        return cell
    }
}

extension StockListViewController : StockUpdatable {
    func updated(stocks: [Stock]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension StockListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let stockDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "StockDetailViewController") as? StockDetailViewController {
            
            stockDetailViewController.viewModel.stock = self.viewModel.stockList[indexPath.row]
            
            self.navigationController?.pushViewController(stockDetailViewController, animated: true)
        }
    }
}

extension StockListViewController: AppDelegateListening {
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.viewModel.stopFetch()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.viewModel.fetchStockList(delegate: self)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

