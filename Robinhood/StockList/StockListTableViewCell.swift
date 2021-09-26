//
//  StockListTableViewCell.swift
//  AsyncMessaginng
//
//  Created by Hari Bista on 9/23/21.
//  Copyright © 2021 Hari Bista. All rights reserved.
//

import UIKit

class StockListTableViewCell: UITableViewCell {
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func display(stock: Stock){
        self.tickerLabel.text = stock.ticker
        self.priceLabel.text = "$\(stock.price)"
    }
}
