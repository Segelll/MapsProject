import Foundation
import CoreLocation

actor WeatherManager { 
    private func getAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let secrets = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: Any],
              let apiKey = secrets["API_KEY"] as? String else {
            fatalError("API Key not found in Secrets.plist")
        }
        return apiKey
    }
    func getWeather(loc:CLLocationCoordinate2D) async throws->ResponseBody{
        let apiKey = getAPIKey()
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
        let apiKey = getAPIKey()
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
        let apiKey = getAPIKey()
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
        let apiKey = getAPIKey()
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
