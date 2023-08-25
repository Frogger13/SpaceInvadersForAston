//
//  SettingsViewController.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 22.08.2023.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    var spaceShipShortNames: Array<String> = []
    var selectedSpaceShipFileName = ""
    var lifeScore:Int!
    var timeAppearenceinterval:Double!
    var gameSpeed:Int!
    var volumeSong:Float!

    let titleLable = UILabel()
    let nameTextField = UITextField()
    let spaceShipImageView = UIImageView()
    var spaceShipSegControl:UISegmentedControl!
    var gameDifficultySegControl:UISegmentedControl!
    let volumeSlider = UISlider()
    let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        nameTextField.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func setUI(){
        //MARK: - titleLable
        titleLable.text = "Settings"
        titleLable.font = UIConstants.settigsViewTitleFont
        titleLable.textColor = .red
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - nameTextField
        nameTextField.text = "Dan"
        nameTextField.font = UIConstants.settingsViewTextFont
        nameTextField.placeholder = "Name"
        nameTextField.clearButtonMode = .always
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - spaceShipImageView
        if let presentSpaceShip = defaults.string(forKey: UserDefaultsKeys.spaceShipName){
            spaceShipImageView.image = UIImage(named: presentSpaceShip)
        } else {
            spaceShipImageView.image = UIImage(named: "space_ship")
        }
        spaceShipImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //MARK: - spaceShipSegControl
        GameplayConstants.spaceShipNamesArray.forEach({
            spaceShipShortNames.append($0.0)
        })
        spaceShipSegControl = UISegmentedControl(items: spaceShipShortNames)
        spaceShipSegControl.addTarget(self, action: #selector(selectedSpaceShip), for: .valueChanged)
        spaceShipSegControl.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - gameDifficultySegControl
        let difficults = ["Easy", "Medium", "Hard", "VeryHard"]
        gameDifficultySegControl = UISegmentedControl(items: difficults)
        gameDifficultySegControl.addTarget(self, action: #selector(selectedDifficult), for: .valueChanged)
        gameDifficultySegControl.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - volume slider
        volumeSlider.setValue(defaults.object(forKey: UserDefaultsKeys.volumeSong) as? Float ?? 0.5, animated: false)
        volumeSlider.addTarget(self, action: #selector(selectedVolume), for: .valueChanged)
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - back button
        backButton.setImage(UIImage(named: "back_button"), for: .normal)
        backButton.setTitle("Save & back", for: .normal)
        backButton.setTitleColor(.red, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - add Subviews
        view.addSubview(titleLable)
        view.addSubview(nameTextField)
        view.addSubview(spaceShipImageView)
        view.addSubview(spaceShipSegControl)
        view.addSubview(gameDifficultySegControl)
        view.addSubview(volumeSlider)
        view.addSubview(backButton)
        
        //MARK: - NSLayoutConstraint activate
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.settingsViewSafeAreaIndent),
            titleLable.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.settingsViewLeftRightIndent),
            titleLable.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.settingsViewLeftRightIndent),
            
            nameTextField.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: UIConstants.settingsViewElementIndent),
            nameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.settingsViewLeftRightIndent),
            nameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.settingsViewLeftRightIndent),
            
            spaceShipImageView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.settingsViewElementIndent),
            spaceShipImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spaceShipImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1/3),
            spaceShipImageView.heightAnchor.constraint(equalTo: spaceShipImageView.widthAnchor),

            spaceShipSegControl.topAnchor.constraint(equalTo: spaceShipImageView.bottomAnchor, constant: UIConstants.settingsViewElementIndent),
            spaceShipSegControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.settingsViewLeftRightIndent),
            spaceShipSegControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.settingsViewLeftRightIndent),
            
            gameDifficultySegControl.topAnchor.constraint(equalTo: spaceShipSegControl.bottomAnchor, constant: UIConstants.settingsViewElementIndent),
            gameDifficultySegControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.settingsViewLeftRightIndent),
            gameDifficultySegControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.settingsViewLeftRightIndent),
            
            volumeSlider.topAnchor.constraint(equalTo: gameDifficultySegControl.bottomAnchor, constant: UIConstants.settingsViewElementIndent),
            volumeSlider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.settingsViewLeftRightIndent),
            volumeSlider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.settingsViewLeftRightIndent),
            
            backButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: UIConstants.settingsViewElementIndent),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.settingsViewLeftRightIndent),
            backButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.settingsViewLeftRightIndent),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.settingsViewSafeAreaIndent)
        ])
        
        
        
    }
    
    @objc
    func selectedSpaceShip(target: UISegmentedControl){
        if target == spaceShipSegControl {
            let segmentIndex = target.selectedSegmentIndex
            selectedSpaceShipFileName = GameplayConstants.spaceShipNamesArray[segmentIndex].1
            self.spaceShipImageView.image = UIImage(named: selectedSpaceShipFileName)
        }
    }
    
    @objc
    func selectedDifficult(target: UISegmentedControl){
        if target == gameDifficultySegControl {
            let segmentIndex = target.selectedSegmentIndex
            switch segmentIndex {
            case 0:
                do {
                    self.lifeScore = 5
                    self.timeAppearenceinterval = 1.5
                    self.gameSpeed = 16
                }
            case 1:
                do {
                    self.lifeScore = 3
                    self.timeAppearenceinterval = 1.5
                    self.gameSpeed = 8
                }
            case 2:
                do {
                    self.lifeScore = 1
                    self.timeAppearenceinterval = 1
                    self.gameSpeed = 4
                }
            case 3:
                do {
                    self.lifeScore = 0
                    self.timeAppearenceinterval = 1
                    self.gameSpeed = 2
                }
            default:
                do{
                    self.lifeScore = 5
                    self.timeAppearenceinterval = 1.5
                    self.gameSpeed = 20
                }
            }
        }
    }
    
    @objc
    func selectedVolume(target: UISlider){
        if target == volumeSlider{
            volumeSong = target.value
        }
    }
    
    @objc
    func backButtonPressed(){
        self.dismiss(animated: true)
        saveToUserDefaults()
    }
    
    func saveToUserDefaults(){
        if nameTextField.text != "" {
            defaults.set(nameTextField.text, forKey: UserDefaultsKeys.playerName)
        }
        if selectedSpaceShipFileName != "" {
            defaults.set(selectedSpaceShipFileName, forKey: UserDefaultsKeys.spaceShipName)
        }
        if lifeScore != nil {
            defaults.set(lifeScore, forKey: UserDefaultsKeys.lifeScore)
        }
        if timeAppearenceinterval != nil {
            defaults.set(timeAppearenceinterval, forKey: UserDefaultsKeys.timeAppearenceInterval)
        }
        if gameSpeed != nil {
            defaults.set(gameSpeed, forKey: UserDefaultsKeys.gameSpeed)
        }
        if volumeSong != nil {
            defaults.set(volumeSong, forKey: UserDefaultsKeys.volumeSong)
        }
    }
    
    //MARK: - UITextFiewldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
    }
    

}
