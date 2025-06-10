import Foundation
import CoreLocation

class WeatherManager{

    func getWeather(loc:CLLocationCoordinate2D) async throws->ResponseBody{
        let apiKey = "39ed1b4024d6111287817f094f7c5fb7"
                let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(loc.latitude)&lon=\(loc.longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot get weather data")
        }
        let urlrequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlrequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        let decoded = try JSONDecoder().decode(ResponseBody.self, from: data)
        return(decoded)
    }
    func getOptimizedWeather(loc:CLLocationCoordinate2D) async throws->ResponseOptimized{
        let apiKey = "39ed1b4024d6111287817f094f7c5fb7"
                let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(loc.latitude)&lon=\(loc.longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot get weather data")
        }
        let urlrequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlrequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        let decoded = try JSONDecoder().decode(ResponseOptimized.self, from: data)
        return(decoded)

    }
    func gethourlyWeather(loc:CLLocationCoordinate2D) async throws->ResponseHourly{
        let apiKey = "39ed1b4024d6111287817f094f7c5fb7"
                let urlString = "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=\(loc.latitude)&lon=\(loc.longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot get weather data")
        }
        let urlrequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlrequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        let decoded = try JSONDecoder().decode(ResponseHourly.self, from: data)
        return(decoded)
    }
    func getdailyWeather(loc:CLLocationCoordinate2D) async throws->ResponseDaily{
        let apiKey = "39ed1b4024d6111287817f094f7c5fb7"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(loc.latitude)&lon=\(loc.longitude)&cnt=16&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot get weather data")
        }
        let urlrequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlrequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data") }
        let decoded = try JSONDecoder().decode(ResponseDaily.self, from: data)
        return(decoded)
    }
}
