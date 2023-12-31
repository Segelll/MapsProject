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
    @Binding var alpha : Int
    @Binding var searchmode : Bool
    @State var mode : Int = 0
    var body: some View {
       
            VStack(alignment:.center){
                Text(weather.sys.country ?? "")
                    .bold()
                    .font(.headline)
                    .fontWidth(.expanded)
                    .textCase(.uppercase)
                Button(action:{
                    showdetailsscreen.toggle()
                },label:{
                    
                        Image(systemName:"pip.enter")
                        .offset(x:5,y:-15)
                   
                    Text(weather.name == "" ? "(Not Applicable)":weather.name)
                            .bold()
                            .font(.largeTitle)
                            .fontWidth(.expanded)
                            .textCase(.uppercase)
                    
                })
                .foregroundStyle(searchmode ? .red.opacity(0.8):.indigo.opacity(0.8))
                Text("(\(String(format:"%.3f", weather.coord.lat))°, \(String(format:"%.3f", weather.coord.lon))°/\(String(format:"%.0f",(elevation?.elevation[0]) ?? 0.0))m)")
                    .bold()
                    .font(.subheadline)
                    .fontWidth(.expanded)
           
                    Text(dateString ?? "...")
                        .fontWidth(.expanded)
                        .font(.caption)
                        .bold()
                    
                        Text(weather.timezone/3600 > 0 ? "'GMT+\(String(weather.timezone/3600))'":"'GMT\(String(weather.timezone/3600))'")
                            .fontWidth(.expanded)
                            .font(.caption2)
                            .bold()
                    
                
              /*  if mode == 0{
                    HStack{
                        Image(systemName: "sunrise.fill")
                        Text(convert2(value: weather.sys.sunrise))
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                        Image(systemName: "sunset.fill")
                        Text(convert2(value: weather.sys.sunset))
                            .fontWidth(.expanded)
                            .bold()
                            .font(.caption2)
                    }
                } */
            }
            .padding(-10)
         /*   VStack{
                
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
        VStack(alignment:.leading){
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
            
        } */
            
            
            
            
            
            
        
        Picker("Mode",selection:$mode.animation(.easeInOut)){
            Text("Hourly").tag(0)
            Text("Daily").tag(1)
            
        }
        
        .pickerStyle(.segmented)
        .frame(width: 170 ,height: 65)
        if mode == 0{
            ScrollView(.horizontal) {
                HStack{
                    
                    
                    ForEach(Range(0...3)){ a in
                        let range1 = a == 0 ? 0 : alpha + ((a-1)*24)
                        let range2 = (alpha-1) + (a*24)
                        VStack(alignment: .center){
                            
                              
                            HStack{
                                if a == 0 {
                                    VStack{
                                        switch("\(weather.weather[0].description)"){
                                        case "clear sky":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "sun.max.fill")
                                                        .foregroundStyle(.yellow)
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "few clouds","overcast clouds":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.sun.fill")
                                                        .foregroundStyle(.gray,.yellow)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                        case "scattered clouds":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.fill")
                                                        .foregroundStyle(.gray)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "broken clouds":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "smoke.fill")
                                                        .foregroundStyle(.gray)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "shower rain","heavy intensity rain":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.heavyrain.fill")
                                                        .foregroundStyle(.gray,.blue)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "rain","light rain","moderate rain","light intensity shower rain","light intensity drizzle","light intensity drizzle rain":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.sun.rain.fill")
                                                        .foregroundStyle(.gray,.yellow,.blue)
                                                    
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                                
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "thunderstorm":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.bolt.fill")
                                                        .foregroundStyle(.gray,.yellow)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "snow","light snow":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.snow.fill")
                                                        .foregroundStyle(.gray,.gray)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "mist","haze","fog":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.fog.fill")
                                                        .foregroundStyle(.gray,.brown)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                        default:
                                            VStack{
                                                HStack{
                                                    Image(systemName: "thermometer.sun.fill")
                                                        .foregroundStyle(.red,.yellow,.black)
                                                    
                                                }
                                                Text(String(weather.weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                        }
                                        
                                        VStack(alignment:.center){
                                            
                                            VStack(alignment: .center){
                                                Text("\(String(format:"%.1f", weather.main.temp-273.15))°C")
                                                    .fontWidth(.expanded)
                                                    .font(.title2)
                                                    .bold()
                                                Text("(Feels Like \(String(format:"%.1f", weather.main.feels_like-273.15))°C)")
                                                    .fontWidth(.expanded)
                                                    .font(.caption)
                                                
                                                
                                                HStack{
                                                    Image(systemName: "thermometer.low")
                                                    Text("\(String(format:"%.1f", weather.main.temp_min-273.15))°C")
                                                        .fontWidth(.expanded)
                                                        .font(.footnote)
                                                        .bold()
                                                    Image(systemName: "thermometer.high")
                                                    Text("\(String(format:"%.1f", weather.main.temp_max-273.15))°C")
                                                        .fontWidth(.expanded)
                                                        .font(.footnote)
                                                        .bold()
                                                }
                                            }
                                            .padding(2)
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Image(systemName: "humidity.fill")
                                                    Text("\(String (weather.main.humidity))%")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "cloud.fill")
                                                    Text("\(String( weather.clouds.all))%")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "umbrella.percent.fill")
                                                    Text("n/a%")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "umbrella.fill")
                                                    Text("\(String(format: "%.1f",weather.rain?.oneHour ?? 0))mm")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "wind")
                                                    Text("\(String(format:"%.1f", weather.wind.speed))(\((String(format:"%.1f", weather.wind.gust ?? weather.wind.speed))))m/s")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "location.north.line.fill")
                                                        .rotationEffect(Angle(degrees: Double(weather.wind.deg)))
                                                    Text("\(String(weather.wind.deg))°")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                            }
                                            Text("NOW")
                                                .fontWidth(.expanded)
                                                .font(.title3)
                                                .frame(width:190, height: 55)
                                            
                                            
                                                .bold()
                                            
                                        }
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                        .padding(12)
                                        
                                        .background(RoundedRectangle(cornerRadius: 10).fill(a % 2 == 0 ? .green : .red).opacity(0.1))
                                    }
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    
                                    .padding(.horizontal,10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.6)))
                                    .padding(.horizontal,10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.3)))
                                    .padding(.horizontal,12)
                                    
                                    .padding(.top,30)
                                    
                                }
                                ForEach(Range(range1...range2)){ i in
                                
                                    VStack(alignment: .center){
                                        switch("\(hweather!.list[i].weather[0].description)"){
                                        case "clear sky":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "sun.max.fill")
                                                        .foregroundStyle(.yellow)
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "few clouds","overcast clouds":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.sun.fill")
                                                        .foregroundStyle(.gray,.yellow)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                        case "scattered clouds":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.fill")
                                                        .foregroundStyle(.gray)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "broken clouds":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "smoke.fill")
                                                        .foregroundStyle(.gray)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "shower rain","heavy intensity rain":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.heavyrain.fill")
                                                        .foregroundStyle(.gray,.blue)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "rain","light rain","moderate rain","light intensity shower rain","light intensity drizzle","light intensity drizzle rain":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.sun.rain.fill")
                                                        .foregroundStyle(.gray,.yellow,.blue)
                                                    
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                                
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "thunderstorm":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.bolt.fill")
                                                        .foregroundStyle(.gray,.yellow)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "snow","light snow":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.snow.fill")
                                                        .foregroundStyle(.gray,.gray)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                            
                                        case "mist","haze","fog":
                                            VStack{
                                                HStack{
                                                    Image(systemName: "cloud.fog.fill")
                                                        .foregroundStyle(.gray,.brown)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                        default:
                                            VStack{
                                                HStack{
                                                    Image(systemName: "thermometer.sun.fill")
                                                        .foregroundStyle(.red,.yellow,.black)
                                                    
                                                }
                                                Text(String(hweather!.list[i].weather[0].description))
                                                    .fontWidth(.expanded)
                                                    .font(.footnote)
                                                    .foregroundStyle(.gray)
                                            }
                                            .frame(width:237, height: 85)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .shadow(radius: 20)
                                        }
                                        
                                        VStack(alignment:.center){
                                            
                                            VStack(alignment: .center){
                                                Text("\(String(format:"%.1f", hweather!.list[i].main.temp-273.15))°C")
                                                    .fontWidth(.expanded)
                                                    .font(.title2)
                                                    .bold()
                                                Text("(Feels Like \(String(format:"%.1f", hweather!.list[i].main.feels_like-273.15))°C)")
                                                    .fontWidth(.expanded)
                                                    .font(.caption)
                                                
                                                    
                                                HStack{
                                                    Image(systemName: "thermometer.low")
                                                    Text("\(String(format:"%.1f", hweather!.list[i].main.temp_min-273.15))°C")
                                                        .fontWidth(.expanded)
                                                        .font(.footnote)
                                                        .bold()
                                                    Image(systemName: "thermometer.high")
                                                    Text("\(String(format:"%.1f", hweather!.list[i].main.temp_max-273.15))°C")
                                                        .fontWidth(.expanded)
                                                        .font(.footnote)
                                                        .bold()
                                                }
                                            }
                                            .padding(2)
                                            VStack(alignment: .leading){
                                                HStack{
                                                    Image(systemName: "humidity.fill")
                                                    Text("\(String (hweather!.list[i].main.humidity))%")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "cloud.fill")
                                                    Text("\(String( hweather!.list[i].clouds.all))%")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "umbrella.percent.fill")
                                                    Text("\(String(Int(hweather!.list[i].pop * 100)))%")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "umbrella.fill")
                                                    Text("\(String(format: "%.1f",hweather!.list[i].rain?.oneHour ?? 0))mm")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "wind")
                                                    Text("\(String(format:"%.1f", hweather!.list[i].wind.speed))(\(String(format:"%.1f",hweather!.list[i].wind.gust)))m/s")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                                HStack{
                                                    Image(systemName: "location.north.line.fill")
                                                        .rotationEffect(Angle(degrees: Double(hweather!.list[i].wind.deg)))
                                                    Text("\(String( hweather!.list[i].wind.deg))°")
                                                        .fontWidth(.expanded)
                                                        .font(.caption2)
                                                        .bold()
                                                }
                                                .padding(2)
                                            }
                                            Text(convertsun2(sunvalue:hweather!.list[i].dt,sunzone:weather.timezone))
                                                .fontWidth(.expanded)
                                                .font(.title3)
                                                .frame(width:190, height: 55)
                                                
                                                
                                                .bold()
                                            
                                        }
                                        .padding(12)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                        .padding(12)
                                        
                                        .background(RoundedRectangle(cornerRadius: 10).fill(a % 2 == 0 ? .green : .red).opacity(0.1))
                                      
                                    }
                                    
                                    
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    
                                    .padding(.horizontal,10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(hweather!.list[i].sys.pod == "d" ? .yellow.opacity(0.6):.indigo.opacity(0.6)))
                                    .padding(.horizontal,10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(hweather!.list[i].sys.pod == "d" ? .yellow.opacity(0.3):.indigo.opacity(0.3)))
                                    .padding(.horizontal,12)
                                    
                                    .padding(.top,30)
                                    
                                   
                                }
                            }
                            HStack{
                                Image(systemName: "sunrise.fill")
                                Text( String(convertsun2(sunvalue:dweather!.list[a].sunrise,sunzone:weather.timezone)))
                                    .fontWidth(.expanded)
                                    .bold()
                                    .font(.caption2)
                                Text("\(String(convertsun4(sunvalue:dweather!.list[a].dt,sunzone:weather.timezone))), \(String(convertsun3(sunvalue:hweather!.list[range1].dt,sunzone:weather.timezone)))")
                                    .fontWidth(.expanded)
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                               
                                Text(String(convertsun2(sunvalue:dweather!.list[a].sunset,sunzone:weather.timezone)))
                                    .fontWidth(.expanded)
                                    .bold()
                                    .font(.caption2)
                                Image(systemName: "sunset.fill")

                            }
                                .frame(width: a == 0 ? CGFloat((alpha*308)+308) : 24*308 )
                                
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(a % 2 == 0 ? .green : .red).opacity(0.1))
                            
                            .padding(1)
                            
                            .bold()
                            
                        }
                       
                        .padding(15)
                        .padding(.horizontal,10)
                        .padding(.bottom,15)
                        
                    }
                    
                }
            }
            
            
        }
        
        
        if mode == 1 {
            ScrollView(.horizontal) {
                HStack{
                    ForEach(Range(0...15)){ a in
                        VStack(alignment:.center){
                            switch("\(dweather!.list[a].weather[0].description)"){
                            case "clear sky","sky is clear":
                                VStack{
                                    HStack{
                                        Image(systemName: "sun.max.fill")
                                            .foregroundStyle(.yellow)
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                                
                            case "few clouds","overcast clouds":
                                VStack{
                                    HStack{
                                        Image(systemName: "cloud.sun.fill")
                                            .foregroundStyle(.gray,.yellow)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                            case "scattered clouds":
                                VStack{
                                    HStack{
                                        Image(systemName: "cloud.fill")
                                            .foregroundStyle(.gray)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                                
                            case "broken clouds":
                                VStack{
                                    HStack{
                                        Image(systemName: "smoke.fill")
                                            .foregroundStyle(.gray)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                                
                            case "shower rain","heavy intensity rain":
                                VStack{
                                    HStack{
                                        Image(systemName: "cloud.heavyrain.fill")
                                            .foregroundStyle(.gray,.blue)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                                
                            case "rain","light rain","moderate rain","light intensity shower rain","light intensity drizzle","light intensity drizzle rain":
                                VStack{
                                    HStack{
                                        Image(systemName: "cloud.sun.rain.fill")
                                            .foregroundStyle(.gray,.yellow,.blue)
                                        
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                    
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                                
                            case "thunderstorm":
                                VStack{
                                    HStack{
                                        Image(systemName: "cloud.bolt.fill")
                                            .foregroundStyle(.gray,.yellow)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                                
                            case "snow","light snow":
                                VStack{
                                    HStack{
                                        Image(systemName: "cloud.snow.fill")
                                            .foregroundStyle(.gray,.gray)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                                
                            case "mist","haze","fog":
                                VStack{
                                    HStack{
                                        Image(systemName: "cloud.fog.fill")
                                            .foregroundStyle(.gray,.brown)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                            default:
                                VStack{
                                    HStack{
                                        Image(systemName: "thermometer.sun.fill")
                                            .foregroundStyle(.red,.yellow,.black)
                                        
                                    }
                                    Text(String(dweather!.list[a].weather[0].description))
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .frame(width:350, height: 85)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                            }
                            
                            
                            
                            
                            HStack{
                                
                                VStack(alignment:.center){
                                    Image(systemName: "sun.horizon.fill")
                                    Text("\(String(format:"%.1f", dweather!.list[a].temp.morn-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.subheadline)
                                        .bold()
                                }
                                VStack(alignment:.center){
                                    Image(systemName: "sun.min.fill")
                                    Text("\(String(format:"%.1f", dweather!.list[a].temp.day-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.subheadline)
                                        .bold()
                                }
                                VStack(alignment:.center){
                                    Image(systemName: "moon.haze.fill")
                                    Text("\(String(format:"%.1f", dweather!.list[a].temp.eve-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.subheadline)
                                        .bold()
                                }
                                VStack(alignment:.center){
                                    Image(systemName: "moon.stars.fill")
                                    Text("\(String(format:"%.1f", dweather!.list[a].temp.night-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.subheadline)
                                        .bold()
                                }
                            }
                            .padding(.vertical,3)
                            .padding(.top,2)
                            HStack{
                                VStack(alignment:.center){
                                    Image(systemName: "sun.horizon")
                                    Text("\(String(format:"%.1f", dweather!.list[a].feels_like.morn-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                }
                                VStack(alignment:.center){
                                    Image(systemName: "sun.min")
                                    Text("\(String(format:"%.1f", dweather!.list[a].feels_like.day-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                }
                                VStack(alignment:.center){
                                    Image(systemName: "moon.haze")
                                    Text("\(String(format:"%.1f", dweather!.list[a].feels_like.eve-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                }
                                VStack(alignment:.center){
                                    Image(systemName: "moon.stars")
                                    Text("\(String(format:"%.1f", dweather!.list[a].feels_like.night-273.15))°C")
                                        .fontWidth(.expanded)
                                        .font(.footnote)
                                }
                            }
                            .padding(.vertical,3)
                            HStack{
                                Image(systemName: "thermometer.low")
                                Text("\(String(format:"%.1f", dweather!.list[a].temp.min-273.15))°C ")
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .bold()
                                Image(systemName: "thermometer.high")
                                Text("\(String(format:"%.1f", dweather!.list[a].temp.max-273.15))°C")
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                    .bold()
                            }
                            .padding(.vertical,3)
                            
                            
                            
                                VStack(alignment: .center){
                                    HStack{
                                        Image(systemName: "sunrise.fill")
                                        Text(String(convertsun2(sunvalue:dweather!.list[a].sunrise,sunzone:weather.timezone)))
                                            .fontWidth(.expanded)
                                            .bold()
                                            .font(.caption2)
                                        
                                        Text(String(convertsun2(sunvalue:dweather!.list[a].sunset,sunzone:weather.timezone)))
                                            .fontWidth(.expanded)
                                            .bold()
                                        .font(.caption2)
                                        Image(systemName: "sunset.fill")}
                                    .padding(12)
                                    
                                    
                                    .background(RoundedRectangle(cornerRadius: 10).fill(a % 2 == 0 ? .green : .red).opacity(0.1))
                                    VStack(alignment:.leading){
                                        HStack{
                                            Image(systemName: "humidity.fill")
                                            Text("\(String (dweather!.list[a].humidity))%")
                                                .fontWidth(.expanded)
                                                .font(.caption2)
                                                .bold()
                                        }
                                        .padding(2)
                                        HStack{
                                            Image(systemName: "cloud.fill")
                                            Text("\(String( dweather!.list[a].clouds))%")
                                                .fontWidth(.expanded)
                                                .font(.caption2)
                                                .bold()
                                        }
                                        .padding(2)
                                        HStack{
                                            Image(systemName: "umbrella.percent.fill")
                                            Text("\(String(Int(dweather!.list[a].pop * 100)))%")
                                                .fontWidth(.expanded)
                                                .font(.caption2)
                                                .bold()
                                        }
                                        .padding(2)
                                        HStack{
                                            Image(systemName: "umbrella.fill")
                                            Text("\(String(format: "%.1f",dweather!.list[a].rain ?? 0))mm")
                                                .fontWidth(.expanded)
                                                .font(.caption2)
                                                .bold()
                                        }
                                        .padding(2)
                                        HStack{
                                            Image(systemName: "wind")
                                            Text("\(String(format:"%.1f", dweather!.list[a].speed))(\(String(format:"%.1f",dweather!.list[a].gust)))m/s")
                                                .fontWidth(.expanded)
                                                .font(.caption2)
                                                .bold()
                                        }
                                        .padding(2)
                                        HStack{
                                            Image(systemName: "location.north.line.fill")
                                                .rotationEffect(Angle(degrees: Double(dweather!.list[a].deg)))
                                            Text("\(String( dweather!.list[a].deg))°")
                                                .fontWidth(.expanded)
                                                .font(.caption2)
                                                .bold()
                                        }
                                        
                                        .padding(2)
                                        .padding(.bottom,1)
                                        
                                    }
                                        
                                    VStack{
                                        Text(String(convertsun4(sunvalue:dweather!.list[a].dt,sunzone:weather.timezone)))
                                            .fontWidth(.expanded)
                                            .font(.title3)
                                            .textCase(.uppercase)
                                            .bold()
                                            
                                        Text(String(convertsun3(sunvalue:dweather!.list[a].dt,sunzone:weather.timezone)))
                                            .fontWidth(.expanded)
                                            .font(.subheadline)
                                            .bold()
                                    }
                                    .padding(.top,15)
                                    .padding(4)
                                    
                                    
                                
                            }
                                .padding(12)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .padding(12)
                                
                                .background(RoundedRectangle(cornerRadius: 10).fill(a % 2 == 0 ? .green : .red).opacity(0.1))
                                .padding(.vertical,12)
                                
                                
                            
                        }
                        .padding(.vertical,-10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding(.vertical,10)
                           
                            
                            .padding(.horizontal,10)
                            .background(RoundedRectangle(cornerRadius: 10).fill( a % 2 == 0 ? .green : .red).opacity(0.2))
                            .padding(.horizontal,10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.4)))
                            .padding(.horizontal,10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.2)))
                            .padding(.horizontal,8)
                            
                            .padding(.top,30)
                        
                        }
                    .padding(.horizontal,1)
                    .padding(.vertical,15)
                    }
                
                
                }
            }
            
            
            
            
          
            
        }
        
        
    }
    
    

extension DetailsView {
   
    func convertsun2(sunvalue:Int,sunzone:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(sunvalue))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: sunzone)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    func convertsun3(sunvalue:Int,sunzone:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(sunvalue))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: sunzone)
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
    func convertsun4(sunvalue:Int,sunzone:Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(sunvalue))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: sunzone)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    
}


