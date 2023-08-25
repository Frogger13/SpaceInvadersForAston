//
//  RecordsViewController.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 22.08.2023.
//

import UIKit

class RecordsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let titleLable = UILabel()
    var tableView = UITableView()
    let backButton = UIButton()
    
    var cellIdentifire = "TableViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        titleLable.text = "Top 10 Records:"
        titleLable.font = UIConstants.titleFont
        titleLable.textColor = .red
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.delegate = self
        tableView.dataSource = self
        
        backButton.setImage(UIImage(named: "back_button"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.red, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLable)
        view.addSubview(tableView)
        view.addSubview(backButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.recordsViewIndent),
            titleLable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.recordsViewIndent),
            
            tableView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: UIConstants.recordsViewIndent),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.recordsViewIndent),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.recordsViewIndent),
            tableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -UIConstants.recordsViewIndent)
            
            
        ])
        
    }
    
    @objc
    func backButtonPressed(){
        self.dismiss(animated: true)
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource{
    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recordsArray = defaults.array(forKey: UserDefaultsKeys.recordsArray){
            return recordsArray.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifire , for: indexPath)
        var content = cell.defaultContentConfiguration()
        if let recordsArray = defaults.array(forKey: UserDefaultsKeys.recordsArray) as? Array<Data> {
            let decoder = JSONDecoder()
            if let record = try? decoder.decode(RecordModel.self, from: recordsArray[indexPath.row]){
                
                let image = UIImage(named: record.spaceShip)
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 25))
                let scaledImage = renderer.image { _ in
                    image?.draw(in: CGRect(origin: .zero, size: CGSize(width: 20, height: 25)))
                }
                
                content.image = scaledImage
                content.text = record.name
                content.secondaryText = String(record.score)
            } else {
                content.image = UIImage()
                content.text = ""
                content.secondaryText = ""
            }
        }
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - UITableViewDelegate
}

class RecordViewCell:UITableViewCell{
    var spaceShipImageView = UIImageView()
    var nameUserLabel = UILabel()
    var scoreRecordlabel = UILabel()
    
    var spceShipImageName: String!
    var userName: String!
    var score: Int!
    
    
    func setupSells(){
        
        spaceShipImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scoreRecordlabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spaceShipImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            spaceShipImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            spaceShipImageView.widthAnchor.constraint(equalToConstant: 50),
            spaceShipImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameUserLabel.leftAnchor.constraint(equalTo: spaceShipImageView.rightAnchor, constant: 5),
            nameUserLabel.topAnchor.constraint(equalTo: spaceShipImageView.topAnchor),
            nameUserLabel.heightAnchor.constraint(equalTo: spaceShipImageView.heightAnchor),
            nameUserLabel.widthAnchor.constraint(equalToConstant: 300),
            
            scoreRecordlabel.topAnchor.constraint(equalTo: spaceShipImageView.topAnchor),
            scoreRecordlabel.leftAnchor.constraint(equalTo: nameUserLabel.rightAnchor, constant: 5),
            scoreRecordlabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5)
            
        ])
        
        self.addSubview(spaceShipImageView)
        self.addSubview(nameUserLabel)
        self.addSubview(scoreRecordlabel)
        
    }
    
    
}



