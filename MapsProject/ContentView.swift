//  ContentView.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 4.07.2023.
//


import SwiftUI
import SwiftData
import MapKit
import FirebaseAuth
import Charts
struct ContentView: View{
    @AppStorage("uid") var userid: String = ""
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.925533, longitude: 32.866287) ,latitudinalMeters: 12500,longitudinalMeters: 12500))
    @State var mapselection: MKMapItem?
    @State private var searchText = ""
    @State private var Destinationlocation = [MKMapItem]()
    @StateObject var locationViewer = LocationViewer()
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
    @State var centerlocation :CLLocationCoordinate2D?
    @State var centeronend :CLLocationCoordinate2D?
    @State var elevation : ResponseBody2?
    @State var poly = 0
    var elevationmanager = ElevationManager()
    @ObservedObject var polygonviewer = polygonViewer()
    @State var a = ""
    @State var distance : [Double] = []
    @State var midpoint : [CLLocationCoordinate2D] = []
    @State var polyon : Bool = false
    @State var firstD : Double = 0.0
    @State var firstC : CLLocationCoordinate2D?
    @State var areaof : Double = 0.0
    @State var angle : [Double] = [(0.0)]
    @State var firstA = 0.0
    @State var showselectionscreen = false
    @State private var selectkm = false
    @State var total = 0.0
    @State var regionarea : Double = 0.0
    @State var polylinemode : Bool = false
    @State var showanalytics = false
    @State var tablecontent : [Analytics] = []
    @State var elevationholder : ResponseBody2?
    @State var weatherholder : ResponseBody?
    @State var amount = ""
    @State var Loading :Bool = false
    @State var tablemarkeron :Bool = false
    @State var tablecoord = CLLocationCoordinate2D(latitude:0,longitude:0)
    @State var popupshowedbefore : Bool = false
    @State var markercolor : Color = .black
    @State var markername : Double = 0
    @State var analyzed = false
    @State var showdate = false
    @State var dateString : String?
    @State var route : [MKRoute?] = []
    @State var routemode : Bool = false
    @State var routelength : Double = 0
    var body :some View{
        
        
    
        Map(position: $cameraPosition, selection:$mapselection){
            
            if markeron == true{
                
               
                    Annotation("",coordinate:locationViewer.currentcoordinate){
                        ZStack{
                            Circle()
                                .frame(width:32,height:32)
                                .foregroundStyle(redmode ? .red.opacity(0.25) : .blue.opacity(0.25))
                            
                            Circle()
                                .frame(width:20,height:20)
                                .foregroundStyle(.white)
                            
                            Circle()
                                .frame(width:12,height:12)
                                .foregroundStyle(redmode ? .red : .blue)
                            
                        }
                        
                        
                    }
                }
            if searchmode == true{
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
            }
            if searchmode == false{
                
                
                if tapped == true{
                    Marker(weather?.name ?? "",image:"thermometer.sun.fill", coordinate: centeronend ?? locationViewer.currentcoordinate)
                        .tint(.indigo)
                    
                }
               
            }
            
            if tablemarkeron == true{
                let nameholder =  "(\(tablecoord.latitude)°,\(tablecoord.longitude)°)\n\(String(format: markercolor == .blue ? "%.0f" : (markercolor == .red ? "%.1f" : (markercolor == .green ? "%.0f" : (markercolor == .yellow ? "%.1f" : ""))), markername))"
                Marker(markercolor == .blue ? "\(nameholder)%" : (markercolor == .red ? "\(nameholder)°C" : (markercolor == .green ? "\(nameholder)m" : (markercolor == .yellow ? "\(nameholder)m/s" : ""))),
                           image: markercolor == .blue ? "humidity.fill" : (markercolor == .red ? "thermometer.high" : (markercolor == .green ? "stairs" : (markercolor == .yellow ? "wind" : ""))),
                           coordinate: tablecoord)
                        .tint(markercolor)
            }
            
            if poly > 0 {
              
              
                    ForEach(Range(0...poly-1)){ i in
                        
                        if i > 0 && routemode == false{
                            
                            let stringholder = selectkm ? "\(String(format: "%.3f", distance[i-1]/1000))km": "\(String(format: "%.3f", distance[i-1]))m"
                            
                            Annotation(stringholder, coordinate:midpoint[i-1]){}
                            
                            
                            
                            
                            
                        }
                    
                
                    
                    
                    Annotation("",coordinate:polygonviewer.polycoordinates[i]){
                        ZStack{
                            
                            
                            
                            Circle()
                                .shadow(color:.black,radius: 0.3)
                                .frame(width:18,height:18)
                                .foregroundStyle(.white)
                                .shadow(radius:3)
                                .shadow(radius:2)
                            
                            
                            
                            if i == poly-1{
                                
                                Circle()
                                    .frame(width:4,height:4)
                                    .foregroundStyle(.green)
                                    .shadow(radius:3)
                                    .shadow(radius:2)
                            }
                            else if i == 0 {
                                
                                Circle()
                                
                                    .frame(width:4,height:4)
                                    .foregroundStyle(.black)
                                    .shadow(radius:3)
                                    .shadow(radius:2)
                            }
                            
                            
                            
                            
                            
                            if polylinemode == false && poly > 2 && routemode == false{
                                
                                
                                Text("(\(String(format: "%.3f",i == poly-1 ? firstA :angle[i]))°)")
                                
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                    .bold()
                                    .shadow(color:.black,radius: 0.1)
                                    .shadow(color:.black,radius: 0.2)
                                    .shadow(color:.black,radius: 0.3)
                                    .shadow(color:.black,radius: 0.4)
                                    .shadow(color:.black,radius: 0.5)
                                    .shadow(color:.black,radius: 0.6)
                                
                                    .offset(y:17)
                                
                                
                                
                            }
                        }
                    }
                }
                
                
                if polylinemode == false && polyon == true && routemode == false{
                    
                    
                    let stringholder = selectkm ? "\(String(format: "%.3f", firstD/1000))km": "\(String(format: "%.3f", firstD))m"
                    Annotation(String(stringholder), coordinate:firstC ?? locationViewer.currentcoordinate){}
                    
                    
                    
                    
                    
                    
                }
                if routemode == true && poly > (Int(a) ?? 2)-1 && route.count > 0{
                    
                    
                        ForEach(Range(0...route.count-1)){ i in
                            if route[i] != nil{
                                MapPolyline(route[i]!.polyline)
                                    .stroke(.indigo, lineWidth:4)
                            }
                          
                        
                    }
                }
                
                
                if routemode == false {
                    if polylinemode == true || poly == 2 {
                        if poly > (Int(a) ?? 2)-1 {
                            MapPolyline(MKPolyline(coordinates: polygonviewer.polycoordinates, count: poly))
                                .stroke(satellitebutton ? .white : .black, lineWidth: 3)
                        }
                    }
                }
            }
            if poly > (Int(a) ?? 3)-1 {
              
                    if polylinemode == false && routemode == false{
                        MapPolygon(coordinates: polygonviewer.polycoordinates)
                            .stroke(satellitebutton ? .white : .black, lineWidth: 2)
                            .foregroundStyle(satellitebutton ? .white.opacity(0.1) : .black.opacity(0.1))
                    }
                        
                
            }
            
 
           
          
        
            
         
        }
        
        
        
        
        
        
        .mapStyle(hybridmode)
           
        
        
        .overlay(alignment: .top){
            HStack{
                Button(action:{
                    showdate.toggle()
                },label:{
            
                        
                        Text("\(Date().formatted(.dateTime.hour().minute()))")
                            .fontWidth(.expanded)
                            .bold()
                            .italic()
                            .fontWidth(.expanded)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .frame(width:90, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    
                })
                
                .popover(isPresented: $showdate){
                    Text("\(Date().formatted(.dateTime.day().month().year().hour().minute().second()))")
                        .fontWidth(.expanded)
                        .bold()
                        .italic()
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)
                        .frame(width:200, height: 55)
                       
                        .shadow(radius: 20)
                }
               
                
                Button(action:{
                    locationViewer.checklocationservices()
                    withAnimation{
                        locationbuttonpressed = true
                        markeron.toggle()
                        
                    }
                    
                  
                    
                    
                    
                    
                    
                }, label:{
                    
                    if markeron == true {
                        Image(systemName: "shareplay")
                            .foregroundStyle(.blue, .red)
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
                    withAnimation{
                        placeredmode = false
                    }
                    cameraPosition = .region (MKCoordinateRegion(center: locationViewer.currentcoordinate ,latitudinalMeters: 12500,longitudinalMeters: 12500))
                    if markeron == true{
                        Task{
                            do{
                                weather = try await weathermanager.getWeather(loc: locationViewer.currentcoordinate)
                                weatherfound = true
                                let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)
                            }catch{
                                print("error")
                            }
                        }
                        
                    }
                    shownewscreen.toggle()
                },label:{
                    if markeron == true{
                        Image(systemName: "homekit")
                            .foregroundStyle(.black, .blue,.red)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    } else {
                        Text("")
                        
                    }
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
                            .onSubmit(){
                                mapselection = nil
                                withAnimation{
                                    placeredmode = false
                                }
                                Task { await searchplace()}
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation{
                                        placeredmode = false
                                    }
                                }
                            }
                        
                        
                        Button(action: {
                            
                            mapselection = nil
                            withAnimation{
                                placeredmode = false
                            }
                            Task { await searchplace()}
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation{
                                    placeredmode = false
                                }
                            }
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
                if searchmode == true && Destinationlocation.isEmpty == false {
                    Button(action:{
                        withAnimation{
                        mapselection = nil
                        
                        
                           searchText = ""
                        }
                        
                        placeredmode = false
                        if locationbuttonpressed == true{
                            redmode = true
                        }
                        Destinationlocation.removeAll()
                        Task{
                            
                            do{
                               
                                    
                                        weather = try await weathermanager.getWeather(loc:locationViewer.currentcoordinate)
                                        weatherfound = true
                                let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)
                                    
                                    
                                
                                
                            }
                            catch{
                                print("error occured")
                            }
                            
                        }
                
                    },label:{
                        Image(systemName: "bookmark.slash.fill")
                            .foregroundColor(.white)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(placeredmode ? .red : .black))
                            .shadow(radius: 20)
                        
                    })
                }
                Spacer()
            
                Button(action:{
                    if placeredmode == true{
                        let placemark = Destinationlocation[0].placemark
                        Task{
                           
                            do{
                               
                                    
                                        weather = try await weathermanager.getWeather(loc: placemark.coordinate )
                                        weatherfound = true
                                    
                                let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)
                                       
                                    
                                
                                
                            }
                            catch{
                                print("error occured")
                            }
                            
                        }
                    }
                    else{
                        Task{
                            
                            do{
                                if mapselection == nil{
                                   
                                        weather = try await weathermanager.getWeather(loc: tapped == false ? locationViewer.currentcoordinate : centeronend!)
                                     
                                        
                                   
                                    weatherfound = true
                                    let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                       let dateFormatter = DateFormatter()
                                       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                   dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                    dateString = dateFormatter.string(from: dateInTimeZone!)
                                }
                                
                            }
                            catch{
                                print("error occured")
                            }
                            
                        }
                    }
                    shownewscreen.toggle()
                    if locationbuttonpressed == true && searchmode == true && placeredmode == false {
                        redmode = true
                        
                    }
                   
                  
                    
                   
                    
                },label:{
                    
                    if weatherfound == true{
                        switch("\(weather!.weather[0].description)"){
                        case "clear sky":
                            HStack{
                                Image(systemName: "sun.max.fill")
                                    .foregroundStyle(.yellow)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.8))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "few clouds","overcast clouds":
                            HStack{
                                Image(systemName: "cloud.sun.fill")
                                    .foregroundStyle(.gray,.yellow)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.8))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                        case "scattered clouds":
                            HStack{
                                Image(systemName: "cloud.fill")
                                    .foregroundStyle(.gray)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.8))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "broken clouds":
                            HStack{
                                Image(systemName: "smoke.fill")
                                    .foregroundStyle(.gray)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.8))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "shower rain","heavy intensity rain":
                            HStack{
                                Image(systemName: "cloud.heavyrain.fill")
                                    .foregroundStyle(.gray,.blue)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.8))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "rain","light rain","moderate rain","light intensity shower rain","light intensity drizzle","light intensity drizzle rain":
                            HStack{
                                Image(systemName: "cloud.sun.rain.fill")
                                    .foregroundStyle(.gray,.yellow,.blue)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.8))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "thunderstorm":
                            HStack{
                                Image(systemName: "cloud.bolt.fill")
                                    .foregroundStyle(.gray,.yellow)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.7))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "snow","light snow":
                            HStack{
                                Image(systemName: "cloud.snow.fill")
                                    .foregroundStyle(.gray,.gray)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.7))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                        case "mist","haze","fog":
                            HStack{
                                Image(systemName: "cloud.fog.fill")
                                    .foregroundStyle(.gray,.brown)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.7))
                            }
                            .frame(width:190, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                        default:
                            HStack{
                                Image(systemName: "thermometer.sun.fill")
                                    .foregroundStyle(.red,.yellow,.black)
                                Text(weather!.weather[0].description)
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(searchmode ? .black.opacity(0.7) : .indigo.opacity(0.7))
                            }
                                .frame(width:190, height: 55)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                        }
                    }else{
                        Image(systemName: "thermometer.sun.fill")
                            .foregroundStyle(.red,.yellow,.black)
                            .frame(width:55, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                        
                    
                })
                .popover(isPresented: $shownewscreen ){
                    
                    if weather != nil{
                        newscreen(weather: weather!,dateString:$dateString,searchmode:$searchmode)
                            
                    }
                    
                }
               
             
                Button(action:{
                    withAnimation{
                        searchmode.toggle()
                    }
                    if tapped == true{
                        tapped = false
                        Task{
                            do{
                                
                                    weather = try await weathermanager.getWeather(loc: locationViewer.currentcoordinate)
                                    weatherfound = true
                                    
                                let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)
                                    
                                
                                
                            }
                            catch{
                                print("error occured")
                            }
                            
                        }
                    }
                    if searchmode == false{
                        mapselection = nil
                       redmode = false
                        withAnimation{
                            placeredmode = false
                        }
                        tapped = true
                        
                        Task{
                            do{
                                
                                    weather = try await weathermanager.getWeather(loc: centeronend ?? locationViewer.currentcoordinate)
                                    weatherfound = true
                                
                                let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)
                            }
                            catch{
                                print("error occured")
                            }
                            
                        }
                        
                    }
                    else{
                        if locationbuttonpressed == true {
                            redmode = true
                        }
                        withAnimation{
                            placeredmode = false
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
                      
                        Text("CenterCast")
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
                    a = "99"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                        a = ""
                    }

                    
                }, label: {
                    if satellitebutton == true{
                        Image(systemName: "square.2.layers.3d.bottom.filled")
                            .foregroundColor(.white)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                            .shadow(radius: 20)
                    }else{
                        Image(systemName: "square.2.layers.3d.top.filled")
                            .foregroundColor(.gray)
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                    
                })
             
            }
            .padding(.horizontal)
            .padding(.top,10)
        
       
            
            
                
                
                
            
                
            }
        
        .overlay(alignment:.center){
        
                if satellitebutton == true{
                    Image(systemName: "plus.viewfinder")
                    
                        .foregroundColor(.white)
                }else{
                    Image(systemName: "plus.viewfinder")
                }
          
               

         
                
        }
        .onChange(of:amount){
            tablecontent = []
            analyzed = false
        }
        .overlay(alignment:.bottom){
            HStack{
                Spacer()
                
                Button(action:{
                    
                    
                },label:{
                    let txttemplat = String(format: "%.3f",centerlocation?.latitude ?? locationViewer.currentcoordinate.latitude)
                    let txttemplong = String(format: "%.3f",centerlocation?.longitude ?? locationViewer.currentcoordinate.longitude)
                    let txttempalt = String(format: "%.0f",elevation?.elevation[0] ?? 0,0)
                    
                        Text("\(txttemplat)° , \(txttemplong)° / \(txttempalt)m")
                            .fontWidth(.expanded)
                            .font(.footnote)
                            .foregroundStyle(.black)
                        
                            .frame(width:300, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    
                    
                })
                .offset(y:-10)
               
       
               
              
                Button(action:{
                    withAnimation{
                        if polylinemode == true {
                            route = []
                            getroute()
                            routemode = true
                            polylinemode = false
                          
                        }
                        else{
                            if routemode == true  {
                                routemode = false
                            }
                            else{
                                polylinemode = true
                            }
                        }
                    }
                },label:{
                    if polylinemode == false{
                       
                        Image(systemName: routemode ? "flag.and.flag.filled.crossed" :"point.3.filled.connected.trianglepath.dotted")
                        
                            .foregroundStyle(.black,.green)
                        
                            .frame(width:55, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                            
                    }
                    else{
                        Image(systemName: "point.bottomleft.filled.forward.to.point.topright.scurvepath")
                        
                            .foregroundStyle(.black,.green)
                        
                            .frame(width:55, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    }
                })
                .offset(y:-10)
                
                Button(action:{
                   
                    polygonviewer.createpoly(coordinate1:centerlocation!)
                    withAnimation{
                        poly += 1
                        
                        if poly > 1{
                            distance.append(distancecalc(coord1:polygonviewer.polycoordinates[poly-1],coord2:polygonviewer.polycoordinates[poly-2])*1000)
                            
                            let latmid = (polygonviewer.polycoordinates[poly-1].latitude + polygonviewer.polycoordinates[poly-2].latitude)/2
                            let longmid = (polygonviewer.polycoordinates[poly-1].longitude + polygonviewer.polycoordinates[poly-2].longitude)/2
                            midpoint.append(CLLocationCoordinate2D(latitude:latmid, longitude: longmid))
                        }
                        if poly > 2{
                            total -= firstD
                        }
                        if poly > (Int(a) ?? 3)-1 {
                            polyon = true
                            
                            
                            firstD = distancecalc(coord1:polygonviewer.polycoordinates[poly-1],coord2:polygonviewer.polycoordinates[0])*1000
                            total += firstD
                            let latmid = (polygonviewer.polycoordinates[poly-1].latitude + polygonviewer.polycoordinates[0].latitude)/2
                            let longmid = (polygonviewer.polycoordinates[poly-1].longitude + polygonviewer.polycoordinates[0].longitude)/2
                            firstC = CLLocationCoordinate2D(latitude:latmid, longitude: longmid)
                        }
                        a = "99"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                            a = ""
                        }
                        if distance.count > 1 {
                            
                            
                            let firstThird = distancecalc(coord1: polygonviewer.polycoordinates[1], coord2: polygonviewer.polycoordinates[poly-1])*1000
                            angle[0] = cosineTheoremForAngle(a: distance[0], b: firstD, c: firstThird)!
                            let third = distancecalc(coord1: polygonviewer.polycoordinates[poly-1], coord2: polygonviewer.polycoordinates[poly-3])*1000
                            angle.append(cosineTheoremForAngle(a:distance[poly-2] , b: distance[poly-3], c:third )!)
                            
                            let firstendthird = distancecalc(coord1: polygonviewer.polycoordinates[0], coord2: polygonviewer.polycoordinates[poly-2])*1000
                            firstA = cosineTheoremForAngle(a: distance[poly-2], b: firstD, c: firstendthird)!
                        }
                        if poly > 1{
                            total += distance[poly-2]
                           
                        }
                        regionarea = regionArea(locations: polygonviewer.polycoordinates)
                        
                    }
                   
                    tablemarkeron = false
                    tablecontent = []
                    analyzed = false
                    if routemode == true{
                        route = []
                        getroute()
                    }
                
                  
                },label:{
                    Image(systemName: "scope")
                    
                        .foregroundStyle(.green)
                    
                        .frame(width:100, height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                })
                .offset(y:-10)
           //MARK: ANALYTICS BUTTON
                if (poly == 2){
                    TextField("Segment",text: $amount)
                        .font(.subheadline)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding(1)
                        .shadow(radius:20)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100, height: 100)
                        .offset(y:-10)
                        .onSubmit{
                            if analyzed == false{
                                if Double(amount) ?? 13 > 46 {
                                    amount = "46"
                                }
                                if Double(amount) ?? 13 == 0 {
                                    amount = "100"
                                }

                                
                                
                                Loading = true
                                Task {
                                    do {
                                        try await fetchDataFromServer()
                                        showanalytics.toggle()
                                        Loading = false
                                    } catch {
                                        print("Error fetching data from server: \(error)")
                                    }
                                }
                                
                            }
                            else{
                                showanalytics.toggle()
                            }
                        }
                    
                }
              
                    Button(action:{
                        if analyzed == false{
                            if Double(amount) ?? 13 > 46 {
                                amount = "46"
                            }
                            if Double(amount) ?? 13 == 0 {
                                amount = "100"
                            }

                            
                            
                            Loading = true
                            Task {
                                do {
                                    try await fetchDataFromServer()
                                    showanalytics.toggle()
                                    Loading = false
                                } catch {
                                    print("Error fetching data from server: \(error)")
                                }
                            }
                            
                        }
                        else{
                            showanalytics.toggle()
                        }
                      
                        
                    },label:{
                        if poly > 1 {
                            if Loading == false {
                                
                                
                                Image(systemName: "waveform.path.ecg.rectangle.fill")
                                    .foregroundStyle(.black)
                                    .frame(width:55,height: 55)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .shadow(radius: 20)
                            }
                            else{
                                Image(systemName: "wifi.router.fill")
                                    .foregroundStyle(.green)
                                    .frame(width:55,height: 55)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .shadow(radius: 20)
                            }
                        }
                        else{
                            Text("")
                        }
                        
                    })
                    .fullScreenCover(isPresented: $showanalytics){
                        AnalyticsView(cameraposition:$cameraPosition, tablecontent: $tablecontent,showanalytics:$showanalytics,amount:$amount,tablecoord:$tablecoord,tablemarkeron:$tablemarkeron,markercolor: $markercolor,markername:$markername,poly:$poly)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    }
                    
                
                
             
                    .offset(y:-10)
                if poly != 0{
                    Button(action:{
                        withAnimation{
                            polygonviewer.deletelast()
                            
                            if poly > 0{
                                poly = poly-1
                                
                            }
                            if poly > 1 {
                                
                                total = total - firstD
                                
                            }
                            if distance.count > 0{
                                total -= distance[poly-1]
                                
                                
                                
                                distance.removeLast()
                            }
                            
                            
                            if midpoint.count > 0 {
                                midpoint.removeLast()
                            }
                            
                            if poly > 2{
                                
                                angle.removeLast()
                            }
                            if route.count > 0 {
                                route = []
                                getroute()
                            }
                            
                            
                            firstA = 0.0
                            firstD = 0.0
                            firstC = nil
                            polyon = false
                            if poly == 2{
                                angle = []
                                angle.append(0)
                            }
                            if poly > (Int(a) ?? 3)-1 {
                                polyon = true
                                
                                
                                firstD = distancecalc(coord1:polygonviewer.polycoordinates[poly-1],coord2:polygonviewer.polycoordinates[0])*1000
                                
                                let latmid = (polygonviewer.polycoordinates[poly-1].latitude + polygonviewer.polycoordinates[0].latitude)/2
                                let longmid = (polygonviewer.polycoordinates[poly-1].longitude + polygonviewer.polycoordinates[0].longitude)/2
                                firstC = CLLocationCoordinate2D(latitude:latmid, longitude: longmid)
                            }
                            
                            
                            regionarea = regionArea(locations: polygonviewer.polycoordinates)
                            
                            a = "99"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                
                                a = ""
                                
                            }
                            if distance.count > 1 {
                                
                                let firstendthird = distancecalc(coord1: polygonviewer.polycoordinates[0], coord2: polygonviewer.polycoordinates[poly-2])*1000
                                firstA = cosineTheoremForAngle(a: distance[poly-2], b: firstD, c: firstendthird)!
                                let firstThird = distancecalc(coord1: polygonviewer.polycoordinates[1], coord2: polygonviewer.polycoordinates[poly-1])*1000
                                angle[0] = cosineTheoremForAngle(a: distance[0], b: firstD, c: firstThird)!
                                
                            }
                            if poly > 1 {
                                
                                total += firstD
                                
                            }
                            
                            tablemarkeron = false
                            tablecontent = []
                            analyzed = false
                            
                            
                            
                            
                        }
                        
                    },label:{
                        Image(systemName: "arrowshape.turn.up.backward.2.fill")
                        
                            .foregroundStyle(.red)
                        
                            .frame(width:55, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    })
                    .offset(y:-10)
                    
                    Button(action:{
                        withAnimation{
                            poly = 0
                            polygonviewer.clearpoly()
                           
                            midpoint = []
                            distance = []
                            total = 0.0
                     
                            
                            polyon = false
                            a = ""
                            angle = []
                            angle.append(0)
                            firstA = 0.0
                            regionarea = regionArea(locations: polygonviewer.polycoordinates)
                            firstD = 0
                            tablemarkeron = false
                            tablecontent = []
                            analyzed = false
                            
                            route = []
                        
                        }
                    }, label:{
                        Image(systemName: "trash.fill")
                        
                            .foregroundStyle(.red)
                        
                            .frame(width:55, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                    })
                    .offset(y:-10)
                    Button(action:{
                        showselectionscreen.toggle()
                    },label:{
                        if polylinemode == false && routemode == false{
                            
                            let stringholder = String(format:"%.3f",total) + "m"
                            let stringholderarea = String(format:"%.3f",regionarea) + "m2"
                            let stringholderkm = String(format:"%.3f",total/1000) + "km"
                            let stringholderkmarea = String(format:"%.3f",regionarea/1000000) + "km2"
                            
                            
                            if selectkm == false{
                               
                                Text("Perimeter:\(stringholder)\nArea:\(stringholderarea)")
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(.black)
                                
                                    .frame(width:250, height: 55)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .shadow(radius: 20)
                                
                            }
                            else{
                                Text("Perimeter:\(stringholderkm)\nArea:\(stringholderkmarea)")
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(.black)
                                
                                    .frame(width:250, height: 55)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .shadow(radius: 20)
                            }
                        }
                        if polylinemode == true{
                            let stringholder = String(format:"%.3f",total - firstD) + "m"
                            let stringholderkm = String(format:"%.3f",(total-firstD)/1000) + "km"
                            if selectkm == true{
                                Text("Length:\(stringholderkm)")
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(.black)
                                
                                    .frame(width:250, height: 55)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .shadow(radius: 20)
                            }
                            else{
                                Text("Length:\(stringholder)")
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .foregroundStyle(.black)
                                
                                    .frame(width:250, height: 55)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .shadow(radius: 20)
                            }
                        }
                        if routemode == true{
                            let stringholder = selectkm ? String(format:"%.3f",(routelength ?? 0)/1000) + "km" : String(format:"%.0f",routelength ?? 0) + "m"
                            Text("Route Length:\(stringholder)")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.black)
                            
                                .frame(width:250, height: 55)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                        }
                    })
                    .offset(y:-10)
                    .popover(isPresented: $showselectionscreen){
                        
                        SelectionScreen(selectkm: $selectkm)
                        
                    }
                }
                Spacer()
              
                Button(action:{
                    let firebaseAuth = Auth.auth()
                                    do {
                                        try firebaseAuth.signOut()
                                        withAnimation {
                                            userid = ""
                                        }
                                    } catch let signOutError as NSError {
                                        print("Error signing out: %@", signOutError)
                                    }
                }, label:{
                    Image(systemName: "person.fill.badge.minus")
                        
                        .foregroundStyle(.red)
                        
                    
                        .frame(width:20, height: 20)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.red))
                        .shadow(radius: 20)
                        .offset(x:-28,y:-10)
                        
                })
            }
            .padding(10)
            .offset(x:20)
                
        }
        .mapControls{
         
                
            MapScaleView()
           
            
        }
        
        
       
        .onMapCameraChange(frequency: .continuous, { newcamera in
            centerlocation = newcamera.region.center
        
            
            
        })
        .onMapCameraChange(frequency: .onEnd, { newcamera in
            centeronend = newcamera.region.center
            if tapped == true{
                Task{
                    do{
                        if mapselection == nil{
                            
                            
                            weather = try await weathermanager.getWeather(loc: centeronend ?? locationViewer.currentcoordinate)
                            weatherfound = true
                            let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                               let dateFormatter = DateFormatter()
                               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                           dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                            dateString = dateFormatter.string(from: dateInTimeZone!)
                            
                        }
                        
                        
                    }
                    catch{
                        print("error occured")
                    }
                    
                }
            }
                Task{
                                
                                    elevation  = try await elevationmanager.getElevation(loc: CLLocationCoordinate2D(latitude: centeronend?.latitude ?? locationViewer.currentcoordinate.latitude, longitude: centeronend?.longitude ?? locationViewer.currentcoordinate.longitude))
                                }
                
               
                
            

            
        
         
            
        })
        .onChange(of:mapselection,{oldValue, newValue in
            let placemark = mapselection?.placemark
            redmode = false
            withAnimation{
                placeredmode = true
            }
            
            if popupshowedbefore == false{
                if placemark != nil{
                    Task{
                        do{
                            weather = try await weathermanager.getWeather(loc:placemark!.coordinate  )
                            weatherfound = true
                            let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                               let dateFormatter = DateFormatter()
                               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                           dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                            dateString = dateFormatter.string(from: dateInTimeZone!)
                            
                            
                        }
                        catch{
                            print("error occured")
                        }
                    }
                }
                
                
                
                
                shownewscreen.toggle()
                popupshowedbefore = true
            }
            else {
                popupshowedbefore = false
            }
            
        })
       
        
        
      
        
    }
        
}
// MARK: ANALYTICSVIEW
struct AnalyticsView: View {
    @Binding var cameraposition: MapCameraPosition
    @Binding var tablecontent : [Analytics]
    @Binding var showanalytics: Bool
    @Binding var amount : String
    @Binding var tablecoord : CLLocationCoordinate2D
    @Binding var tablemarkeron : Bool
    @Binding var markercolor : Color
    @Binding var markername : Double
    @Binding var poly : Int
    var body: some View {
        HStack{
            Text(poly > 2 ? "Multipoint Analytics" : " Segmented Analytics;")
        
            .fontWidth(.expanded)
            .font(.title)
            .bold()
        
            .foregroundStyle(.black.opacity(0.7))
            .shadow(radius: 20)
            .frame(alignment: .leading)
            .padding(.top,15)
            .padding(.horizontal,15)
        Spacer()
            Button(action:{
                showanalytics = false
            },label: {
                Image(systemName:"waveform.path.ecg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.black.opacity(0.7))
                    .padding(.top,15)
                    .padding(.horizontal,15)
                    
                    .frame(width: 75, height: 75)
            })
      
    }
        VStack{
            Text("Latitude, Longitude in Degrees/ Temperature in °C")
                
                .fontWidth(.expanded)
                .font(.subheadline)
                .bold()
            
                .foregroundStyle(.black.opacity(0.7))
                .shadow(radius: 20)
            
                Chart(tablecontent){ content in
                    
                    LineMark(x: .value("first" , "\(content.lat)\n\(content.lng)"),
                             y: .value("second" , content.temp)
                    )
                    
                    .foregroundStyle(.red)
                    
                    PointMark(x: .value("first" , "\(content.lat)\n\(content.lng)"),
                              y: .value("second" , content.temp)
                    )
                    .symbol(BasicChartSymbolShape.circle)
                    .foregroundStyle(.red)
                }
            
            
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
             
                            .onTapGesture { location in
                                    
                                  
                                   
                                
                                    let (coord, _) = proxy.value(at: location, as: (String, Double).self)!
                                    markername = tablecontent.first(where: { $0.lat == convertStringToCLLocationCoordinate(coord)!.latitude })!.temp
                                        markercolor = .red
                                        tablecoord = convertStringToCLLocationCoordinate(coord)!
                                        tablemarkeron = true
                                        showanalytics = false
                                    cameraposition = .region (MKCoordinateRegion(center: tablecoord,latitudinalMeters: 5000,longitudinalMeters: 5000))
                                       
                                   
                                    
                                }
 
                  
                    
                }
           
            }
            
         
        }
        .padding(10)
        Spacer()
            
