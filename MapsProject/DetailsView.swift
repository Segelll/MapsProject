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
            }
            .padding(-10)

        Picker("Mode",selection:$mode.animation(.easeInOut)){
            Text("Hourly").tag(0)
            Text("Daily").tag(1)

        }
        .pickerStyle(.segmented)
        .frame(width: 170 ,height: 65)

        if mode == 0 {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<4) { a in
                        let range1 = a == 0 ? 0 : alpha + ((a-1)*24)
                        let range2 = (alpha-1) + (a*24)
                        VStack(alignment: .center) {
                            HStack {
                                if a == 0 {
                                    // MARK: Current Weather Card
                                    VStack {
                                        WeatherConditionView(weatherDescription: weather.weather[0].description) // Refactored View
                                        // ... Rest of the current weather details
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
                                            // ... other details
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

                                ForEach(range1...range2, id: \.self) { i in
                                    if let hweather = hweather {
                                        VStack(alignment: .center) {
                                            WeatherConditionView(weatherDescription: hweather.list[i].weather[0].description) // Refactored View
                                            // ... Rest of the hourly details
                                            VStack(alignment:.center){
                                                VStack(alignment: .center){
                                                    Text("\(String(format:"%.1f", hweather.list[i].main.temp-273.15))°C")
                                                        .fontWidth(.expanded)
                                                        .font(.title2)
                                                        .bold()
                                                    // ... other details
                                                }
                                                .padding(2)
                                            }
                                            .padding(12)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                            .padding(12)
                                            .background(RoundedRectangle(cornerRadius: 10).fill(a % 2 == 0 ? .green : .red).opacity(0.1))
                                        }
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                        .padding(.horizontal,10)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(hweather.list[i].sys.pod == "d" ? .yellow.opacity(0.6):.indigo.opacity(0.6)))
                                        .padding(.horizontal,10)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(hweather.list[i].sys.pod == "d" ? .yellow.opacity(0.3):.indigo.opacity(0.3)))
                                        .padding(.horizontal,12)
                                        .padding(.top,30)
                                    }
                                }
                            }
                            // ... Sunrise/Sunset HStack
                        }
                        .padding(15)
                        .padding(.horizontal,10)
                        .padding(.bottom,15)
                    }
                }
            }
        } else if mode == 1 {
            ScrollView(.horizontal) {
                HStack {
                    if let dweather = dweather {
                        ForEach(0..<dweather.list.count, id: \.self) { a in
                            VStack(alignment:.center) {
                                WeatherConditionView(weatherDescription: dweather.list[a].weather[0].description, isDaily: true) // Refactored View
                                
                                // ... Rest of the daily forecast card
                                HStack{
                                    VStack(alignment:.center){
                                        Image(systemName: "sun.horizon.fill")
                                        Text("\(String(format:"%.1f", dweather.list[a].temp.morn-273.15))°C")
                                            .fontWidth(.expanded)
                                            .font(.subheadline)
                                            .bold()
                                    }
                                    // ... other details
                                }
                                .padding(.vertical,3)
                                .padding(.top,2)
                                
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
}


// MARK: - Helper View for Weather Condition
struct WeatherConditionView: View {
    let weatherDescription: String
    var isDaily: Bool = false

    var body: some View {
        VStack {
            switch weatherDescription {
            case "clear sky", "sky is clear":
                VStack {
                    Image(systemName: "sun.max.fill").foregroundStyle(.yellow)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "few clouds", "overcast clouds":
                VStack {
                    Image(systemName: "cloud.sun.fill").foregroundStyle(.gray, .yellow)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "scattered clouds":
                VStack {
                    Image(systemName: "cloud.fill").foregroundStyle(.gray)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "broken clouds":
                VStack {
                    Image(systemName: "smoke.fill").foregroundStyle(.gray)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "shower rain", "heavy intensity rain":
                VStack {
                    Image(systemName: "cloud.heavyrain.fill").foregroundStyle(.gray, .blue)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "rain", "light rain", "moderate rain", "light intensity shower rain", "light intensity drizzle", "light intensity drizzle rain":
                VStack {
                    Image(systemName: "cloud.sun.rain.fill").foregroundStyle(.gray, .yellow, .blue)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "thunderstorm":
                VStack {
                    Image(systemName: "cloud.bolt.fill").foregroundStyle(.gray, .yellow)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "snow", "light snow":
                VStack {
                    Image(systemName: "cloud.snow.fill").foregroundStyle(.gray, .gray)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            case "mist", "haze", "fog":
                VStack {
                    Image(systemName: "cloud.fog.fill").foregroundStyle(.gray, .brown)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            default:
                VStack {
                    Image(systemName: "thermometer.sun.fill").foregroundStyle(.red, .yellow, .black)
                    Text(weatherDescription).fontWidth(.expanded).font(.footnote).foregroundStyle(.gray)
                }
            }
        }
        .frame(width: isDaily ? 350 : 237, height: 85)
        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
        .shadow(radius: 20)
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
