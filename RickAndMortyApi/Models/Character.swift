//
//  Character.swift
//  RickAndMortyApi
//
//  Created by Богдан Радченко on 20.03.2023.
//

import Foundation

struct Character: Decodable {
    let name: String
    let status: String
    let species: String
    let origin: Origin
    let location: CharacterLocation
    let image: String
    let episode: [String]
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct CharacterLocation: Decodable {
    let name: String
    let url: String
}

struct AboutCharacters: Decodable {
    let results: [Character]
}

struct AboutLocations: Decodable {
    let results: [Location]
}

struct Location: Decodable {
    let name: String
    let type: String
    let url: String
}

struct AboutEpisodes: Decodable {
    let results: [Episode]
}

struct Episode: Decodable {
    let name: String
    let episode: String
}
