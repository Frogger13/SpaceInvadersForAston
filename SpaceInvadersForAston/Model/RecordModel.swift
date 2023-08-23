//
//  ReocrdModel.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 23.08.2023.
//

import Foundation

struct RecordModel:Codable{
    var name: String
    var scrore:Int
    var spaceShip: String
    
    init(name: String, scrore: Int, spaceShip: String) {
        self.name = name
        self.scrore = scrore
        self.spaceShip = spaceShip
    }
}
