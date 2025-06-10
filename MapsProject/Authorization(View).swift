//
//  Authorization(View).swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 19.07.2023.
//

import SwiftUI

struct Authorization_View_: View {
    @State private var currentViewShowing: String = "login"
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        if !isLoggedIn {
            if currentViewShowing == "login" {
                LoginView(currentShowingView: $currentViewShowing, isLoggedIn: $isLoggedIn)
            } else {
                RegisterView(currentShowingView: $currentViewShowing, isLoggedIn: $isLoggedIn)
            }
        } else {
            ContentView()
        }
    }
}

#Preview {
    Authorization_View_()
}
