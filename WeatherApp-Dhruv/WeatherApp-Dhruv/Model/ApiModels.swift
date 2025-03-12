//
//  ApiModels.swift
//  WeatherApp-Dhruv
//
//  Created by Dhruv Chhatbar on 11/03/25.
//

//import Foundation
//
//
//struct WeatherForcastModel: Codable{
//    let cod: String? // : "200"
//    let message: Int? // : 0
//    let cnt: Int? // : 40
//    let list: [ForcastListModel]? //
//    let city: [ForcastCityModel]? //
//}
//struct ForcastListModel: Codable{
//    let main: ForcastListMainModel?//
//    let weather: [ForcastListWeatherModel]?//
//    let wind: ForcastListWindModel?//
//    let dt_txt: String?// : "2025-03-11 09:00:00"
//}
//struct ForcastListMainModel: Codable{
//    let temp : Double? // 281.31
//    let feels_like : Double? // 280.38
//    let temp_min : Double? // 281.31
//    let temp_max : Double? // 284.93
//}
//struct ForcastListWeatherModel: Codable{
//    let d : Int? // 804
//    let main : String? // "Clouds"
//    let description : String? // "overcast clouds"
//    let icon : String? // "04d"
//}
//struct ForcastListWindModel: Codable{
//    let speed : Double? // 1.81
//    let deg : Int? // 197
//    let gust : Double? // 3.59
//}
//struct ForcastCityModel: Codable{
//    let id : Int? // : 3163858  
//    let name : String? // : "Zocca"
////    let coord : Int? //
//    let country : String? // : "IT"
////    let population : Int? // : 4593
////    let timezone : Int? // : 3600
////    let sunrise : Int? // : 1741671348
////    let sunset : Int? // : 1741713390
//
//}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherForcastModel = try? JSONDecoder().decode(WeatherForcastModel.self, from: jsonData)

import Foundation

// MARK: - WeatherForcastModel
struct WeatherForcastModel: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let sys: Sys?
    let dtTxt: String?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: String?
    let description, icon: String?
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}


// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}
// MARK: - WeatherCurrentModel
struct WeatherCurrentModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}
