//
//  CharactersViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 24.03.2023.
//

import UIKit
import Alamofire

class CharactersViewController: UICollectionViewController {
    
    private let networkManager = NetworkManager.shared
    private var characters: [Character] = []
    private var nextPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetch()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = collectionView.indexPathsForSelectedItems else { return }
        guard let aboutCharacterVC = segue.destination as? AboutCharacterViewController else {
            return
        }
        aboutCharacterVC.character = characters[index[0].row]
    }

//     MARK: UICollectionViewDataSource

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return characters.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "aboutCharacter", sender: nil)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "character",
            for: indexPath
        )
        guard let cell = cell as? CharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: characters[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if characters.count - indexPath.row <= 3 {
            fetchInfo(from: nextPage)
            fetchNextCharacters(from: nextPage)
        }
    }
}

extension CharactersViewController {
    func fetchCharacters() {
        networkManager.fetchCharacters(
            from: Link.character.url) { [weak self] result in
                switch result {
                case .success(let persons):
                    self?.characters = persons
                    self?.fetchInfo(from: Link.character.url)
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
//    func fetchCharacters() {
//        networkManager.fetch(
//            AboutCharacters.self,
//            from: Link.character.url
//        ) {
//            [weak self] result in
//            switch result {
//            case .success(let persons):
//                self?.characters = persons.results
//                self?.nextPage = persons.info.next
//                self?.collectionView.reloadData()
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    private func fetchNextCharacters(from url: String?) {
        guard let url else { return }
        networkManager.fetchCharacters(from: url) { [weak self] result in
            switch result {
            case .success(let newCharacters):
                self?.characters.append(contentsOf: newCharacters)
                //self?.fetchInfo(from: url)
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
//        networkManager.fetch(AboutCharacters.self, from: url) { [weak self] result in
//            switch result {
//            case .success(let persons):
//                self?.characters.append(contentsOf:persons.results)
//                self?.nextPage = persons.info.next
//                self?.collectionView.reloadData()
//            case .failure(let error):
//                print(error)
//            }
//        }
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
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize
    {
        CGSize(
            width: view.window?.windowScene?.screen.bounds.width ?? 400 - 48,
            height: 400
        )
    }

}
