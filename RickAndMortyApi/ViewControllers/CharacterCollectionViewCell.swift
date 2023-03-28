//
//  CharacterCollectionViewCell.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 24.03.2023.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var characterImage: UIImageView! {
        didSet {
            characterImage.layer.cornerRadius = characterImage.frame.width / 2
        }
    }
    
    @IBOutlet var nameLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        
        networkManager.fetchData(from: character.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.characterImage.image = UIImage(data: image)
            case .failure(let error):
                print(error)
            }
        }
    }
}
