//
//  LocationsViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 25.03.2023.
//

import UIKit

final class LocationsViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var locations: [Location] = []
    private var nextPage: String?
    
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "location",
            for: indexPath
        )
        
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
    
    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if locations.count - indexPath.row <= 3 {
            fetchInfo(from: nextPage)
            fetchNextLocations(from: nextPage)
        }
    }
    
}

extension LocationsViewController {
    func fetchLocations() {
        networkManager.fetchLocations(from: Link.location.url) { [weak self] result in
            switch result {
            case .success(let locationsData):
                self?.locations = locationsData
                self?.fetchInfo(from: Link.location.url)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchInfo(from url: String?) {
        networkManager.fetchInfo(from: url) { [weak self] result in
            switch result {
            case .success(let info):
                self?.nextPage = info.next
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchNextLocations(from url: String?) {
        guard let url else { return }
        networkManager.fetchLocations(from: url) { [weak self] result in
            switch result {
            case .success(let newLocations):
                self?.locations.append(contentsOf: newLocations)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