        VStack{
            Text("Latitude, Longitude in Degrees/ Elevation in meters")
                .fontWidth(.expanded)
                .font(.subheadline)
                .bold()
            
                .foregroundStyle(.black.opacity(0.7))
                .shadow(radius: 20)
            Chart(tablecontent){ content in
                LineMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                         y: .value("second" , content.elev)
                )
                
                .foregroundStyle(.green)
              
                    PointMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                              y: .value("second" , content.elev)
                    )
                    .symbol(BasicChartSymbolShape.diamond)
                    .foregroundStyle(.green)
                
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                                  
                                   
                                    let (coord, _) = proxy.value(at: location, as: (String, Double).self)!
                                    markername = tablecontent.first(where: { $0.lat == convertStringToCLLocationCoordinate(coord)!.latitude })!.elev
                                     markercolor = .green
                                        tablecoord = convertStringToCLLocationCoordinate(coord)!
                                        tablemarkeron = true
                                        showanalytics = false
                                    cameraposition = .region (MKCoordinateRegion(center: tablecoord,latitudinalMeters: 5000,longitudinalMeters: 5000))
                                   
                                    
                                }
                                
                        
                  
                    
                }
           
            }
        }
        .padding(10)
        Spacer()
        VStack{
            Text("Latitude, Longitude in Degrees/ Humidity in %")
                .fontWidth(.expanded)
                .font(.subheadline)
                .bold()
            
                .foregroundStyle(.black.opacity(0.7))
                .shadow(radius: 20)
            Chart(tablecontent){ content in
                LineMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                         y: .value("second" , content.hum)
                )
                
                .foregroundStyle(.blue)
              
                    PointMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                              y: .value("second" , content.hum)
                    )
                    .symbol(BasicChartSymbolShape.square)
                    .foregroundStyle(.blue)
                
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                                    let (coord, _) = proxy.value(at: location, as: (String, Double).self)!
                                    markername = tablecontent.first(where: { $0.lat == convertStringToCLLocationCoordinate(coord)!.latitude })!.hum
                                     markercolor = .blue
                                        tablecoord = convertStringToCLLocationCoordinate(coord)!
                                        tablemarkeron = true
                                        showanalytics = false
                                    cameraposition = .region (MKCoordinateRegion(center: tablecoord,latitudinalMeters: 5000,longitudinalMeters: 5000))
                                   
                                    
                                }
                                
                        
                  
                    
                }
           
            }
        }
        Spacer()
            
        VStack{
            Text("Latitude, Longitude in Degrees/ Wind Speed in m/s")
                .fontWidth(.expanded)
                .font(.subheadline)
                .bold()
            
                .foregroundStyle(.black.opacity(0.7))
                .shadow(radius: 20)
            Chart(tablecontent){ content in
                LineMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                         y: .value("second" , content.wind)
                )
                
                .foregroundStyle(.yellow)
              
                    PointMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                              y: .value("second" , content.wind)
                    )
                    .symbol(BasicChartSymbolShape.triangle)
                    .foregroundStyle(.yellow)
                
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                                  
                                   
                                    let (coord, _) = proxy.value(at: location, as: (String, Double).self)!
                                    markername = tablecontent.first(where: { $0.lat == convertStringToCLLocationCoordinate(coord)!.latitude })!.wind
                                     markercolor = .yellow
                                        tablecoord = convertStringToCLLocationCoordinate(coord)!
                                        tablemarkeron = true
                                        showanalytics = false
                                    cameraposition = .region (MKCoordinateRegion(center: tablecoord,latitudinalMeters: 5000,longitudinalMeters: 5000))
                                   
                                    
                                }
                                
                        
                  
                    
                }
           
            }
        }
        .padding(10)
            
            
        
       
    }
  
}

  
 
