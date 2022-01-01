//
//  ContentView.swift
//  Weather
//
//  Created by Александр Сенюк on 01.01.2022.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
  @StateObject var weatherManager = WeatherManager()
  @State var searchText = ""
  
  var body: some View {
    VStack {
      HStack {
        Button(action: getWeatherByLocation) {
          Image(systemName: "location.circle.fill")
        }
        .padding()
        .foregroundColor(.black)
        TextField("Поиск", text: $searchText, onCommit: getWeatherByCityName)
          .textFieldStyle(.roundedBorder)
        Button(action: getWeatherByCityName) {
          Image(systemName: "magnifyingglass")
        }
        .padding()
        .foregroundColor(.black)
      }
      HStack {
        Spacer()
        VStack(alignment: .trailing) {
          if let weather = weatherManager.weather {
            Image(systemName: weather.conditionName)
              .font(.system(size: 80))
              .foregroundColor(.black)
            HStack {
              Text(weather.temperatureString)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.black)
              Text("°C")
                .font(.system(size: 80))
                .foregroundColor(.black)
            }
            
            Text(weather.cityName)
              .font(.system(size: 30))
              .padding(.bottom)
              .foregroundColor(.black)
            Text(weather.weatherDescription)
              .font(.system(size: 17))
              .foregroundColor(.black)
          }
        }
      }
      .padding()
      
      Spacer()
    }
    .background(
      Image("background")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()
    )
  }
  
  func getWeatherByLocation() {
    weatherManager.requestLocation()
  }
  
  func getWeatherByCityName() {
    weatherManager.fetchWeather(cityName: searchText)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewInterfaceOrientation(.portraitUpsideDown)
  }
}
