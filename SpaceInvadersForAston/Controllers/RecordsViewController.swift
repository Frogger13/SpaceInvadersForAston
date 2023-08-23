//
//  RecordsViewController.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 22.08.2023.
//

import UIKit

class RecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recordsArray = defaults.array(forKey: ObjcKeys.recordsArray){
            return recordsArray.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifire , for: indexPath)
        let recordsArray = defaults.array(forKey: ObjcKeys.recordsArray)
        let record = recordsArray?[indexPath.row] as! Int
        cell.textLabel?.text = String(describing: record)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
}

class RecordViewCell:UITableViewCell{
    var spaceShipImage = UIImageView()
    var nameUserLabel = UILabel()
    var scoreRecordlabel = UILabel()
    
    
}