struct SelectionScreen:View{
    @Binding var selectkm :Bool
    var body:some View{
            VStack{
                Button(action:{
                  selectkm = true
                },label:{
                    Text("Kilometer")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)
                    
                        .frame(width:120, height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                })
                Button(action:{
                   selectkm = false
                },label:{
                    Text("Meter")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)
                    
                        .frame(width:120, height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                })
            }
        
    }
}
// MARK: newscreen
struct newscreen:View{
    @State var weather:ResponseBody
    var elevationmanager = ElevationManager()
    @Binding var dateString : String?
    var weathermanager = WeatherManager()
    @Binding var searchmode : Bool
    @State var elevation : ResponseBody2?
    @State var hweather : ResponseHourly?
    @State var dweather : ResponseDaily?
    @State var showdetailsscreen : Bool = false
    @State var alpha : Int = 0
   
    var body:some View{
       
        ZStack{
            HStack(alignment:.top){
            Spacer()
                VStack{
                    Spacer()
                
                       Text(weather.sys.country ?? "")
                            .bold()
                            .font(.headline)
                            .fontWidth(.expanded)
                            .textCase(.uppercase)
                    
                        
                    Button(action:{
                        Task{
                            do{
                                hweather =  try await weathermanager.gethourlyWeather(loc: CLLocationCoordinate2D(latitude:weather.coord.lat, longitude:weather.coord.lon))
                                
                                dweather =  try await weathermanager.getdailyWeather(loc:CLLocationCoordinate2D(latitude:weather.coord.lat, longitude:weather.coord.lon))
                                alpha = 21 - ((hweather!.list[0].dt % 86400)/3600)
                                print(alpha)
                                showdetailsscreen.toggle()
                                
                            }
                            catch{
                                print("error")
                            }
                            
                        }
                      
                            
                    },label:{
                        
                        Image(systemName: "pip.enter")
                            .offset(x:5,y:-15)
                        Text(weather.name == "" ? "(N/A)": weather.name)
                            .bold()
                            .font(.largeTitle)
                            .fontWidth(.expanded)
                            .textCase(.uppercase)
                            .padding(.bottom,weather.name == "" ? 10 : 0)
                            
                        
                    })
                    .foregroundStyle(searchmode ? .red :.indigo)
                    .fullScreenCover(isPresented: $showdetailsscreen){
                        DetailsView(showdetailsscreen:$showdetailsscreen ,hweather:$hweather,weather:$weather, dateString: $dateString,elevation: $elevation,dweather:$dweather,alpha:$alpha,searchmode:$searchmode)
                    }
                    
                    Text("(\(String(format:"%.3f", weather.coord.lat))°, \(String(format:"%.3f", weather.coord.lon))°/\(String(format:"%.0f",(elevation?.elevation[0]) ?? 0.0))m)")
                        .bold()
                        .font(.subheadline)
                        .fontWidth(.expanded)
                    
                    Text(dateString ?? "")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption)
                    Spacer()
                    
                }
                
                Spacer()
                VStack{
                    Spacer()
                    Text("\(String(format:"%.1f",Double(weather.main.temp-273.15)))°C")
                        .fontWidth(.expanded)
                        .bold()
                        .font(.system(size: 33))
                        .padding(-2)
                    HStack{
                        Text("(Feels Like \(String(format:"%.1f",Double(weather.main.feelsLike-273.15)))°C)")
                            .fontWidth(.expanded)
                            
                            .font(.footnote)
                            
                            
                    }
                
                    HStack{
                        Text("Min:\(String(format:"%.1f",Double(weather.main.tempMin-273.15)))°C")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.footnote)
                        Text("Max:\(String(format:"%.1f",Double(weather.main.tempMax-273.15)))°C")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.footnote)
                        
                    }
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading){
                    Spacer()
                    HStack{
                        Image(systemName: "humidity.fill")
                        Text("\(String(weather.main.humidity))%")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                            
                    }
                    .padding(1)
                    HStack{
                        Image(systemName: "wind")
                        Text("\(String(format:"%.1f",weather.wind.speed))m/s")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                            
                    }
                    .padding(1)
                    HStack{
                        Image(systemName: "cloud.fill")
                        Text("\(String(weather.clouds.all))%")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                    }
                        .padding(1)
                    HStack{
                        Image(systemName: "umbrella.fill")
                        Text("\(String(weather.rain?.oneHour ?? 0))mm")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                    }
                        .padding(1)
                    HStack{
                        Image(systemName: "sunrise.fill")
                        Text(String(convertsun(sunvalue: weather.sys.sunrise, sunzone: weather.timezone)))
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                           
                    }
                        .padding(1)
                    HStack{
                        Image(systemName: "sunset.fill")
                        Text(String(convertsun(sunvalue: weather.sys.sunset, sunzone: weather.timezone)))
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                    }
                        .padding(1)
                 
                   
                    Spacer()
                }
                
             
                  
