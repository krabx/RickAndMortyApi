//
//  EpisodesViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 25.03.2023.
//

import UIKit

class EpisodesViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var episodes: [Episode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Episodes"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episode", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = episodes[indexPath.row].name
        content.secondaryText = episodes[indexPath.row].episode
        
        cell.contentConfiguration = content
        
        return cell
    }
}

extension EpisodesViewController {
    func fetchEpisodes() {
        networkManager.fetch(AboutEpisodes.self, from: Links.episode.url) { [weak self] result in
            switch result {
            case .success(let episodes):
                self?.episodes = episodes.results
            case .failure(let error):
                print(error)
            }
        }
    }
}
