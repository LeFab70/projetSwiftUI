//
//  WeatherService.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-13.
//

import Foundation
import SwiftUI

@MainActor
class WeatherService: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeather: [DailyWeather] = []
    @Published var errorMessage: String?
    
    private let apiKey = "e1b25eda638a2631949e04c24c9bf8b1" 
    
    func fetchWeather(lat: Double, lon: Double) async {
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            self.currentWeather = decoded.current
            self.dailyWeather = decoded.daily
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

