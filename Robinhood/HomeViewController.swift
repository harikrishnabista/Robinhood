//
//  HomeViewController.swift
//  AsyncMessaginng
//
//  Created by Hari Bista on 9/24/21.
//  Copyright © 2021 Hari Bista. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showListOfStocksButtonTapped(_ sender: Any) {
        if let stockListViewController = self.storyboard?.instantiateViewController(withIdentifier: "StockListViewController") as? StockListViewController {
            self.navigationController?.pushViewController(stockListViewController, animated: true)
        }
    }

}
