import SwiftUI
import MapKit

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
                                alpha = 24 - Int(convertsun2(sunvalue: hweather!.list[0].dt, sunzone: weather.timezone))!
                                showdetailsscreen.toggle()


                            }
                            catch{
                                print("error")
                            }

                        }


                    },label:{

                        Image(systemName: "pip.exit")
                            .offset(x:5,y:-15)
                        Text(weather.name == "" ? "(N/A)": weather.name)
                            .bold()
                            .font(.largeTitle)
                            .fontWidth(.expanded)
                            .textCase(.uppercase)
                            .padding(.bottom,weather.name == "" ? 10 : 0)


                    })

                    .foregroundStyle(searchmode ? .red.opacity(0.8) :.indigo.opacity(0.8))
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



                    HStack{
                        HStack{
                            Image(systemName: "sunrise.fill")
                            Text(String(convertsun(sunvalue: weather.sys.sunrise, sunzone: weather.timezone)))
                                .fontWidth(.expanded)
                                .bold()
                                .font(.caption2)

                        }

                        HStack{

                            Text(String(convertsun(sunvalue: weather.sys.sunset, sunzone: weather.timezone)))
                                .fontWidth(.expanded)
                                .bold()
                                .font(.caption2)
                            Image(systemName: "sunset.fill")
                        }


                    }
                    Spacer()

                }
                .padding(3)

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
                        Image(systemName:"thermometer.low")
                        Text("\(String(format:"%.1f",Double(weather.main.tempMin-273.15)))°C")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.footnote)
                        Image(systemName:"thermometer.high")
                        Text("\(String(format:"%.1f",Double(weather.main.tempMax-273.15)))°C")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.footnote)

                    }
                    Spacer()
                }
                .padding(3)
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
                        Image(systemName: "tornado")
                        Text("\(String(format:"%.1f",weather.wind.gust != nil ?  weather.wind.gust! : weather.wind.speed ))m/s")
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)

                    }
                    .padding(1)
                    HStack{
                        Image(systemName: "location.north.line.fill")
                            .rotationEffect(Angle(degrees: Double(weather.wind.deg)))
                        Text("  \(String(weather.wind.deg))°")
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
                        Image(systemName:"clock.circle.fill")
                        Text(weather.timezone/3600 > 0 ? "GMT+\(String(weather.timezone/3600))":"GMT\(String(weather.timezone/3600))" )
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                    }
                    .padding(1)
                    Spacer()
                }
                .padding(3)



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
    func convertsun2(sunvalue:Int,sunzone:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(sunvalue))
        let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: sunzone)
            dateFormatter.dateFormat = "HH"
            return dateFormatter.string(from: date)
    }
}
