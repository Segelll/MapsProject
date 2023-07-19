//
//  Authorization(View).swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 19.07.2023.
//

import SwiftUI

struct Authorization_View_: View {
    @State private var currentViewShowing: String = "login"
    @AppStorage("uid") var userid: String = ""
    var body: some View {
        if userid == ""{
            if(currentViewShowing == "login") {
                LoginView(currentShowingView: $currentViewShowing)
                
            } else {
                RegisterView(currentShowingView: $currentViewShowing)
                
            }
        }else{
            ContentView()
        }
    }
}

#Preview {
    Authorization_View_()
}
