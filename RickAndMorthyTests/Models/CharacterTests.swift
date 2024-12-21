//
//  CharacterTests.swift
//  RickAndMorthyTests
//
//  Created by Raul Mantilla on 20 de diciembre de 2024.
//

import XCTest
@testable import RickAndMorthy

final class CharacterTests: XCTestCase {
    func testCharacterDecoding() {
        let jsonData = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "Main Character",
            "gender": "Male",
            "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
            },
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """.data(using: .utf8)!

        do {
            let character = try JSONDecoder().decode(Character.self, from: jsonData)
            XCTAssertEqual(character.id, 1)
            XCTAssertEqual(character.name, "Rick Sanchez")
            XCTAssertEqual(character.status, .alive)
            XCTAssertEqual(character.species, "Human")
            XCTAssertEqual(character.type, "Main Character")
            XCTAssertEqual(character.gender, .male)
            XCTAssertEqual(character.origin?.name, "Earth (C-137)")
            XCTAssertEqual(character.origin?.url, "https://rickandmortyapi.com/api/location/1")
            XCTAssertEqual(character.location?.name, "Citadel of Ricks")
            XCTAssertEqual(character.location?.url, "https://rickandmortyapi.com/api/location/3")
            XCTAssertEqual(character.image, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
            XCTAssertEqual(character.episode?.count, 2)
            XCTAssertEqual(character.url, "https://rickandmortyapi.com/api/character/1")
            XCTAssertEqual(character.created, "2017-11-04T18:48:46.250Z")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
}
