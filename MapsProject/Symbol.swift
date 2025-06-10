//
//  Symbol.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 10/06/2025.
//


import Foundation
import MapKit

//MARK: UISYMBOL
struct Symbol :Identifiable{
    let name : String
    let coordinate : CLLocationCoordinate2D
    let elevation : Double
    let username : String
    let id: UUID

}

struct Analytics:Identifiable {


    let lat : Double
    let lng : Double
    let temp : Double
    let elev: Double
    let hum : Double
    let wind : Double
    var id: Double { lat }
}
struct ResponseBody2 : Decodable{
    let elevation: [Double]

}
struct ResponseOptimized : Decodable {

    var main: MainOptimized
    let wind: WindOptimized

    struct WindOptimized : Decodable{
        let speed : Double
    }
    struct MainOptimized : Decodable{
        let temp : Double
        let humidity : Int
    }
}







struct ResponseDaily: Codable {

    let list: [ListElement]


    struct ListElement: Codable {
        let dt : Int
        let sunrise : Int
        let sunset : Int
        let temp: Temp
        let feels_like: FeelsLike
        let pressure: Int
        let humidity: Int
        let weather: [Weather]
        let speed: Double
        let deg: Int
        let gust: Double
        let clouds: Int
        let pop: Double
        let rain : Double?
    }

    struct Weather: Codable {

        let description: String

    }

    struct Temp: Codable {

        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }

    struct FeelsLike: Codable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }


}
struct ResponseHourly : Codable{
        let list: [WeatherData]


    struct WeatherData: Codable {
        let dt: Int
        let main: MainWeatherData
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let pop: Double
        let sys: Sys
        let rain: Rain?
        let dt_txt: String
    }
    struct Rain: Codable {
        let oneHour: Double

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }

    struct MainWeatherData: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }

    struct Weather: Codable {
        let description: String
    }

    struct Clouds: Codable {
        let all: Int
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double
    }

    struct Sys: Codable {
        let pod: String
    }
}



struct ResponseBody: Decodable {
    let coord: CoordinatesResponse
    let weather: [WeatherResponse]
    let main: MainResponse
    let name: String
    let wind: WindResponse
    let timezone: Int
    let sys: SysResponse
    let clouds: CloudsResponse
    let rain : RainResponse?
    struct RainResponse: Decodable {
        let oneHour: Double

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
        }
    }
    struct CloudsResponse : Decodable{
        var all: Int
    }
    struct SysResponse : Decodable{
        let country: String?
        let sunrise: Int
        let sunset: Int
    }

    struct CoordinatesResponse: Decodable {
        let lon: Double
        let lat: Double
    }

    struct WeatherResponse: Decodable {

        let description: String
    }

    struct MainResponse: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int

    }

    struct WindResponse: Decodable {
        let speed: Double
        //MARK: Causes performance issues
        let deg : Int
        let gust : Double?

    }
}


// Update the computed properties for MainResponse
extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }

}