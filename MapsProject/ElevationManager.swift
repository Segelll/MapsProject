import Foundation
import CoreLocation

actor ElevationManager {
    func getElevation(loc:CLLocationCoordinate2D)  async throws-> ResponseBody2{
      //  let urlString = "https://api.open-elevation.com/api/v1/lookup?locations=\(loc.latitude),\(loc.longitude)"
        let urlString = "https://api.open-meteo.com/v1/elevation?latitude=\(loc.latitude)&longitude=\(loc.longitude)"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot get elevation data")
        }
        let urlrequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlrequest)
       guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching elevation data") }
        let decoded = try JSONDecoder().decode(ResponseBody2.self, from: data)
        return(decoded)
    }
    func getElevationfast(loc:[CLLocationCoordinate2D])  async throws-> ResponseBody2{
        var lat : String = ""
        lat = ""
        var lng : String = ""
        lng = ""
        for i in 0...loc.count-1{
            lat += String(loc[i].latitude)
            if i != loc.count-1{
                lat += ","
            }
            lng += String(loc[i].longitude)
                if i != loc.count-1{

                lng += ","
            }
        }


        let urlString = "https://api.open-meteo.com/v1/elevation?latitude=\(lat)&longitude=\(lng)"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot get elevation data")
        }
        let urlrequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlrequest)
       guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching elevation data latitude=\(lat)&longitude=\(lng)") }
        let decoded = try JSONDecoder().decode(ResponseBody2.self, from: data)
        return(decoded)
    }
}
