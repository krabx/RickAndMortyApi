//
//  TabBarController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 25.03.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    private func getData() {
        guard let tabBarViewControllers = viewControllers else { return }
        for tabBarViewController in tabBarViewControllers {
            guard let navigationVC = tabBarViewController as? UINavigationController else {
                return
            }
            if let charactersVC = navigationVC.topViewController as? CharactersViewController {
                //charactersVC.fetchCharacters()
                charactersVC.fetchCharacters()
            } else if let locationsVC = navigationVC.topViewController as? LocationsViewController {
                locationsVC.fetchLocations()
            } else if let episodesVC = navigationVC.topViewController as? EpisodesViewController {
                //episodesVC.fetchEpisodes()
            }
        }
    }
}
