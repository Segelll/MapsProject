//  ContentView.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 4.07.2023.
//


import SwiftUI
import SwiftData
import MapKit
import Charts

struct ContentView: View{
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
    @State var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0) ,latitudinalMeters: 120500,longitudinalMeters: 120500))
    @AppStorage("cam") var camerastring1 : String = "0"
    @AppStorage("cam2") var camerastring2 : String = ""
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
    @State var centerlock : Bool = false
    @State var centerlockcoord = CLLocationCoordinate2D(latitude:0,longitude:0)
    @State var showsymbolscreen : Bool = false
    @State var centersymbol : [Symbol] = []
    @State var belowzerotemp : Bool = false
    @State var belowfiftytemp : Bool = false
    @State var belowzeroelev :Bool = false
    @State var showpolyview : Bool = false
    var body :some View{



        Map(position: $cameraPosition, selection:$mapselection){
            if centersymbol.count > 0 {
                ForEach(centersymbol) { symbol in
                    Annotation(symbol.username,coordinate:symbol.coordinate){

                            Image(systemName:symbol.name)
                                .foregroundStyle(satellitebutton ? .white : .black)

                    }
                }
            }
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
                        Marker(placemark.name ?? "",image:"location.magnifyingglass", coordinate:placemark.coordinate)
                            .tint(.gray)

                    }
                    else{
                        Marker(placemark.name ?? "",image:"thermometer.brakesignal", coordinate:placemark.coordinate)
                            .tint(.red.opacity(0.8))
                    }


                }
            }
            if searchmode == false{


                if tapped == true{
                    Marker(weather?.name ?? "",image:centerlock ? "custom.lock.fill.2.badge.checkmark": "thermometer.brakesignal", coordinate:centerlock ? centerlockcoord : centeronend ?? locationViewer.currentcoordinate)
                        .tint(.indigo.opacity(0.8))

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
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .frame(width:90, height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)

                })

                .popover(isPresented: $showdate){
                    Text("\(Date().formatted(date: .complete, time: .omitted) )")
                        .fontWidth(.expanded)
                        .bold()
                        .italic()
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
                                   dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)
                                shownewscreen.toggle()
                            }catch{
                                print("error")
                            }
                        }

                    }

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
                        placeredmode = false
                        withAnimation{
                        mapselection = nil
                        redmode = true

                           searchText = ""
                        }


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
                                   dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
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
                            .background(RoundedRectangle(cornerRadius: 10).fill(placeredmode ? .red.opacity(0.8) : .gray))
                            .shadow(radius: 20)

                    })
                }
                Spacer()

                Button(action:{
                    if placeredmode == true{
                        let placemark = Destinationlocation.count > 0 ? Destinationlocation[0].placemark.coordinate : locationViewer.currentcoordinate
                        Task{

                            do{



                                        weather = try await weathermanager.getWeather(loc: placemark )
                                        weatherfound = true

                                let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)


                                shownewscreen.toggle()

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

                                    weather = try await weathermanager.getWeather(loc: tapped == false ? locationViewer.currentcoordinate : (centerlock ? centerlockcoord :centeronend!))
                                    weatherfound = true
                                    let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                       let dateFormatter = DateFormatter()
                                       dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
                                   dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                    dateString = dateFormatter.string(from: dateInTimeZone!)
                                    shownewscreen.toggle()
                                }


                            }
                            catch{
                                print("error occured")
                            }

                        }
                    }

                    if locationbuttonpressed == true && searchmode == true && placeredmode == false {
                        redmode = true

                    }




                },label:{

                    if weatherfound == true{
                        switch weather!.weather[0].description{
                        case "clear sky":
                            HStack{
                                Image(systemName: "sun.max.fill")
                                    .foregroundStyle(.yellow)
                                Text( weather!.weather[0].description)
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

                        centerlock.toggle()

                    if centerlock == false {
                        Task{
                            do{
                                if mapselection == nil{


                                    weather = try await weathermanager.getWeather(loc: centeronend ?? locationViewer.currentcoordinate)
                                    weatherfound = true
                                    let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                       let dateFormatter = DateFormatter()
                                       dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
                                   dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                    dateString = dateFormatter.string(from: dateInTimeZone!)

                                }


                            }
                            catch{
                                print("error occured")
                            }

                        }
                    }
                    else{
                        centerlockcoord = centeronend ?? locationViewer.currentcoordinate
                    }
                },label:{
                    if searchmode == false{
                        if centerlock == true{
                        Image(systemName: "lock.fill")
                                .foregroundStyle(.indigo.opacity(0.8))
                            .frame(width:55,height: 55)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .shadow(radius: 20)
                              }
                              else{
                            Image(systemName: "lock.open.fill")
                                      .foregroundStyle(.indigo.opacity(0.8))
                                .frame(width:55,height: 55)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                        }
                    } else {
                        Text("")

                    }
                })
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
                                   dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
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


                        Task{
                            do{

                                weather = try await weathermanager.getWeather(loc: centerlock ? centerlockcoord :centeronend ?? locationViewer.currentcoordinate)
                                    weatherfound = true
                                let dateInTimeZone = getCurrentDateInTimeZone(secondsFromGMT: weather!.timezone)
                                   let dateFormatter = DateFormatter()
                                   dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
                               dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                                dateString = dateFormatter.string(from: dateInTimeZone!)


                            }
                            catch{
                                print("error occured")
                            }

                        }
                        tapped = true
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
            belowzerotemp = false
            belowfiftytemp = false
            analyzed = false
        }
        .overlay(alignment:.bottom){
            HStack{
                Spacer()
                Button(action:{

                        showselectionscreen.toggle()
                },label:{
                    Image(systemName:"gearshape.2.fill")
                        .frame(width:55, height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                        .foregroundStyle(.black)
                })
                .offset(y:-10)
                .popover(isPresented: $showselectionscreen){

                    SelectionScreen(selectkm: $selectkm)

                }
                //MARK: SYMBOL BUTTON
                Button(action:{

                    showsymbolscreen.toggle()

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
                .popover(isPresented:$showsymbolscreen){
                    SymbolView(centersymbol: $centersymbol, centeronend: $centeronend,elevation:$elevation,cameraPosition:$cameraPosition)
                }




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
                            angle[0] = cosineTheoremForAngle(a: distance[0], b: firstD, c: firstThird) ?? 0
                            let third = distancecalc(coord1: polygonviewer.polycoordinates[poly-1], coord2: polygonviewer.polycoordinates[poly-3])*1000
                            angle.append(cosineTheoremForAngle(a:distance[poly-2] , b: distance[poly-3], c:third ) ?? 0)

                            let firstendthird = distancecalc(coord1: polygonviewer.polycoordinates[0], coord2: polygonviewer.polycoordinates[poly-2])*1000
                            firstA = cosineTheoremForAngle(a: distance[poly-2], b: firstD, c: firstendthird) ?? 0
                        }
                        if poly > 1{
                            total += distance[poly-2]

                        }
                        regionarea = regionArea(locations: polygonviewer.polycoordinates)

                    }

                    tablemarkeron = false
                    tablecontent = []
                    belowzerotemp = false
                    belowfiftytemp = false
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
                                if Double(amount) ?? 13 > 99 {
                                    amount = "99"
                                }



                                Loading = true
                                Task {
                                    do {

                                        try await fetchDataFromServer()

                                        Loading = false
                                        showanalytics.toggle()
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
                            if Double(amount) ?? 13 > 99 {
                                amount = "99"
                            }



                            Loading = true
                            Task {
                                do {

                                    try await fetchDataFromServer()

                                    Loading = false
                                    showanalytics.toggle()
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
                        AnalyticsView(cameraposition:$cameraPosition, tablecontent: $tablecontent,showanalytics:$showanalytics,amount:$amount,tablecoord:$tablecoord,tablemarkeron:$tablemarkeron,markercolor: $markercolor,markername:$markername,poly:$poly,belowzerotemp:$belowzerotemp,belowfiftytemp:$belowfiftytemp,belowzeroelev:$belowzeroelev)
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
                                firstA = cosineTheoremForAngle(a: distance[poly-2], b: firstD, c: firstendthird) ?? 0
                                let firstThird = distancecalc(coord1: polygonviewer.polycoordinates[1], coord2: polygonviewer.polycoordinates[poly-1])*1000
                                angle[0] = cosineTheoremForAngle(a: distance[0], b: firstD, c: firstThird) ?? 0

                            }
                            if poly > 1 {

                                total += firstD

                            }

                            tablemarkeron = false
                            tablecontent = []
                            belowzerotemp = false
                            belowfiftytemp = false
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
                            belowzerotemp = false
                            belowfiftytemp = false
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
                        showpolyview.toggle()
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
                    .popover(isPresented: $showpolyview){
                        ForEach(Range(0...poly-1)) { i in
                                Button(action:{
                                    cameraPosition = .region (MKCoordinateRegion(center: polygonviewer.polycoordinates[i] ,latitudinalMeters: 5000,longitudinalMeters: 5000))
                                },label:{
                                    Text("\(String(polygonviewer.polycoordinates[i].latitude))°, \(String(polygonviewer.polycoordinates[i].longitude))°")
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10).fill( i == poly-1 ? .green.opacity(0.5) : ( i == 0 ? .black.opacity(0.5) : .white)))
                                            .foregroundStyle(i == 0 ? .white : .black)
                                        .padding(5)
                                })


                        }
                    }



                }
                Spacer()
                Button(action:{
                    isLoggedIn = false
                }, label:{
                    Image(systemName: "person.fill.badge.minus")

                        .foregroundStyle(.red)


                        .frame(width:20, height: 20)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.red.opacity(0.3)))
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
        .onAppear{
            cameraPosition = .region (MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(camerastring1)!, longitude: Double(camerastring2)! ) ,latitudinalMeters: 120500,longitudinalMeters: 120500))
        }



        .onMapCameraChange(frequency: .continuous, { newcamera in
            centerlocation = newcamera.region.center
            camerastring1 = "\(centerlocation!.latitude)"
            camerastring2 = "\(centerlocation!.longitude)"

        })
        .onMapCameraChange(frequency: .onEnd, { newcamera in
            centeronend = newcamera.region.center
            if tapped == true && centerlock == false{
                Task{
                    do{
                        if mapselection == nil{


                            weather = try await weathermanager.getWeather(loc: centeronend ?? locationViewer.currentcoordinate)

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
                               dateFormatter.dateFormat = "EEEE, MMM d, HH:mm"
                           dateFormatter.timeZone = TimeZone(secondsFromGMT: weather!.timezone)
                            dateString = dateFormatter.string(from: dateInTimeZone!)
                            shownewscreen.toggle()
                            popupshowedbefore = true
                        }
                        catch{
                            print("error occured")
                        }
                    }
                }





            }
            else {
                popupshowedbefore = false
            }

        })




    }

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
        var coordinateselev : [CLLocationCoordinate2D] = []
        var elevationData : ResponseBody2?
        analyzed = true
        coordinateselev.removeAll()
        if poly < 3 {
            if incrementlat == 0 && incrementlong != 0 {
                for long in  stride(from: polygonviewer.polycoordinates[0].longitude, through: polygonviewer.polycoordinates[1].longitude, by: incrementlong) {
                    coordinateselev.append(CLLocationCoordinate2D(latitude: polygonviewer.polycoordinates[0].latitude, longitude: long))

                }
            }
            else if incrementlat != 0 && incrementlong == 0 {
                for lat in  stride(from: polygonviewer.polycoordinates[0].latitude, through: polygonviewer.polycoordinates[1].latitude, by: incrementlat) {
                    coordinateselev.append(CLLocationCoordinate2D(latitude:lat, longitude: polygonviewer.polycoordinates[0].longitude ))

                }
            }
            else if incrementlat == 0 && incrementlong == 0 {

                    coordinateselev.append(CLLocationCoordinate2D(latitude:polygonviewer.polycoordinates[0].latitude, longitude: polygonviewer.polycoordinates[0].longitude ))


            }
            else{
                for (lat, long) in zip(stride(from: polygonviewer.polycoordinates[0].latitude, through: polygonviewer.polycoordinates[1].latitude, by: incrementlat), stride(from: polygonviewer.polycoordinates[0].longitude, through: polygonviewer.polycoordinates[1].longitude, by: incrementlong)) {
                    coordinateselev.append(CLLocationCoordinate2D(latitude: lat, longitude: long))

                }
            }
            for i in 0...coordinateselev.count-1{

                do {
                    let weatherData = try await weathermanager.getOptimizedWeather(loc: coordinateselev[i])
                    if i == 0 {
                        elevationData = try await elevationmanager.getElevationfast(loc: coordinateselev)
                    }
                    tablecontent.append(Analytics(
                        lat: Double(String(format: "%.3f", coordinateselev[i].latitude))!,
                        lng: Double(String(format: "%.3f", coordinateselev[i].longitude))!,
                        temp: (weatherData.main.temp - 273.15),
                        elev: elevationData!.elevation[i],
                        hum: Double(weatherData.main.humidity),
                        wind: weatherData.wind.speed)

                    )
                    if weatherData.main.temp - 273.15 < 0 {


                            belowzerotemp = true

                    }
                    if weatherData.main.temp - 273.15 < -50 {
                        belowfiftytemp = true

                    }
                    if elevationData!.elevation[i] < 0 {
                        belowzeroelev = true
                    }


                } catch {
                    print("error occurred")
                }
            }
        }

    else {
        for coordinate in polygonviewer.polycoordinates{
            coordinateselev.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        for i in 0...coordinateselev.count-1{
            do {
                let weatherData = try await weathermanager.getOptimizedWeather(loc: coordinateselev[i])
                if i == 0{
                     elevationData = try await elevationmanager.getElevationfast(loc: coordinateselev)
                }
                tablecontent.append(Analytics(
                    lat: Double(String(format: "%.3f", coordinateselev[i].latitude))!,
                    lng: Double(String(format: "%.3f", coordinateselev[i].longitude))!,
                    temp: (weatherData.main.temp - 273.15),
                    elev: elevationData!.elevation[i],
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
