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
    @State var mapselection: MKMapItem?
    @State private var searchText = ""
    @State private var Destinationlocation = [MKMapItem]()
    @StateObject private var locationViewer = LocationViewer()
    @State var markeron = false
    @State var redmode = false
    @State var weather : ResponseBody?
    var weathermanager = WeatherManager()
    @State var weatherfound = false
    @State var hybridmode : MapStyle = .standard
    @State var satellitebutton = false
    @State var placeredmode = false
    @State var locationbuttonpressed = false
    @State var shownewscreen = false
    @State var searchmode = true
    @State var tapped = false
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State var centerlocation :CLLocationCoordinate2D?
    @State var centeronend :CLLocationCoordinate2D?
    @State var elevation : ResponseBody2?
    var elevationmanager = ElevationManager()
    var body :some View{
        
        
    
        Map(position: $cameraPosition, selection:$mapselection){
         
            if markeron == true{
                if redmode == true{
                    Marker("You", image: "thermometer.sun.fill", coordinate: locationViewer.currentcoordinate )
                        .tint(.red)
                }else{
                    Marker("You", image: "location.fill", coordinate: locationViewer.currentcoordinate )
                        .tint(.blue)
                }}else{
                    
                }
            
                ForEach (Destinationlocation ,id: \.self){ item in
                    let placemark=item.placemark
                    if placeredmode == false{
                        Marker(placemark.name ?? "",image:"thermometer.sun.fill", coordinate:placemark.coordinate)
                            .tint(.black)
                        
                    }
                    else{
                        Marker(placemark.name ?? "",image:"thermometer.sun.fill", coordinate:placemark.coordinate)
                            .tint(.red)
                    }
                    
                    
                }
            if searchmode == false{
                
                
                if tapped == true{
                    Marker(weather?.name ?? "",image:"thermometer.sun.fill", coordinate:centeronend ?? locationViewer.currentcoordinate)
                        .tint(.indigo)
                    
                    
                        
                }
            }

         
        }
        
        
        
        .mapStyle(hybridmode)
           
        
        
        .overlay(alignment: .top){
            HStack{
                
                Button(action:{
                    locationViewer.checklocationservices()
                    locationbuttonpressed = true
                    markeron.toggle()
                    
                    
                    
                    
                    
                    
                    
                }, label:{
                    
                    if markeron == true {
                        Image(systemName: "shareplay")
                            .foregroundColor(.blue)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)}
                    else if markeron == false{
                        Image(systemName: "shareplay.slash")
                            .foregroundColor(.gray)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                })
                Button(action:{
                    redmode = true
                    tapped = false
                    cameraPosition = .region (MKCoordinateRegion(center: locationViewer.currentcoordinate ,latitudinalMeters: 12500,longitudinalMeters: 12500))
                    if markeron == true{
                        Task{
                            do{
                                weather = try await weathermanager.getWeather(loc: locationViewer.currentcoordinate)
                                weatherfound = true
                            }catch{
                                print("error")
                            }
                        }
                        
                    }
                },label:{
                    Image(systemName: "figure.wave")
                        .foregroundColor(.blue)
                        .frame(width:55,height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                    
                }
                )
                ZStack{
                    if searchmode == true{
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
                    else{
                        Text("")
                            .font(.subheadline)
                            .padding(10)
                        
                            .padding(1)
                            .shadow(radius:20)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 270, height: 100)
                        
                    }
                    
                }
                Spacer()
                Button(action:{
                    if searchmode == false{
                        tapped = true
                        
                        Task{
                            do{
                                if mapselection == nil{
                                    weather = try await weathermanager.getWeather(loc: centeronend ?? locationViewer.currentcoordinate)
                                    weatherfound = true
                                }
                                
                            }
                            catch{
                                print("error occured")
                            }
                            
                        }
                      
                    }
                }, label:{
                    if searchmode == false{
                        Image(systemName: "hand.tap.fill")
                        
                            .foregroundStyle(.indigo)
                        
                            .frame(width:55, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                })
                
                Button(action:{
                    
                    Task{
                        do{
                            if mapselection == nil{
                                if tapped == false{
                                    weather = try await weathermanager.getWeather(loc: locationViewer.currentcoordinate)
                                    weatherfound = true
                                }
                                else{
                                    weather = try await weathermanager.getWeather(loc: centeronend ?? locationViewer.currentcoordinate)
                                    weatherfound = true
                                }
                            }
                            
                        }
                        catch{
                            print("error occured")
                        }
                        
                    }
                    
                    shownewscreen.toggle()
                    redmode = true
                    
                    
                    
                },label:{
                    
                    if weatherfound == true{
                        switch("\(weather!.weather[0].description)"){
                        case "clear sky":
                            HStack{
                                Image(systemName: "sun.max.fill")
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "few clouds","overcast clouds":
                            HStack{
                                Image(systemName: "cloud.sun.fill")
                                
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                        case "scattered clouds":
                            HStack{
                                Image(systemName: "cloud.fill")
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "broken clouds":
                            HStack{
                                Image(systemName: "smoke.fill")
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "shower rain":
                            HStack{
                                Image(systemName: "cloud.heavyrain.fill")
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "rain","light rain":
                            HStack{
                                Image(systemName: "cloud.sun.rain.fill")
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "thunderstorm":
                            HStack{
                                Image(systemName: "cloud.bolt.rain.fill")
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "snow":
                            HStack{
                                Image(systemName: "cloud.snow.fill")
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "mist":
                            HStack{
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                        default:
                            Image(systemName: "thermometer.sun.fill")
                                .frame(width:85, height: 55)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                        }
                    }else{
                        Image(systemName: "thermometer.sun.fill")
                            .frame(width:85, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                    
                })
                .popover(isPresented: $shownewscreen ){
                    
                    if weather != nil{
                        newscreen(weather: weather!)
                            .presentationDetents([
                                .height(100),
                                .fraction(0.2),
                                .medium,
                                .large])
                    }
                    
                }
                
                Button(action:{
                    searchmode.toggle()
                    
                    if tapped == true{
                        tapped = false
                        Task{
                            do{
                                if mapselection == nil{
                                    weather = try await weathermanager.getWeather(loc: locationViewer.currentcoordinate)
                                    weatherfound = true
                                    
                                    
                                    
                                }
                                
                            }
                            catch{
                                print("error occured")
                            }
                            
                        }
                    }
                    
                }, label:{
                    if searchmode == true{
                        Text("SearchCast")
                            .fontWidth(.expanded)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .frame(width:130, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                        
                    }
                    else{
                        Text("TapCast")
                            .fontWidth(.expanded)
                            .font(.footnote)
                            .foregroundStyle(.indigo)
                        
                            .frame(width:130, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                })
                
                
                Button(action:{
                    
                    satellitebutton.toggle()
                    if satellitebutton  == true{
                        hybridmode = .hybrid
                    }else{
                        hybridmode = .standard
                    }
                    
                }, label: {
                    if satellitebutton == true{
                        Image(systemName: "globe.americas.fill")
                            .foregroundColor(.green)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }else{
                        Image(systemName: "map.fill")
                            .foregroundColor(.gray)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                    
                })
            }
        
       
            
            
                
                
                
            
                
            }
        
        .overlay(alignment:.center){
            if satellitebutton == true{
            Image(systemName: "plus.viewfinder")
            
                .foregroundColor(.red)
            }else{
                Image(systemName: "plus.viewfinder")
            }
                
        }
        .overlay(alignment:.bottom){
            Button(action:{
                
            },label:{
                let txttemplat = String(format: "%.3f",centerlocation?.latitude ?? locationViewer.currentcoordinate.latitude)
                let txttemplong = String(format: "%.3f",centerlocation?.longitude ?? locationViewer.currentcoordinate.longitude)
            let txttempalt = String(format: "%.3f",elevation?.results[0].elevation ?? 0,0)
                Text("\(txttemplat)° , \(txttemplong)° / \(txttempalt)m")
                    .fontWidth(.expanded)
                    .font(.footnote)
                    .foregroundStyle(.black)
                
                    .frame(width:300, height: 55)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                    .shadow(radius: 20)
            })
            .offset(y:-10)
        }
            
               
                      
            
        
       
       
        //MARK: Where i left off
        .onSubmit(of: .text){
            Task { await searchplace()}
        }
        .onMapCameraChange(frequency: .continuous, { newcamera in
            centerlocation = newcamera.region.center
            Task{
                elevation  = try await elevationmanager.getElevation(loc: CLLocationCoordinate2D(latitude: centerlocation?.latitude ?? locationViewer.currentcoordinate.latitude, longitude: centerlocation?.longitude ?? locationViewer.currentcoordinate.longitude))
            }
            
            
        })
        .onMapCameraChange(frequency: .onEnd, { newcamera in
            centeronend = newcamera.region.center
            if tapped == true{
                Task{
                    do{
                        if mapselection == nil{
                          
                              
                           weather = try await weathermanager.getWeather(loc: centeronend ?? locationViewer.currentcoordinate)
                                weatherfound = true
                            
                        }
                        
                    }
                    catch{
                        print("error occured")
                    }
                    
                }
            

            }
        })
       
        
        .onChange(of:mapselection,{oldValue, newValue in
            let placemark = mapselection?.placemark
            redmode = false
            placeredmode = true
            
            if placemark != nil{
                Task{
                    do{
                        weather = try await weathermanager.getWeather(loc:placemark!.coordinate )
                        weatherfound = true
                    }
                    catch{
                        print("error occured")
                    }
                }
          
        }
            shownewscreen.toggle()
            
        })
       
        
        
      
        
    }
        
}

struct newscreen:View{
    var weather:ResponseBody
    var body:some View{
        ZStack{
            HStack(alignment:.top){
            Spacer()
                VStack{
                    Text(weather.name)
                        .bold()
                        .font(.largeTitle)
                        .fontWidth(.expanded)
                        .textCase(.uppercase)
                    Text("\(Date().formatted(.dateTime.day().month().hour().minute()))")
                        .fontWidth(.expanded)
                        .textCase(.uppercase)
                        .italic()
                }
                
                Spacer()
                VStack{
                    Text("\(Int(weather.main.temp.rounded()-273.15))°C")
                        .fontWidth(.expanded)
                        .bold()
                        .font(.system(size: 33))
                    Text("Humidity: \(Int(weather.main.humidity.rounded()))%")
                        .fontWidth(.expanded)
                        .bold()
                    Text("Wind Speed: \(Int(weather.wind.speed))m/s")
                        .fontWidth(.expanded)
                        .bold()
                }
                Spacer()
            }
            
            
        }
        .frame(
              width: 520,
              height:120
              
            )
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
class ElevationManager{
    func getElevation(loc:CLLocationCoordinate2D)  async throws-> ResponseBody2{
        
        let apiKey = "AIzaSyBE26NhHWb4EPni6vA7qO0jgGvGbeMy1ZM"
        let urlString = "https://maps.googleapis.com/maps/api/elevation/json?locations=\(loc.latitude)%2C\(loc.longitude)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot get elevation data")
        }
        let urlrequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlrequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching elevation data") }
        let decoded = try JSONDecoder().decode(ResponseBody2.self, from: data)
        return(decoded)
    }
}
struct ResponseBody2: Decodable {
    let results: [Result]
    let status: String
    
}
    struct Result: Decodable {
        let elevation: Double
        let location: Location
        let resolution: Double
        
    }
        struct Location: Decodable {
            let lat: Double
            let lng: Double
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
        
        _ = LocationViewer()
        locationViewer.checklocationservices()
        let destination = MKLocalSearch.Request()
                destination.naturalLanguageQuery = searchText
           
        destination.region = MKCoordinateRegion(center: locationViewer.currentcoordinate, latitudinalMeters: 125000, longitudinalMeters: 125000)
        destination.resultTypes = .address
        let Destinationlocation =  try? await MKLocalSearch(request: destination).start()
        self.Destinationlocation = Destinationlocation?.mapItems ?? []
        if destination.naturalLanguageQuery != nil{
            cameraPosition = .region (MKCoordinateRegion(center: self.Destinationlocation[0].placemark.coordinate,latitudinalMeters: 12500,longitudinalMeters: 12500))
        }
        
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
