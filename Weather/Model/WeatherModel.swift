//
//  WeatherModel.swift
//  Weather
//
//  Created by Александр Сенюк on 01.01.2022.
//

import Foundation

extension String {
  func capitalizeFirstLetter () -> String {
    return self.prefix(1).capitalized + self.dropFirst()
  }
}

struct WeatherModel {
  let conditionId: Int
  let cityName: String
  let temperature: Double
  let description: String
  
  var weatherDescription: String {
    return description.capitalizeFirstLetter()
  }
  
  var temperatureString: String {
    return String(format: "%.1f", temperature)
  }
  
  var conditionName: String {
    switch conditionId {
    case 200...232:
      return "cloud.bolt"
    case 300...321:
      return "cloud.drizzle"
    case 500...531:
      return "cloud.rain"
    case 600...622:
      return "cloud.snow"
    case 701...781:
      return "cloud.fog"
    case 800:
      return "sun.max"
    case 801...804:
      return "cloud"
    default:
      return "cloud"
    }
  }
}
