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
                Text(String(hweather!.city.population))
                    .fontWidth(.expanded)
                    .font(.footnote)
            }
            Spacer()
        }
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
    
}


