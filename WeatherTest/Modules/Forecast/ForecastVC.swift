//
//  ForecastVC.swift
//  WeatherTest
//
//  Created by Davron on 11.07.2021.
//

import Foundation
import UIKit

class ForecastVC: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.hidesWhenStopped = true
        activityView.style = .medium
        activityView.color = .white
        return activityView
    }()
    
    private var layerSpinner: UIView = {
        let layerView = UIView()
        layerView.backgroundColor = .black
        layerView.alpha = 0.8
        return layerView
    }()
    
    var daysData: [Forecastday] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        requestData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    func setUpViews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
    }
    
    func setUpConstraints() {
        tableView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
    }
    
    func requestData() {
        showSpinner()
        if let currentLocation = UserDefaults.standard.dictionary(forKey: "currentLocation") as? [String:Double]{
            guard let lat = currentLocation["latitude"], let lon = currentLocation["longitude"] else {return}
            let url = "https://api.weatherapi.com/v1/forecast.json?key=593aa2a5d383471a986152518211107&q=\(lat),\(lon)&days=6&aqi=no&alerts=no"
            BaseAPI.baseAPI.forecastDaysRequest(url:url){ [weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let data):
                    if let data = data.forecast?.forecastday {
                        strongSelf.daysData = data
                    }
                      
                    strongSelf.tableView.reloadData()
                    strongSelf.hideSpinner()
                case.failure(_): 
                    strongSelf.hideSpinner()
                    print("Error")
                }
            }
        }
    }
    
    func showSpinner() {
        spinner.center = view.center
        view.addSubview(layerSpinner)
        layerSpinner.snp.makeConstraints{(make) in
            make.bottom.left.right.top.equalToSuperview()
        }
        layerSpinner.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.82)
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        layerSpinner.removeFromSuperview()
        
    }
     
}

extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as! ForecastTableViewCell
        if let temp = daysData[indexPath.row].day?.avgtempC, let date = daysData[indexPath.row].dateEpoch {
            cell.mainTitle.text = getWeekDay(time: Date(timeIntervalSince1970: date))
            cell.degreeLabel.text = "\(Int(temp)) °C"
        }
        return cell
    }
    
    func getWeekDay(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        let currentDateString: String = dateFormatter.string(from: time)
        return currentDateString
    }
    
}
