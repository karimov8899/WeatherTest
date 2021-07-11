//
//  BaseAPI.swift
//  WeatherTest
//
//  Created by Davron on 11.07.2021.
//

import Foundation
import Alamofire

enum APIError: Error {
    case SomeError
}

class BaseAPI {
    static let baseAPI = BaseAPI()
    
    func weatherMainRequest(url: String, completion: @escaping (Result<(WeatherModel), Error>) -> Void){
        AF.request(url).responseDecodable(of: WeatherModel.self) { (response) in
           print(response)
            switch response.result {
            case.success(_):
                if let data = response.data {
                    let decoder = JSONDecoder()
                    if let weatherModel = try? decoder.decode(WeatherModel.self, from: data) {
                        print(weatherModel)
                        completion(.success(weatherModel))
                    }
                }
            case.failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func forecastDaysRequest(url: String, completion: @escaping (Result<(ForecastModel), Error>) -> Void){
        AF.request(url).responseDecodable(of: ForecastModel.self) { (response) in
           print(response)
            switch response.result {
            case.success(_):
                if let data = response.data {
                    let decoder = JSONDecoder()
                    if let weatherModel = try? decoder.decode(ForecastModel.self, from: data) { 
                        completion(.success(weatherModel))
                    }
                }
            case.failure(let error):
                completion(.failure(error))
            }
            
        }
    }
     
} 
