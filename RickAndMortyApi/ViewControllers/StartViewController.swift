//
//  StartViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 20.03.2023.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.shared.fetch(Character.self, from: Links.character.url) { result in
            switch result {
            case .success(let info):
                print(info)
            case .failure(let error):
                print(error)
            }
        }
    }
    

}

