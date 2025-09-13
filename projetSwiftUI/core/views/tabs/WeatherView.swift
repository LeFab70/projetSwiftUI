//
//  WeatherView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherService = WeatherService()
        var userLocation: UserLocation
    var body: some View {
        VStack {
                   if let current = weatherService.currentWeather {
                       Text("Température actuelle : \(Int(current.temp))°C")
                           .font(.title2)
                           .bold()
                       Text(current.weather.first?.description.capitalized ?? "")
                   } else if let error = weatherService.errorMessage {
                       Text("Erreur: \(error)")
                           .foregroundColor(.red)
                   } else {
                       ProgressView("Chargement de la météo...")
                   }
                   
                   List(weatherService.dailyWeather) { day in
                       HStack {
                           Text(Date(timeIntervalSince1970: day.dt), style: .date)
                           Spacer()
                           Text("\(Int(day.temp.min))° / \(Int(day.temp.max))°")
                           Text(day.weather.first?.main ?? "")
                       }
                   }
               }
               .padding()
               .task {
                   await weatherService.fetchWeather(
                    lat: userLocation.latitude ?? 0,
                    lon: userLocation.longitude!
                   )
               }
    }
}

#Preview {
    WeatherView(userLocation: .init())
}
