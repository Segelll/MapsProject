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
    @State var nameentered : String = ""
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
            VStack{
                TextField("Symbol name",text: $nameentered)
                    .font(.subheadline)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                    .shadow(radius:20)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 170)
                    .padding(.bottom,-2)
                    .padding(.top,1)
                    .onSubmit {
                        if nameentered != ""{
                            centersymbol.append( Symbol( name:"mappin",
                                                         coordinate:centeronend!,
                                                         elevation: elevation!.elevation[0],
                                                         username: nameentered,
                                                         id: UUID()
                                                       ))
                            nameentered = ""
                        }
                    }
                HStack{
                    ForEach(applicablesymbol) { symbol in
                        
                        Button(action:{
                            centersymbol.append( Symbol( name:symbol.id,
                                                         coordinate:centeronend!,
                                                         elevation: elevation!.elevation[0],
                                                         username: nameentered,
                                                         id: UUID()
                                                         ))
                            nameentered = ""
                        },label:{
                            Image(systemName:symbol.id)
                        })
                    }
                    
                    
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .foregroundStyle(.black)
                .padding(5)
            }
        }
        if mode == 1 {
            ScrollView(.vertical){
                ForEach(centersymbol) { symbol in
                    HStack{
                        VStack{
                            Button(action:{
                                cameraPosition = .region (MKCoordinateRegion(center: symbol.coordinate ,latitudinalMeters: 12500,longitudinalMeters: 12500))
                            },label:{
                                VStack{
                                    HStack{
                                        
                                        Image(systemName:symbol.name)
                                        Text(symbol.username)
                                            .fontWidth(.expanded)
                                            .font(.footnote)
                                            .foregroundStyle(.black)
                                            .bold()
                                    }
                                    HStack{
                                        Text("\(String(format:"%.3f",symbol.coordinate.latitude))° , \(String(format:"%.3f",symbol.coordinate.longitude))° /")
                                            .fontWidth(.expanded)
                                            .font(.footnote)
                                            .foregroundStyle(.gray)
                                        Text("\(String(format:"%.0f",symbol.elevation))m")
                                            .fontWidth(.expanded)
                                            .font(.footnote)
                                            .foregroundStyle(.gray)
                                    }
                                }
                            })
                            Button(action:{
                                centersymbol.removeAll { $0.id == symbol.id }
                            },label:{
                                Text("Remove")
                                    .foregroundStyle(.red.opacity(0.7))
                                    .fontWidth(.expanded)
                                    .font(.footnote)
                                
                            })
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .foregroundStyle(.black)
                        .padding(5)
                        
                    }
                }
            }
        }
    }
}
struct AppSymbol : Identifiable {
 let id: String
}

