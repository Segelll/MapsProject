//
//  SymbolView.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 3.08.2023.
//

import SwiftUI
import MapKit
struct SymbolView: View {
    @Binding var centersymbol : [Symbol]
    @Binding var centeronend : CLLocationCoordinate2D?
    @Binding var elevation : ResponseBody2?
    @Binding var cameraPosition: MapCameraPosition
    @State var applicablesymbol : [AppSymbol] = [
        AppSymbol (id:"figure.wave"),
        AppSymbol (id:"mappin"),
        AppSymbol (id:"car.fill"),
        AppSymbol (id:"tram.fill"),
        AppSymbol (id:"bus.fill"),
        AppSymbol (id:"binoculars.fill"),
        AppSymbol (id:"flag.checkered"),
        AppSymbol (id:"antenna.radiowaves.left.and.right")
    ]
    @State var mode : Int = 0
    var body: some View {
        Picker("Mode",selection:$mode.animation(.easeInOut)){
            Text("New").tag(0)
            Text("Current").tag(1)
            
        }
        .pickerStyle(.segmented)
        .foregroundStyle(.black)
        if mode == 0 {
            HStack{
            ForEach(applicablesymbol) { symbol in
                
                    Button(action:{
                        centersymbol.append( Symbol( name:symbol.id,
                                                     coordinate:centeronend!,
                                                     elevation: elevation!.elevation[0],
                                                     id: UUID()))
                    },label:{
                        Image(systemName:symbol.id)
                    })
                }
                
             
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
            .foregroundStyle(.black)
            .padding(10)
        }
        if mode == 1 {
            ForEach(centersymbol) { symbol in
                HStack{
                    VStack{
                        Button(action:{
                            cameraPosition = .region (MKCoordinateRegion(center: symbol.coordinate ,latitudinalMeters: 12500,longitudinalMeters: 12500))
                        },label:{
                            Image(systemName:symbol.name)
                            Text("\(String(format:"%.3f",symbol.coordinate.latitude))° , \(String(format:"%.3f",symbol.coordinate.longitude))° /")
                                .fontWidth(.expanded)
                                .font(.footnote)
                            Text("\(String(format:"%.0f",symbol.elevation))m")
                                .fontWidth(.expanded)
                                .font(.footnote)
                        })
                        Button(action:{
                            centersymbol.removeAll { $0.id == symbol.id }
                        },label:{
                            Text("Remove")
                                .foregroundStyle(.red)
                                .fontWidth(.expanded)
                                .font(.footnote)
                            
                        })
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                    .foregroundStyle(.black)
                    .padding(10)
                }
            }
        }
    }
}
struct AppSymbol : Identifiable {
 let id: String
}

