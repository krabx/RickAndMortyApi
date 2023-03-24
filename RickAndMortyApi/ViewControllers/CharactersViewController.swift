//
//  CharactersViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 24.03.2023.
//

import UIKit

class CharactersViewController: UICollectionViewController {
    
    private let networkManager = NetworkManager.shared

    private var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacter()
    }

//     MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "character",
            for: indexPath
        )
        guard let cell = cell as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: characters[indexPath.row])
        
        return cell
    }
}

extension CharactersViewController {
    private func fetchCharacter() {
        //print(Links.character.url + "/\(i)")
        networkManager.fetch(AboutCharacters.self, from: Links.character.url) { [weak self] result in
            switch result {
            case .success(let persons):
                self?.characters = persons.results
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        CGSize(width: UIScreen.main.bounds.width - 48, height: 800)
//    }
}
