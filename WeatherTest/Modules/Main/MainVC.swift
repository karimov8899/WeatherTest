//
//  ViewController.swift
//  WeatherTest
//
//  Created by Davron on 11.07.2021.
//

import UIKit
import SnapKit
import CoreLocation
import Kingfisher

class MainVC: UIViewController, CLLocationManagerDelegate, UISearchControllerDelegate, UISearchResultsUpdating, FavoriteSelectedDelegate {
    
    // Variables
    let locationManager = CLLocationManager()
    var location = CLLocation()
    let searchController = UISearchController(searchResultsController: SearchController())
    //UI Elements
    private let backView = UIView()
    private let locationView = UIView()
    
    private let cityName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "City Name"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "sunny")
        return image
    }()
    
    private let currentDegree: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .medium)
        label.text = "24 °C"
        label.textAlignment = .center
        return label
    }()
    
    private let smallDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.text = "Mostly Sunny"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let locationBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("My Location", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        return btn
    }()
    
    private let warningTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Location Disabled"
        label.textColor = .white
        return label
    }()
    
    private let warningDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.text = "Please Enable Location Services"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let settingsBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Open Settings", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        return btn
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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(avtiveMethod), name: UIApplication.didBecomeActiveNotification, object: nil)
        locationManager.delegate = self 
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        checkLocationStatus()
        setUpViews()
        setUpConstraints()
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        // Do any additional setup after loading the view.
    }
    
    
    // Adding Views
    func setUpViews() {
        view.addSubview(backView) 
        backView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        backView.addSubview(cityName)
        backView.addSubview(weatherIcon)
        backView.addSubview(currentDegree)
        backView.addSubview(smallDescription)
        backView.addSubview(locationBtn)
        locationBtn.addTarget(self, action: #selector(reloadLocation), for: .touchUpInside)
        backView.addSubview(locationView)
        locationView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.82)
        locationView.isHidden = true
        locationView.addSubview(warningTitle)
        locationView.addSubview(warningDescription)
        locationView.addSubview(settingsBtn)
        settingsBtn.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    }
    
    // Setting up Constraints
    func setUpConstraints() {
        
        backView.snp.makeConstraints {(make) in
            make.edges.equalToSuperview()
        }
        
        cityName.snp.makeConstraints{(make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(45)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        weatherIcon.snp.makeConstraints{(make) in
            make.width.height.equalTo(90)
            make.centerX.equalToSuperview()
            make.top.equalTo(cityName.snp.bottom).offset(20)
        }
        
        currentDegree.snp.makeConstraints{(make) in
            make.top.equalTo(weatherIcon.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        smallDescription.snp.makeConstraints{(make) in
            make.top.equalTo(currentDegree.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        locationBtn.snp.makeConstraints{(make) in
            make.top.equalTo(smallDescription.snp.bottom).offset(40)
            make.height.equalTo(55)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        locationView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
        
        warningTitle.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        
        warningDescription.snp.makeConstraints{(make) in
            make.top.equalTo(warningTitle.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        settingsBtn.snp.makeConstraints{(make) in
            make.height.equalTo(55)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(warningDescription.snp.bottom).offset(30)
        }
        
    }
    
    func checkLocationStatus() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                locationView.isHidden = false
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                locationView.isHidden = true
                requestData()
            @unknown default:
                break
            }
        } else {
            locationView.isHidden = false
        }
    }
    
    @objc func openSettings(_ sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    @objc func avtiveMethod() {
        checkLocationStatus()
    }
    
    func requestData() {
        showSpinner()
        if let currentLocation = UserDefaults.standard.dictionary(forKey: "currentLocation") as? [String:Double]{
            guard let lat = currentLocation["latitude"], let lon = currentLocation["longitude"] else {return}
            location = CLLocation(latitude: lat, longitude: lon)
            var saveCity = ""
            LocationManager.shared.getAddress(location: location) {results in
                saveCity = results
            }
            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=a05f726debf0566d1298e9f940d7d5a5" 
            BaseAPI.baseAPI.weatherMainRequest(url: url) {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let data):
                    if let weatherData = data.weather?.first {
                        guard let degree = data.main?.temp, let description = weatherData.weatherDescription, let image = weatherData.icon  else {return}
                        strongSelf.currentDegree.text = "\(Int(degree)) °C"
                        strongSelf.cityName.text = saveCity
                        strongSelf.smallDescription.text = description.capitalized
                        let url = URL(string: "https://openweathermap.org/img/wn/\(image)@2x.png")
                        strongSelf.weatherIcon.kf.setImage(with: url)
                        UserDefaults.standard.setValue(["Degree":"\(Int(degree)) °C","Description": description.capitalized, "City": saveCity], forKey: "ErrorCase")
                    }
                    strongSelf.hideSpinner()
                case.failure(_):
                    if let errorCase = UserDefaults.standard.dictionary(forKey: "ErrorCase") as? [String:String],let cityName = errorCase["City"] {
                        strongSelf.cityName.isHidden = false
                        strongSelf.cityName.text = cityName
                        strongSelf.currentDegree.text = errorCase["Degree"]
                        strongSelf.smallDescription.text = errorCase["Description"] 
                        print("Error")
                    }
                    strongSelf.hideSpinner()
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
    @objc func reloadLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
}

extension MainVC {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        UserDefaults.standard.setValue(["latitude":Double(locValue.latitude), "longitude": Double(locValue.longitude)], forKey: "currentLocation")
        UserDefaults.standard.synchronize()
        locationManager.stopUpdatingLocation()
        requestData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        LocationManager.shared.findLocations(with: text) {locations in
            let resultsController = searchController.searchResultsController as? SearchController
            resultsController?.delegate = self
            DispatchQueue.main.async {
                resultsController?.locations = locations
                resultsController?.tableView.reloadData()
            }
        }
    }
    
    func favoriteSelected(location: MainLocation) {
        guard let coordinates = location.coordinates else {
            return
        }
        UserDefaults.standard.setValue(["latitude":Double(coordinates.latitude), "longitude": Double(coordinates.longitude)], forKey: "currentLocation")
        UserDefaults.standard.synchronize()
        requestData()
        searchController.isActive = false
    }
}