                Spacer()
                    
                  
                    
                    // MARK: Causes performance issues - Alternative above
                    
                    /* Text("Wind:\(String(format:"%.1f",weather.wind.speed))(\(String(weather.wind.gust)))m/s")
                     .fontWidth(.expanded)
                     .bold() */
                    
                   
               
                
                
                      
                    
                
                
               
            }
            
            
        }
        .onAppear {
                   Task {
                           elevation = try await elevationmanager.getElevation(loc: CLLocationCoordinate2D(latitude: weather.coord.lat, longitude: weather.coord.lon))
                   }
               }
       
        
        .frame(minWidth: 615,minHeight: 190)
        .padding(10)
              
            
    }
    // MARK: Causes performance issues (havent removed)
    func convertsun(sunvalue:Int,sunzone:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(sunvalue))
        let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: sunzone)
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
    }
}

class polygonViewer: ObservableObject{
    @Published var polycoordinates : [CLLocationCoordinate2D] = [ ]
    func deletelast(){
        if polycoordinates.count > 0 {
            polycoordinates.removeLast()
        }
    }
    
    func createpoly(coordinate1:CLLocationCoordinate2D){
        polycoordinates.append(coordinate1)
        
           
    }
                            func clearpoly(){
                                self.polycoordinates = []
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
        let apiKey = "313317ad4e64155d5ee8a3481865ee8b"
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
        let apiKey = "313317ad4e64155d5ee8a3481865ee8b"
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
        let apiKey = "313317ad4e64155d5ee8a3481865ee8b"
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
        let apiKey = "313317ad4e64155d5ee8a3481865ee8b"
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
class ElevationManager{
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
       /* let deg : Int
          let gust : Double */
       
    }
}

// Update the computed properties for MainResponse
extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }

}
// MARK: extension
extension ContentView{
    func getroute(){
           
           routelength = 0
        if poly > 1 {
            
        for i in 1...poly-1{
            Task{
                
                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: .init(coordinate: polygonviewer.polycoordinates[i-1]))
                    request.destination = MKMapItem(placemark: .init(coordinate: polygonviewer.polycoordinates[i]))
                   // request.transportType = MKDirectionsTransportType(arrayLiteral: .walking)
                    let result = try? await MKDirections(request: request).calculate()
                    route.append(result?.routes.first)
                if result?.routes.first?.distance != nil{
                    routelength += (result?.routes.first?.distance)!
                }
                    
                }
            
            
            }
         
        }
       }
    func getCurrentDateInTimeZone(secondsFromGMT: Int) -> Date? {
        let timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        var calendar = Calendar.current
        calendar.timeZone = timeZone ?? TimeZone.current // Use the specified time zone, or fallback to the current system time zone
        
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        
        return calendar.date(from: components)
    }
    func fetchDataFromServer() async throws {
        
        
        let incrementlat = (polygonviewer.polycoordinates[1].latitude - polygonviewer.polycoordinates[0].latitude) / (Double(amount) ?? 13)
        let incrementlong = (polygonviewer.polycoordinates[1].longitude - polygonviewer.polycoordinates[0].longitude) / (Double(amount) ?? 13)
        analyzed = true
        if poly < 3 {
            for (lat, long) in zip(stride(from: polygonviewer.polycoordinates[0].latitude, through: polygonviewer.polycoordinates[1].latitude, by: incrementlat), stride(from: polygonviewer.polycoordinates[0].longitude, through: polygonviewer.polycoordinates[1].longitude, by: incrementlong)) {
                let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                do {
                    let weatherData = try await weathermanager.getOptimizedWeather(loc: location)
                    let elevationData = try await elevationmanager.getElevation(loc: location)
                    
                    tablecontent.append(Analytics(
                        lat: Double(String(format: "%.3f", lat))!,
                        lng: Double(String(format: "%.3f", long))!,
                        temp: (weatherData.main.temp - 273.15),
                        elev: elevationData.elevation[0],
                        hum: Double(weatherData.main.humidity),
                        wind: weatherData.wind.speed)
                    )
                } catch {
                    print("error occurred")
                }
            }
        }
    
    else {
        for coordinate in polygonviewer.polycoordinates{
          
            
            do {
                let weatherData = try await weathermanager.getOptimizedWeather(loc: coordinate)
                let elevationData = try await elevationmanager.getElevation(loc: coordinate)
                
                tablecontent.append(Analytics(
                    lat: Double(String(format: "%.3f", coordinate.latitude))!,
                    lng: Double(String(format: "%.3f", coordinate.longitude))!,
                    temp: (weatherData.main.temp - 273.15),
                    elev: elevationData.elevation[0],
                    hum: Double(weatherData.main.humidity),
                    wind: weatherData.wind.speed)
                )
            } catch {
                print("error occurred")
            }
        }
    }
}
    func radians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {

        guard locations.count > 2 else { return 0 }
        var area = 0.0

        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]

            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        let kEarthRadius = 6378137.0
        area = -(area * kEarthRadius * kEarthRadius / 2)
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }

    func cosineTheoremForAngle(a: Double, b: Double, c: Double) -> Double? {
        // Check if the side lengths form a valid triangle
        if a <= 0 || b <= 0 || c <= 0 || (a + b <= c) || (b + c <= a) || (c + a <= b) {
            return nil
        }
        
        // Calculate the cosine of the angle using the cosine theorem
        let cosAngle = (pow(a, 2) + pow(b, 2) - pow(c, 2)) / (2 * a * b)
        
        // Calculate the angle in radians
        let angleInRadians = acos(cosAngle)
        
        // Convert the angle to degrees and return it
        let angleInDegrees = angleInRadians * (180 / .pi)
        
        return angleInDegrees
    }


    func searchplace() async{
        
        _ = LocationViewer()
        locationViewer.checklocationservices()
        let destination = MKLocalSearch.Request()
        destination.naturalLanguageQuery = searchText
        
        destination.region = MKCoordinateRegion(center: locationViewer.currentcoordinate, latitudinalMeters: 125000, longitudinalMeters: 125000)
        destination.resultTypes = .address
        let Destinationlocation =  try? await MKLocalSearch(request: destination).start()
        self.Destinationlocation = Destinationlocation?.mapItems ?? []
        if self.Destinationlocation.count > 0 {
            cameraPosition = .region (MKCoordinateRegion(center: self.Destinationlocation[0].placemark.coordinate,latitudinalMeters: 12500,longitudinalMeters: 12500))
        }
        
    }
    func distancecalc(coord1:CLLocationCoordinate2D,coord2:CLLocationCoordinate2D)->Double{
       

        let R = 6371.00 /*Earth's radius*/

        // Convert degrees to radians
        let phi1 = coord1.latitude * Double.pi / 180
        let lambda1 = coord1.longitude * Double.pi / 180

        let phi2 = coord2.latitude * Double.pi / 180
        let lambda2 = coord2.longitude * Double.pi / 180

        // Calculate the differences
        let deltaPhi = phi2 - phi1
        let deltaLambda = lambda2 - lambda1

        let a = pow(sin(deltaPhi / 2), 2) + cos(phi1) * cos(phi2) * pow(sin(deltaLambda / 2), 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let d = R * c
        return d
    }


}


extension AnalyticsView {
    func convertStringToCLLocationCoordinate(_ coordinateString: String) -> CLLocationCoordinate2D? {
        // Split the string into latitude and longitude components
        let components = coordinateString.split(whereSeparator: \.isNewline)
        
        guard components.count == 2 else {
            print("Invalid coordinate string format")
            return nil
        }
        
        // Convert latitude and longitude strings to Double values
        if let latitude = Double(components[0].trimmingCharacters(in: .whitespaces)),
           let longitude = Double(components[1].trimmingCharacters(in: .whitespaces)) {
            // Create a CLLocationCoordinate2D object
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return coordinate
        } else {
            print("Invalid latitude or longitude format")
            return nil
        }
    }
}

#Preview {
    ContentView()
}
