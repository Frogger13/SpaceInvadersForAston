//
//  GameOverView.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 22.08.2023.
//

import UIKit

class GameOverView: UIView {

    static func instatceFromNib() -> GameOverView{
        UINib(nibName: "\(Self.self)", bundle: nil).instantiate(withOwner: nil).first as? GameOverView ?? GameOverView()
    }
    
    func setUI(){
        let gameOverLabel = UILabel()
        gameOverLabel.text = "Game over"
        gameOverLabel.font = UIConstraintsConstants.gameOverFontUIFont
        gameOverLabel.textColor = .red
        
    }

}
