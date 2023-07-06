//
//  ContentView.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 4.07.2023.
//

import SwiftUI
import SwiftData
import MapKit


struct ContentView: View{
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    
    @State private var searchText = ""
    @State private var Destinationlocation = [MKMapItem]()
    @StateObject private var locationViewer = LocationViewer()
    
    @State var redmode = false
    @State var weather : ResponseBody?
    var weathermanager = WeatherManager()
    
    @State var locationbuttonpressed = false
    @State var shownewscreen = false
    var body :some View{
        Map(position: $cameraPosition){
            
            if redmode == true{
                Marker("You", image: "sparkles", coordinate: locationViewer.currentcoordinate )
                    .tint(.red)
            }else{
                Marker("You", image: "location.fill", coordinate: locationViewer.currentcoordinate )
                    .tint(.blue)
            }
            ForEach (Destinationlocation ,id: \.self){ item in
                let placemark=item.placemark
                Marker(placemark.name ?? "",image:"location.magnifyingglass", coordinate:placemark.coordinate)}
            .tint(.black)
        }
        .mapControls{
            
        }
        .overlay(alignment: .top){
            HStack{
                ZStack{
                    
                    TextField("Search for a place...",text: $searchText)
                       
                        .font(.subheadline)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding(1)
                        .shadow(radius:20)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 270, height: 100)
                    
                    Button(action: {
                        Task { await searchplace()}
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                            .padding(10)
                            .padding(8)
                            .frame(width: 35, height: 35)
                            
                        
                        
                    })
                    .offset(x:105,y:0)
                }
                Button(action:{
                    locationViewer.checklocationservices()
                    locationbuttonpressed = true
                    
                }, label:{
                    Image(systemName: "shareplay")
                        .foregroundColor(.blue)
                        .frame(width:55,height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                })
                       Button(action:{
                           if locationbuttonpressed == true{
                               shownewscreen.toggle()
                               redmode = true
                               Task{
                               do{
                                   weather = try await weathermanager.getWeather(loc: locationViewer.currentcoordinate)
                                   print(weather)
                               }
                               catch{
                                   print("error occured")
                               }
                           }
                                   
                           }
                       },label:{
                           Image(systemName: "thermometer.sun.fill")
                               .frame(width:55, height: 55)
                               .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                       })
                       .sheet(isPresented: $shownewscreen,onDismiss:{ redmode = false} ){
                           newscreen()
                       }
                      
            }
        }
         
        .onSubmit(of: .text){
            Task { await searchplace()}
        }
        
    }
}
struct newscreen:View{
    var body:some View{
        Text("null")
            
    }
}

class LocationViewer: NSObject, ObservableObject,CLLocationManagerDelegate{
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var locationManager:CLLocationManager?
    @Published var currentcoordinate = CLLocationCoordinate2D()
    func checklocationservices(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            checkAuth()
        }else{
            print("Please turn on location services")
        }
    }
    private func checkAuth() {
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location services is restricted")
        case .denied:
            print("Please check your settings for location permission")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
            break
            
        @unknown default:
            break
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuth()
       
     
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error while requesting new coordinates")
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
        self.currentcoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        print("\(currentcoordinate)")
    }
}
class WeatherManager{
    func getWeather(loc:CLLocationCoordinate2D) async throws->ResponseBody{
        let apiKey = "a3b0b4eecff65df2ce3a000f2718760c"
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
}
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}

extension ContentView{
    func searchplace() async{
        
        var locationviewer = LocationViewer()
        locationViewer.checklocationservices()
        let destination = MKLocalSearch.Request()
        destination.naturalLanguageQuery = searchText
        destination.region = MKCoordinateRegion(center: locationViewer.currentcoordinate, latitudinalMeters: 125000, longitudinalMeters: 125000)
        let Destinationlocation =  try? await MKLocalSearch(request: destination).start()
        self.Destinationlocation = Destinationlocation?.mapItems ?? []
    }
}
extension CLLocationCoordinate2D{
    
    static var userLocation: CLLocationCoordinate2D{
        return .init(latitude: 39.925533, longitude: 32.866287)
        
    }
}
extension MKCoordinateRegion{
    static var userRegion: MKCoordinateRegion{
        return .init(center: .userLocation ,latitudinalMeters: 12500,longitudinalMeters: 12500)
    }
}

#Preview {
    ContentView()
}
