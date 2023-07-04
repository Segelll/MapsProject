//
//  MapsProjectApp.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 4.07.2023.
//

import SwiftUI
import SwiftData

@main
struct MapsProjectApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
