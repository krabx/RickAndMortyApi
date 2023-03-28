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

    @IBOutlet var characterImage: UIImageView! {
        didSet {
            //characterImage.layer.cornerRadius = characterImage.frame.height / 2
        }
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCharactersData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        characterImage.layer.cornerRadius = characterImage.frame.height / 2
    }
    
    private func setCharactersData() {
        nameLabel.text = character.name
        statusLabel.text = character.status
        speciesLabel.text = character.species
        fetchImage()
        setStatusTextColor()
    }
    
    private func setStatusTextColor() {
        statusLabel.textColor = .green
        if character.status == "Dead" {
            statusLabel.textColor = .red
        } else if character.status == "unknown" {
            statusLabel.textColor = .gray
        }
    }
}

extension AboutCharacterViewController {
    
    private func fetchImage() {
        networkManager.fetchData(from: character.image) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.characterImage.image = UIImage(data: imageData)
                //self?.characterImage.layer.cornerRadius = self?.characterImage.frame.height ?? 0 / 2
            case .failure(let error):
                print(error)
            }
        }
    }
//    private func fetchImage() {
//        networkManager.fetchImage(from: character.image) { [weak self] result in
//            switch result {
//            case .success(let image):
//                self?.characterImage.image = UIImage(data: image)
//                DispatchQueue.main.async {
//                    self?.characterImage.layer.cornerRadius = (self?.characterImage.frame.height ?? 300) / 2
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }

}
