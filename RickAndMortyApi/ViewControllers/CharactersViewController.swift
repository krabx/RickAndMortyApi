//
//  CharactersViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 24.03.2023.
//

import UIKit
import Alamofire

final class CharactersViewController: UICollectionViewController {
    
    private let networkManager = NetworkManager.shared
    private var characters: [Character] = []
    private var filterCharacters: [Character] = []
    private var nextPage: String?
    private let searchVC = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let searchText = searchVC.searchBar.text else { return false}
        return searchText.isEmpty
    }
    private var isFiltering: Bool {
        searchVC.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        setupSearch()
    }
    
    func setupSearch() {
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search"
        searchVC.searchBar.barTintColor = .white
        navigationItem.searchController = searchVC
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = collectionView.indexPathsForSelectedItems else { return }
        guard let aboutCharacterVC = segue.destination as? AboutCharacterViewController else {
            return
        }
        aboutCharacterVC.character = isFiltering
        ? filterCharacters[index[0].row]
        : characters[index[0].row]
    }
    
    //     MARK: UICollectionViewDataSource
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        isFiltering ? filterCharacters.count : characters.count
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
        cell.configure(with: isFiltering
                       ? filterCharacters[indexPath.row]
                       : characters[indexPath.row]
        )
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if characters.count - indexPath.row <= 3 {
            fetchInfo(from: nextPage)
            fetchNextCharacters(from: nextPage)
        }
        
        if filterCharacters.count - indexPath.row <= 3 {
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
    
    private func fetchNextCharacters(from url: String?) {
        guard let url else { return }
        networkManager.fetchCharacters(from: url) { [weak self] result in
            switch result {
            case .success(let newCharacters):
                self?.characters.append(contentsOf: newCharacters)
                self?.collectionView.reloadData()
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

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterBySearch(searchController.searchBar.text ?? "")
    }
    
    func filterBySearch(_ searchRequest: String) {
        filterCharacters = characters.filter({ character in
            character.name.lowercased().contains(searchRequest.lowercased())
        })
        collectionView.reloadData()
    }
}
