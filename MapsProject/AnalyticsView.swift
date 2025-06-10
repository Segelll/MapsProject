import SwiftUI
import MapKit
import Charts

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
    @Binding var belowzerotemp : Bool
    @Binding var belowfiftytemp : Bool
    @Binding var belowzeroelev :Bool
    var body: some View {
        // ZStack to layer the background behind the content
        ZStack {
            // Background color that adapts to light/dark mode
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all) // Extend the background to the screen edges

            // Main content of your view
            ScrollView {
                VStack {
                    HStack{
                        Text(poly > 2 ? "Multipoint Analytics" : " Segmented Analytics;")
                            .fontWidth(.expanded)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.primary) // Use .primary for better adaptability
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
                                .foregroundStyle(.primary) // Use .primary for better adaptability
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
                            .foregroundStyle(.primary)
                            .shadow(radius: 20)

                        Chart(tablecontent){ content in
                            AreaMark(x: .value("first" , "\(content.lat)\n\(content.lng)"),
                                     yStart: .value("second" , content.temp),
                                     yEnd: . value("end",  belowzerotemp ? (belowfiftytemp ? -100 : -50): 0 )
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.red.opacity(0.1))

                            LineMark(x: .value("first" , "\(content.lat)\n\(content.lng)"),
                                     y: .value("second" , content.temp)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.red)

                            PointMark(x: .value("first" , "\(content.lat)\n\(content.lng)"),
                                      y: .value("second" , content.temp)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .annotation{
                                Text("\(String(format:"%.1f" , content.temp))°C")
                                    .font(.caption2)
                                    .fontWidth(.expanded)
                                    .foregroundStyle(.red)
                            }
                            .symbolSize(100)
                            .symbol(BasicChartSymbolShape.circle)
                            .foregroundStyle(.red)
                        }
                        .chartYAxis{
                            AxisMarks(position:.leading)
                        }
                        .chartXVisibleDomain(length: tablecontent.count > 40 ? 40: tablecontent.count)
                        .chartScrollTargetBehavior(.valueAligned(unit: 1))
                        .chartScrollableAxes(.horizontal)
                        .chartOverlay { proxy in
                            GeometryReader { geometry in
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .onTapGesture{ location in
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
                    .frame(height: 350)

                    VStack{
                        Text("Latitude, Longitude in Degrees/ Elevation in meters")
                            .fontWidth(.expanded)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.primary)
                            .shadow(radius: 20)
                        Chart(tablecontent){ content in
                            AreaMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                     yStart: .value("second" , content.elev),
                                     yEnd: . value("end",belowzeroelev ? -1000 : 0)

                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.green.opacity(0.1))
                            LineMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                     y: .value("second" , content.elev)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.green)

                            PointMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                      y: .value("second" , content.elev)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .annotation{
                                Text("\(String(format:"%.0f" , content.elev))m")
                                    .font(.caption2)
                                    .fontWidth(.expanded)
                                    .foregroundStyle(.green)
                            }
                            .symbolSize(100)
                            .symbol(BasicChartSymbolShape.diamond)
                            .foregroundStyle(.green)
                        }
                        .chartYAxis{
                            AxisMarks(position:.leading)
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(length: tablecontent.count > 40 ? 40: tablecontent.count)
                        .chartScrollTargetBehavior(.valueAligned(unit: 1))
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
                    .frame(height: 350)

                    VStack{
                        Text("Latitude, Longitude in Degrees/ Humidity in %")
                            .fontWidth(.expanded)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.primary)
                            .shadow(radius: 20)
                        Chart(tablecontent){ content in
                            AreaMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                     yStart: .value("second" , content.hum),
                                     yEnd: . value("end",0)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.blue.opacity(0.1))
                            LineMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                     y: .value("second" , content.hum)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.blue)

                            PointMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                      y: .value("second" , content.hum)
                            )
                            .interpolationMethod(.cardinal)
                            .symbol(BasicChartSymbolShape.square)
                            .foregroundStyle(.blue)
                            .cornerRadius(10)
                            .annotation{
                                Text("\(String(format:"%.0f" , content.hum))%")
                                    .font(.caption2)
                                    .fontWidth(.expanded)
                                    .foregroundStyle(.blue)
                            }
                            .symbolSize(100)
                        }
                        .chartYAxis{
                            AxisMarks(position:.leading)
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(length: tablecontent.count > 40 ? 40: tablecontent.count)
                        .chartScrollTargetBehavior(.valueAligned(unit: 1))
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
                    .padding(10)
                    .frame(height: 350)

                    VStack{
                        Text("Latitude, Longitude in Degrees/ Wind Speed in m/s")
                            .fontWidth(.expanded)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.primary)
                            .shadow(radius: 20)
                        Chart(tablecontent){ content in
                            AreaMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                     yStart: .value("second" , content.wind),
                                     yEnd: .value("end",0)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.yellow.opacity(0.1))
                            LineMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                     y: .value("second" , content.wind)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .foregroundStyle(.yellow)

                            PointMark(x: .value("first" ,"\(content.lat)\n\(content.lng)"),
                                      y: .value("second" , content.wind)
                            )
                            .interpolationMethod(.cardinal)
                            .cornerRadius(10)
                            .symbol(BasicChartSymbolShape.triangle)
                            .foregroundStyle(.yellow)
                            .annotation{
                                Text("\(String(format:"%.1f",content.wind))m/s")
                                    .font(.caption2)
                                    .fontWidth(.expanded)
                                    .foregroundStyle(.yellow)
                            }
                            .symbolSize(100)
                        }
                        .chartYAxis{
                            AxisMarks(position:.leading)
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartXVisibleDomain(length: tablecontent.count > 40 ? 40: tablecontent.count)
                        .chartScrollTargetBehavior(.valueAligned(unit: 1))
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
                    .frame(height: 350)
                }
            }
        }
    }
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
