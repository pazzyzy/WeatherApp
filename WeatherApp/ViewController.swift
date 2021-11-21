//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ant Zy on 20.11.2021.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    
    var timer = Timer()
    
    fileprivate var contentView: MainView {
        return self.view as! MainView
    }
    
    var dataIsReady: Bool = false
    var offerModel:OfferModel! {
        didSet {
            DispatchQueue.main.async {
                self.contentView.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.contentView.tableView.dataSource = self
        self.contentView.tableView.delegate = self
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationItem.title = "Weather Application"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let city = searchController.searchBar.text!
        
        timer.invalidate()
        
        if city != "" {
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {(timer) in NetworkManager.shared.getWeather(city: city, result: { (model) in
                if model != nil {
                    self.dataIsReady = true
                        self.offerModel = model
                    
                    }
                })
            })
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataIsReady {
            return self.offerModel!.list!.count
        } else {
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        cell.cityLabel.text = self.offerModel.city!.name
        cell.timeLabel.text = self.offerModel.list![indexPath.row].dt_txt
        cell.tempMinLabel.text = self.offerModel.list![indexPath.row].main!.temp_min?.description
        cell.tempLabel.text = self.offerModel.list![indexPath.row].main!.temp?.description
        cell.tempMaxLabel.text = self.offerModel.list![indexPath.row].main!.temp_max?.description
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



