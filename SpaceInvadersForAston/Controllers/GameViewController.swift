//
//  GameViewController.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 31.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else { return }
            scene.gameViewControlerDelegate = self
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Functions
    
    func setGameOverView(){
        let gameOverLabel = UILabel()
        let buttonView = UIView()
        let backButton = UIButton()
        let restartButton = UIButton()
        
        gameOverLabel.text = "Game over"
        gameOverLabel.font = UIConstants.gameOverTitleFont
        gameOverLabel.textColor = .red
        gameOverLabel.textAlignment = .center
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.layer.zPosition = 2
        
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.setImage(UIImage(named: "restart_button"), for: .normal)
        restartButton.addTarget(self, action: #selector(restartButtonPressed), for: .touchUpInside)
        restartButton.layer.zPosition = 2

        
        view.addSubview(gameOverLabel)
        view.addSubview(buttonView)
        view.addSubview(backButton)
        view.addSubview(restartButton)
        
        NSLayoutConstraint.activate([
            gameOverLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.gameOverViewIndent),
            gameOverLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.gameOverViewIndent),
            gameOverLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonView.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: UIConstants.gameOverViewIndent),
            buttonView.centerXAnchor.constraint(equalTo: gameOverLabel.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            

            restartButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            restartButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: UIConstants.gameOverViewIndent),
            restartButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            
            buttonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            buttonView.heightAnchor.constraint(equalTo: backButton.heightAnchor)
            
        ])
    }
    
    //MARK: - Objc functions
    
    @objc
    func restartButtonPressed(){
                
    }
    
    @objc
    func backButtonPressed(){
        self.dismiss(animated: true)
        
    }
}

extension GameViewController: GameViewControllerDelegate{
    func openGameOverView() {
        setGameOverView()
    }
}
