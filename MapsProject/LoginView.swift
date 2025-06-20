//
//  LoginView.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 18.07.2023.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("email") var storedEmail: String = ""
    @AppStorage("password") var storedPassword: String = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errormessage : Bool = false
    @Binding var currentShowingView: String
    @Binding var isLoggedIn: Bool
    
    private func isValidPassword(_ password: String) -> Bool {
            let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z]).{6,}$")
            return passwordRegex.evaluate(with: password)
        }
    var body: some View {
        Image(systemName: "mappin.and.ellipse")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 100)
            .foregroundStyle(.red,.black)
            
            .padding(-15)
        Text("MapKit")
            .fontWidth(.expanded)
            .bold()
            .font(.largeTitle)
            .foregroundStyle(.black)

            .shadow(radius: 20)
        HStack{
            Image(systemName: "key.viewfinder")
                
                .foregroundStyle(.black,.red)
            Text("Log in")
                .fontWidth(.expanded)
                .font(.footnote)
                .foregroundStyle(.red)
            
                .shadow(radius: 20)
                .padding(.horizontal,-3)
            Text("to your account")
                .fontWidth(.expanded)
                .font(.footnote)
                .foregroundStyle(.black)
            
                .shadow(radius: 20)
            
        }
        
        
            HStack{
                
                ZStack{
                    TextField("User E-mail", text: $email)
                        .font(.subheadline)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 12).fill( email.isValidEmail() ? .green.opacity(0.2) : .clear))
                        .padding(3)
                        .background(RoundedRectangle(cornerRadius: 14).fill( email.isValidEmail() ? .green.opacity(0.2) : .clear))
                        .padding(1)
                        .shadow(radius:5)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 305, height: 100)
                        .onSubmit {
                            if email == storedEmail && password == storedPassword {
                                isLoggedIn = true
                            } else {
                                errormessage.toggle()
                            }
                        }
                    Image(systemName: "person.text.rectangle.fill")
                        .offset(x:115,y:0)
                }
            }
            HStack{
                
                ZStack{
                    SecureField("User Password", text: $password)
                        .font(.subheadline)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill( .white))
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 12).fill(isValidPassword(password) ? .green.opacity(0.2) : .clear))
                        .padding(3)
                        .background(RoundedRectangle(cornerRadius: 14).fill(isValidPassword(password) ? .green.opacity(0.2) : .clear))
                        .padding(1)
                        .shadow(radius:5)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 305, height: 100)
                        .onSubmit {
                            if email == storedEmail && password == storedPassword {
                                isLoggedIn = true
                            } else {
                                errormessage.toggle()
                            }
                        }
                    Image(systemName: "lock.fill")
                        .offset(x:115,y:0)
                }
                .padding(.vertical,-15)
                .padding(.top,-15)
                
                
            }
        HStack{
            Text("Don't have an account?")
                .fontWidth(.expanded)
                .font(.subheadline)
                .foregroundStyle(.black)
            
                .shadow(radius: 20)
            
            Button(action:{
                withAnimation {
                    self.currentShowingView = "register"
                }
            },label:{
                Text("Register")
                    .fontWidth(.expanded)
                    .font(.subheadline)
                    .foregroundStyle(.indigo)
                    .bold()
                    .shadow(radius: 20)
            })
            
        }
        .padding(.bottom,10)
        Button(action:{
            if email == storedEmail && password == storedPassword {
                isLoggedIn = true
            } else {
                errormessage.toggle()
            }
        },label:{
            Text("Login")
                .fontWidth(.expanded)
                .font(.callout)
                .foregroundStyle(.black)
                .bold()
                .frame(width:200, height: 55)
               
                .background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(radius: 5))
                .padding(.horizontal,5)
                .background(RoundedRectangle(cornerRadius: 18).fill(.red.opacity(0.4)).shadow(radius: 5))
                .padding(.horizontal,5)
                .background(RoundedRectangle(cornerRadius: 20).fill(.red.opacity(0.2)).shadow(radius: 5))
                
                
        })
      
        .popover(isPresented: $errormessage){
            ErrorView()
        }
        
    }

}
struct ErrorView:View{
    var body : some View{
        ZStack{
            Text("Invalid E-mail or password")
                .fontWidth(.expanded)
                .font(.callout)
                .foregroundStyle(.black)
                .bold()
               
        }
        .frame(width:300,height: 60)
    }
}
