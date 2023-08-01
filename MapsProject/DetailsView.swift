//
//  DetailsView.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 31.07.2023.
//

import SwiftUI

struct DetailsView: View {
    @Binding var showdetailsscreen : Bool
    @Binding var hweather : ResponseHourly?
    @Binding var weather : ResponseBody
    @Binding var dateString : String?
    @Binding var elevation : ResponseBody2?
    @Binding var dweather : ResponseDaily?
    @State var mode : Int = 0
    var body: some View {
        HStack(alignment:.top){
            VStack(alignment:.leading){
                Text(weather.sys.country ?? "(Not Applicable)")
                    .bold()
                    .font(.headline)
                    .fontWidth(.expanded)
                    .textCase(.uppercase)
                Text(weather.name)
                    .bold()
                    .font(.largeTitle)
                    .fontWidth(.expanded)
                    .textCase(.uppercase)
                Text("(\(String(format:"%.3f", weather.coord.lat))°, \(String(format:"%.3f", weather.coord.lon))°/\(String(format:"%.0f",(elevation?.elevation[0]) ?? 0.0))m)")
                    .bold()
                    .font(.subheadline)
                    .fontWidth(.expanded)
                Text(String(weather.timezone/3600))
                    .fontWidth(.expanded)
                    .font(.footnote)
                Text(dateString ?? "...")
                    .fontWidth(.expanded)
                    .font(.footnote)
                Text(convert2(value: weather.sys.sunrise))
                    .fontWidth(.expanded)
                    .bold()
                    .font(.caption2)
                Text(convert2(value: weather.sys.sunset))
                    .fontWidth(.expanded)
                    .bold()
                    .font(.caption2)
            }
                VStack{
                   
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
                    
                }
                
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
               
              
                 
                   
                 
                
            
            Spacer()
        }
        Picker("Mode",selection:$mode.animation(.easeInOut)){
            Text("Hourly").tag(0)
            Text("Daily").tag(1)
            
        }
        .pickerStyle(.segmented)
        .frame(width: 170 ,height: 65)
        if mode == 0{
            ScrollView(.horizontal) {
                HStack{
                    ForEach(Range(0...95)){ i in
                        VStack{
                            Text(convert(value:hweather!.list[i].dt))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(hweather!.list[i].weather[0].description))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(hweather!.list[i].sys.pod == "d" ? "day":"night")
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", hweather!.list[i].main.temp-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", hweather!.list[i].main.feels_like-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", hweather!.list[i].main.temp_min-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", hweather!.list[i].main.temp_max-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String (hweather!.list[i].main.humidity))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String( hweather!.list[i].clouds.all))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(hweather!.list[i].pop * 100))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String (hweather!.list[i].rain?.oneHour ?? 0))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text("\(String( hweather!.list[i].wind.speed))(\(String(hweather!.list[i].wind.gust)))")
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String( hweather!.list[i].wind.deg))
                                .fontWidth(.expanded)
                                .font(.footnote)
                        }
                    }
                    
                }
            }
        }
        if mode == 1 {
            ScrollView(.horizontal) {
                HStack{
                    ForEach(Range(0...15)){ a in
                        VStack{
                            Text(String(convert3(value:dweather!.list[a].dt)))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(convert2(value:dweather!.list[a].sunrise)))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(convert2(value:dweather!.list[a].sunset)))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(dweather!.list[a].weather[0].description))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            
                            Text(String(format:"%.3f", dweather!.list[a].temp.morn-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].temp.day-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].temp.eve-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].temp.night-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].feels_like.morn-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].feels_like.day-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].feels_like.eve-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].feels_like.night-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].temp.min-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f", dweather!.list[a].temp.max-273.15))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String (dweather!.list[a].humidity))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String( dweather!.list[a].clouds))
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String(format:"%.3f",dweather!.list[a].pop * 100))
                                .fontWidth(.expanded)
                                .font(.footnote)
                           Text(String (dweather!.list[a].rain ?? 0))
                              .fontWidth(.expanded)
                                .font(.footnote)
                            Text("\(String( dweather!.list[a].speed))(\(String(dweather!.list[a].gust)))")
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text(String( dweather!.list[a].deg))
                                .fontWidth(.expanded)
                                .font(.footnote)
                        }
                    }
                    
                }
            }
        }
    
        
        
        Button(action:{
            showdetailsscreen.toggle()
        },label:{
            Text("close")
        })
    }
        
        
    }

extension DetailsView {
    
    
    func convert(value:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(value))
        let dateFormatter = DateFormatter()
           
            dateFormatter.dateFormat = "MM-dd HH:mm"
            return dateFormatter.string(from: date)
    }
    func convert2(value:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(value))
        let dateFormatter = DateFormatter()
           
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
    }
    func convert3(value:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(value))
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter.string(from: date)
    }
    
}


