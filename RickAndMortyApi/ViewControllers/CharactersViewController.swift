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
    
    func fetch() {
        AF.request(Link.character.url)
            .responseJSON { [weak self] dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return }
            
            if (200...299).contains(statusCode) {
                switch dataResponse.result {
                case .success(let value):
                    guard let CharactersData = value as? [String:Any] else { return }
                    guard let results = CharactersData["results"] as? [[String:Any]] else { return }
                    print(results)
                    for result in results {
                        let character = Character(
                            name: result["name"] as? String ?? "",
                            status: result["status"] as? String ?? "",
                            species: result["species"] as? String ?? "",
                            origin: result["origin"] as? Origin ?? Origin(name: "", url: ""),
                            location: result["location"] as? CharacterLocation ?? CharacterLocation(name: "", url: ""),
                            image: result["image"] as? String ?? "",
                            episode: result["episode"] as? [String] ?? [""]
                        )

                        self?.characters.append(character)
                    }
                    print(self?.characters.count)
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            } else {
                guard let error = dataResponse.error else { return }
                print(error)
            }
        }
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
            fetchNextCharacters(from: nextPage)
        }
    }
}

extension CharactersViewController {
    func fetchCharacters() {
        networkManager.fetch(
            AboutCharacters.self,
            from: Link.character.url
        ) {
            [weak self] result in
            switch result {
            case .success(let persons):
                self?.characters = persons.results
                self?.nextPage = persons.info.next
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchNextCharacters(from url: String?) {
        networkManager.fetch(AboutCharacters.self, from: url) { [weak self] result in
            switch result {
            case .success(let persons):
                self?.characters.append(contentsOf:persons.results)
                self?.nextPage = persons.info.next
                self?.collectionView.reloadData()
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
