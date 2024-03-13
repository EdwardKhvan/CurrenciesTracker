//
//  ViewController.swift
//  CurrenciesTracker
//
//  Created by Хван Эдуард on 13.03.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btcPrice: UILabel!
    @IBOutlet weak var ethPrice: UILabel!
    @IBOutlet weak var usdPrice: UILabel!
    @IBOutlet weak var lastUpdatedPrice: UILabel!
    
    @IBOutlet weak var rubPrice: UILabel!
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
    }
    
    @objc func refreshData() -> Void {
        fetchData()
    }
    
    private func fetchData() {
        let url = URL(string: urlString)
        let defaultSession = URLSession(configuration: .default)
        let dataTask = defaultSession.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
                return
        }
            do {
                let json = try JSONDecoder().decode(Rates.self, from: data!)
                self.setPrices(currency: json.rates)
            }
            catch {
                print(error)
                return
            }
            
        }
        dataTask.resume()
    }
    
    private func setPrices(currency: Currency) {
        
        DispatchQueue.main.async {
            self.btcPrice.text = self.formatPrice(currency.btc)
            self.ethPrice.text = self.formatPrice(currency.eth)
            self.usdPrice.text = self.formatPrice(currency.usd)
            self.lastUpdatedPrice.text = self.formatDate(date: Date())
            
        }
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM y HH:mm:ss"
        return formatter.string(from:  date)
    }
    
    private func formatPrice(_ price: Price) -> String {
        return String(format:  "%@ %.4f", price.unit, price.value)
        
    }
    
    struct Rates: Codable {
        let rates: Currency
    }
    
    struct Currency: Codable {
        let btc: Price
        let eth: Price
        let usd: Price
        let rub: Price
         
    }
    
    struct Price: Codable {
        let name: String
        let unit: String
        let value: Float
        let type: String
    }

}

