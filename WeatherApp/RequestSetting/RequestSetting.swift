//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Ant Zy on 20.11.2021.
//

import Foundation

class RequestSetting {
    private init() {}
    
    static let shared: RequestSetting = RequestSetting()
    
    func getWeather(city: String, result: @escaping ((OfferModel?)->())) {
     
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "appid", value: "f3d98099e5a06a78d9946426e68d0b38")]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                var decoderOfferModel: OfferModel?
                
                if data != nil {
                    decoderOfferModel = try? decoder.decode(OfferModel.self, from: data!)
                }
                
                result(decoderOfferModel)
            } else {
                print(error as Any)
            }
        }.resume()
    }
}
