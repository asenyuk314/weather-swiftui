//
//  WeatherManager.swift
//  Weather
//
//  Created by Александр Сенюк on 01.01.2022.
//

import Foundation
import CoreLocation

class WeatherManager: NSObject, ObservableObject {
  @Published var weather: WeatherModel?
  private var apiSettings: Settings {
    guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
      fatalError("Cannot find file 'Secrets.plist'")
    }
    let xml = FileManager.default.contents(atPath: path)
    guard let settings = try? PropertyListDecoder().decode(Settings.self, from: xml!) else {
      fatalError("Cannot get Secrets from 'Secrets.plist'")
    }
    return settings
  }
  private let locationManager = CLLocationManager()
  private var weatherURL: String {
    "https://api.openweathermap.org/data/2.5/weather?appid=\(apiSettings.API_Key)&units=metric&lang=ru"
  }
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  
  func fetchWeather(cityName: String) {
    let cityNameWithoutSpaces = cityName.trimmingCharacters(in: .whitespaces)
    let urlString = "\(weatherURL)&q=\(cityNameWithoutSpaces)"
    performRequest(with: urlString)
  }
  
  private func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
    performRequest(with: urlString)
  }
  
  private func performRequest(with urlString: String) {
    let urlEncoder = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    if let url = URL(string: urlEncoder) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          print(error!)
          return
        }
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            DispatchQueue.main.async {
              self.weather = weather
            }
          }
        }
      }
      task.resume()
    }
  }
  
  private func parseJSON (_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let description = decodedData.weather[0].description
      let temp = decodedData.main.temp
      let name = decodedData.name
      
      let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: description)
      return weather
    } catch {
      print(error)
      return nil
    }
  }
}

extension WeatherManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      fetchWeather(latitude: lat, longitude: lon)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
  func requestLocation() {
    locationManager.requestLocation()
  }
}
