import SwiftUI

struct SelectionScreen:View{
    @Binding var selectkm : Bool
    var body:some View{
        VStack{
            Text("for Time")
                .fontWidth(.expanded)
                .font(.footnote)
                .foregroundStyle(.black)

                .frame(width:120, height: 55)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .shadow(radius: 20)
            HStack{
                Button(action:{
                    selectkm.toggle()
                },label:{
                    Text("24h")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                    Text("12h")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.white)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                        .shadow(radius: 20)
                })
            }
        }
        VStack{
            Text("for Elevation")
                .fontWidth(.expanded)
                .font(.footnote)
                .foregroundStyle(.black)

                .frame(width:120, height: 55)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .shadow(radius: 20)
            HStack{
                Button(action:{
                },label:{
                    Text("m")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                    Text("Km")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)

                    Text("yd")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.white)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                        .shadow(radius: 20)
                    Text("mi")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.white)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                        .shadow(radius: 20)


                })
        }
        VStack{
            Text("for MapPins")
                .fontWidth(.expanded)
                .font(.footnote)
                .foregroundStyle(.black)

                .frame(width:120, height: 55)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .shadow(radius: 20)
            HStack{
                Button(action:{

                },label:{
                    Text("m")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                    Text("Km")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)

                    Text("yd")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.white)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                        .shadow(radius: 20)
                    Text("mi")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.white)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                        .shadow(radius: 20)


                })
                Button(action:{
                },label:{
                    Text("Rad")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.red)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                    Text("Deg")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)

                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                })
            }
        }
                VStack{
                    Text("for Weather")
                        .fontWidth(.expanded)
                        .font(.footnote)
                        .foregroundStyle(.black)

                        .frame(width:120, height: 55)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .shadow(radius: 20)
                    HStack{
                        Button(action:{

                        },label:{
                            Text("°C")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.black)

                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                            Text("°F")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.white)

                                .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                                .shadow(radius: 20)
                            Text("K")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.red)

                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                        })
                        Button(action:{

                        },label:{
                            Text("m/s")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.black)


                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                            Text("mph")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                                .shadow(radius: 20)
                        })
                        Button(action:{
                        },label:{
                            Text("Rad")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.black)

                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                            Text("Deg")
                                .fontWidth(.expanded)
                                .font(.footnote)
                                .foregroundStyle(.black)

                                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                .shadow(radius: 20)
                        })

                    }
                }

        }

    }
}
