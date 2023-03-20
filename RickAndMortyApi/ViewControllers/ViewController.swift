//
//  ViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 20.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let link = "https://rickandmortyapi.com/api/character/1"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacter()
    }
    
    private func fetchCharacter() {
        guard let url = URL(string: link) else { return }

        URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }

            let decoder = JSONDecoder()

            do {
                let character = try decoder.decode(Character.self, from: data)
                print(character)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

