//
//  EpisodesViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 25.03.2023.
//

import UIKit

final class EpisodesViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var episodes: [Episode] = []
    private var nextPage: String?
    
    // MARK: - Table view data source
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return episodes.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "episode",
            for: indexPath
        )
        
        var content = cell.defaultContentConfiguration()
        
        content.text = episodes[indexPath.row].name
        content.secondaryText = episodes[indexPath.row].episode
        
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
        if episodes.count - indexPath.row <= 3 {
            fetchInfo(from: nextPage)
            fetchNextEpisodes(from: nextPage)
        }
    }
}

extension EpisodesViewController {
    func fetchEpisodes() {
        networkManager.fetchEpisodes(from: Link.episode.url) { [weak self] result in
            switch result {
            case .success(let episodesData):
                self?.episodes = episodesData
                self?.fetchInfo(from: Link.episode.url)
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
    
    func fetchNextEpisodes(from url: String?) {
        guard let url else { return }
        networkManager.fetchEpisodes(from: url) { [weak self] result in
            switch result {
            case .success(let newEpisodes):
                self?.episodes.append(contentsOf: newEpisodes)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
