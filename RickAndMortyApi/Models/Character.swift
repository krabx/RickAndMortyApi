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
    let location: Location
    let image: String
    let episode: [String]
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct Location: Decodable {
    let name: String
    let url: String
}
