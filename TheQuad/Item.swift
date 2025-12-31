//
//  Item.swift
//  TheQuad
//
//  Created by Shivam Patel on 12/30/25.
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
