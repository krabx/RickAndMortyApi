//
//  AboutCharacterViewController.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 25.03.2023.
//

import UIKit

final class AboutCharacterViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    
    var character: Character!

    @IBOutlet var characterImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCharactersData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        characterImage.layer.cornerRadius = characterImage.frame.size.height / 2
    }
    
    private func setCharactersData() {
        nameLabel.text = character.name
        statusLabel.text = character.status
        speciesLabel.text = character.species
        fetchImage()
    }
}

extension AboutCharacterViewController {
    private func fetchImage() {
        networkManager.fetchImage(from: character.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.characterImage.image = UIImage(data: image)
            case .failure(let error):
                print(error)
            }
        }
    }

}
