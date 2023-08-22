//
//  LaunchScreenViewController.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 02.08.2023.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    //MARK: - var/let
    
    var buttonStartGame = UIButton()
    var buttonRecords = UIButton()
    var buttonSettings = UIButton()
    
    //MARK: - Lifecucle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        
    }
    
    //MARK: - set UI
    
    func setUI(){
        
        //MARK: - buttonStartGame setup
        view.addSubview(buttonStartGame)
        buttonStartGame.setTitle("Start game", for: .normal)
        buttonStartGame.titleLabel?.font = UIConstraintsConstants.mainMenuButtonFont
        buttonStartGame.setTitleColor(.yellow, for: .normal)
        buttonStartGame.setTitleColor(.blue, for: .focused)
        
        buttonStartGame.backgroundColor = .red
        buttonStartGame.setTitleColor(.blue, for: .focused)
        buttonStartGame.layer.cornerRadius = 20
        buttonStartGame.translatesAutoresizingMaskIntoConstraints = false
        buttonStartGame.addTarget(self, action: #selector(pressedButtonStartGame), for: .touchUpInside)
        
        //MARK: - buttonRecords setup
        view.addSubview(buttonRecords)
        buttonRecords.setTitle("Records", for: .normal)
        buttonRecords.titleLabel?.font = UIConstraintsConstants.mainMenuButtonFont
        buttonRecords.setTitleColor(.yellow, for: .normal)
        buttonRecords.setTitleColor(.blue, for: .focused)
        
        buttonRecords.backgroundColor = .red
        buttonRecords.layer.cornerRadius = 20
        buttonRecords.translatesAutoresizingMaskIntoConstraints = false
        buttonRecords.addTarget(self, action: #selector(pressedButtonRecords), for: .touchUpInside)
        
        //MARK: - buttonSettingsSetup
        view.addSubview(buttonSettings)
        buttonSettings.setTitle("Settings", for: .normal)
        buttonSettings.titleLabel?.font = UIConstraintsConstants.mainMenuButtonFont
        buttonSettings.setTitleColor(.yellow, for: .normal)
        buttonSettings.setTitleColor(.blue, for: .focused)
        
        buttonSettings.backgroundColor = .red
        buttonSettings.layer.cornerRadius = 20
        buttonSettings.translatesAutoresizingMaskIntoConstraints = false
        buttonSettings.addTarget(self, action: #selector(pressedButtonSettings), for: .touchUpInside)
        
        //MARK: - NSLayoutConstraint.activate
        NSLayoutConstraint.activate([
            buttonRecords.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            buttonRecords.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonRecords.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstraintsConstants.mainMenuButtonLeadingConstraint),
            buttonRecords.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstraintsConstants.mainMenuButtonLeadingConstraint),
            
            buttonStartGame.bottomAnchor.constraint(equalTo: buttonRecords.topAnchor, constant: -UIConstraintsConstants.mainMenuButtonIndent),
            buttonStartGame.leadingAnchor.constraint(equalTo: buttonRecords.leadingAnchor),
            buttonStartGame.trailingAnchor.constraint(equalTo: buttonRecords.trailingAnchor),
            
            buttonSettings.topAnchor.constraint(equalTo: buttonRecords.bottomAnchor, constant: UIConstraintsConstants.mainMenuButtonIndent),
            buttonSettings.leadingAnchor.constraint(equalTo: buttonRecords.leadingAnchor),
            buttonSettings.trailingAnchor.constraint(equalTo: buttonRecords.trailingAnchor),
        ])
        
        
        
        
        
        
    }
    
    //MARK: - Navidgation
    
    @objc func pressedButtonStartGame(){
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    @objc func pressedButtonRecords(){
        
    }
    
    @objc func pressedButtonSettings(){
        
    }

}
