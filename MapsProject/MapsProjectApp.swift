//
//  MapsProjectApp.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 4.07.2023.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct MapsProjectApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            Authorization_View_()
        }
        .modelContainer(for: Item.self)
    }
}
