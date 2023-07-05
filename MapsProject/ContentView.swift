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
    
    var body :some View{
        Map(position: $cameraPosition){
            Marker("You", image: "location.fill", coordinate: locationViewer.currentcoordinate )
            .tint(.blue)
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
                    
                    TextField("Search...",text: $searchText)
                        
                        .font(.subheadline)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding(1)
                        .shadow(radius:5)
                        .textFieldStyle(.roundedBorder)
                    Button(action: {
                        Task { await searchplace()}
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                            .padding(10)
                            .padding(8)
                            .frame(width: 35, height: 35)
                    })
                    .offset(x:135,y:0)
                }
               Button(action:{
                    locationViewer.checklocationservices()
                  
                }, label:{
                    Image(systemName: "shareplay")
                        .foregroundColor(.blue)
                        .frame(width:55,height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                })

                
            }
        }
        .onSubmit(of: .text){
            Task { await searchplace()}
        }
     
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

extension ContentView{
    func searchplace() async{
        let destination = MKLocalSearch.Request()
        destination.naturalLanguageQuery = searchText
        destination.region = .userRegion
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
