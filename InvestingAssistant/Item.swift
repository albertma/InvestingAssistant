//
//  Item.swift
//  InvestingAssistant
//
//  Created by albertma on 2024/11/7.
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
