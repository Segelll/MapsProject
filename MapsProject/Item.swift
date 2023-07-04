//
//  Item.swift
//  MapsProject
//
//  Created by Eyüp Berke Gülbetekin on 4.07.2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
