//
//  CharacterModel.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 22.11.2022.
//

import Foundation

struct CharacterModel: Codable {
    let charId: Int
    let name: String
    let birthday: String
    let occupation: [String]
    let img: String
    let nickname: String
    let appearance: [Int]
    
    enum CodingKeys: String, CodingKey {
        case charId = "char_id"
        case name
        case birthday
        case occupation
        case img
        case nickname
        case appearance
    }
}
