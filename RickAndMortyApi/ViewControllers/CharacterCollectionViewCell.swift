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
        
        networkManager.fetchImage(from: character.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.characterImage.image = UIImage(data: image)
//                DispatchQueue.main.async {
//                    self?.characterImage.layer.cornerRadius = self?.characterImage.frame.width ?? 400 / 2
//                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 5, height: 8)
    }
}
