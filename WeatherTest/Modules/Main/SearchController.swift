//
//  SearchController.swift
//  WeatherTest
//
//  Created by Davron on 11.07.2021.
//

import Foundation
import UIKit
protocol FavoriteSelectedDelegate {
    func favoriteSelected(location: MainLocation)
}

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var locations = [MainLocation]()
    
    var delegate: FavoriteSelectedDelegate?
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.separatorColor = .gray
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.favoriteSelected(location: locations[indexPath.row])
    }
}
