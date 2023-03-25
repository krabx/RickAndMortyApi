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
    
    func getData() {
        
        guard let characterVC = viewControllers?[0] as? CharactersViewController else {
            return
        }
        guard let locationVC = viewControllers?[1] as? LocationsViewController else {
            return
        }
        guard let episodesVC = viewControllers?.last as? EpisodesViewController else {
            return
        }
        
        characterVC.fetchCharacters()
        locationVC.fetchLocations()
        episodesVC.fetchEpisodes()
    }
}
