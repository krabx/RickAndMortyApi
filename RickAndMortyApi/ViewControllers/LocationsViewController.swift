//
//  LocationsViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 25.03.2023.
//

import UIKit

class LocationsViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var locations: [Location] = []
    
    // MARK: - Table view data source
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return locations.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = locations[indexPath.row].name
        content.secondaryText = locations[indexPath.row].type
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension LocationsViewController {
//    func fetchLocations() {
//        networkManager.fetch(
//            AboutLocations.self,
//            from: Link.location.url
//        ) {
//            [weak self] result in
//            switch result {
//            case .success(let places):
//                self?.locations = places.results
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
}
