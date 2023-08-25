//
//  ReocrdModel.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 23.08.2023.
//

import Foundation

struct RecordModel:Codable{
    var name: String
    var score:Int
    var spaceShip: String
    
    init(name: String, score: Int, spaceShip: String) {
        self.name = name
        self.score = score
        self.spaceShip = spaceShip
    }
}
