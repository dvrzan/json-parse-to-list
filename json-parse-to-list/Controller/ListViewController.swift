//
//  ViewController.swift
//  json-parse-to-list
//
//  Created by Danijela Vrzan on 2019-09-13.
//  Copyright © 2019 Danijela Vrzan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let jsonDataURL = "https://api.myjson.com/bins/1g99i5"
    var products = [Product]()
    
    @IBOutlet var productTableView: UITableView!
    @IBOutlet weak var sortButton: UISegmentedControl!
    
    
    @IBAction func segmentedValueDidChange(_ sender: UISegmentedControl) {
        if sortButton.selectedSegmentIndex == 0 {
            products.sort(by: sortByName)
        } else if sortButton.selectedSegmentIndex == 1 {
            products.sort(by: sortByCashback)
        }
        productTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.register(UINib(nibName: "CustomProductCell", bundle: nil), forCellReuseIdentifier: "customProductCell")
        configureTableView()
        
        if let url = URL(string: jsonDataURL) {
            if let json = try? Data(contentsOf: url) {
                parse(json: json)
                return
            }
        }
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let jsonProducts = try? decoder.decode(Products.self, from: json) {
            products = jsonProducts.offers
            segmentedValueDidChange(sortButton)
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func sortByName(this: Product, that: Product) -> Bool {
        return this.name < that.name
    }
    
    func sortByCashback(this: Product, that: Product) -> Bool {
        return this.cashBack < that.cashBack
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customProductCell", for: indexPath) as! CustomProductCell

        let product = self.products[indexPath.row]
        
        cell.productNameLabel.text = product.name
        cell.productCashbackValueLabel.text = "$" + String(product.cashBack)
        let data = try? Data(contentsOf: URL(string: product.imageUrl)!)
        cell.productImageView.image = UIImage(data: data!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func configureTableView () {
        productTableView.rowHeight = UITableView.automaticDimension
        productTableView.estimatedRowHeight = 250.0
    }
    
}
