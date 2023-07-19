//
//  Authorization(View).swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 19.07.2023.
//

import SwiftUI

struct Authorization_View_: View {
    @State private var currentViewShowing: String = "login"
    var body: some View {
        if(currentViewShowing == "login") {
                   LoginView(currentShowingView: $currentViewShowing)
                     
               } else {
                   RegisterView(currentShowingView: $currentViewShowing)
                       
               }
    }
}

#Preview {
    Authorization_View_()
}
