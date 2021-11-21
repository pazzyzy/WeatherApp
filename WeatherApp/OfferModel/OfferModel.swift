//
//  OfferModel.swift
//  WeatherApp
//
//  Created by Ant Zy on 20.11.2021.
//

import Foundation

class OfferModel: Codable {
    var cod: String?
    var message: Float?
    var cnt: Float
    var list: [ListOfferModel]?
    var city: CityModel?
}
