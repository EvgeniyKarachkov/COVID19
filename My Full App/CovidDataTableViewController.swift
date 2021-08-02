//
//  CovidDataTableViewController.swift
//  My Full App
//
//  Created by Admin on 26.07.2021.
//

import UIKit

class CovidDataTableViewController: UITableViewController {
    
    private var covidDatas: [CovidData] = []
    private var filteredCountry: [CovidData] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchCountryisEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchCountryisEmpty
    }
    
    
    
    let urlString = "https://covid-19.dataflowkit.com/v1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search country"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCountry.count
        }
        return covidDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DataTableViewCell
        
        var country: CovidData
        if isFiltering {
            country = filteredCountry [indexPath.row]
            
        } else {
            country = covidDatas [indexPath.row]
    
        }
        
        cell.configure(with: country)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func fetchData() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                self.covidDatas = try JSONDecoder().decode([CovidData].self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
}

extension CovidDataTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredCountry = covidDatas.filter({ (countrys: CovidData) in
            return countrys.country?.lowercased().contains(searchText.lowercased()) ?? false
        })
        tableView.reloadData()
    }
}

