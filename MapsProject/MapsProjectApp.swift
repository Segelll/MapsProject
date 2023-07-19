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
            Authorization_View_()
        }
        .modelContainer(for: Item.self)
    }
}
