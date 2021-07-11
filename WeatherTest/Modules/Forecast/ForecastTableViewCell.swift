//
//  ForecastTableViewCell.swift
//  WeatherTest
//
//  Created by Davron on 11.07.2021.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    static let identifier = "ForecastTableViewCell"
      
    let mainTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Monday, June"
        label.textAlignment = .left
        return label
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "24 °C"
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ForecastTableViewCell.identifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        contentView.addSubview(mainTitle)
        contentView.addSubview(degreeLabel)
        
        mainTitle.snp.makeConstraints{(make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        degreeLabel.snp.makeConstraints{(make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }

}
