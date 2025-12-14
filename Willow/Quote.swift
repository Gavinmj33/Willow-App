//
//  Quote.swift
//  Willow
//
//  Created by Matthew Gavin on 12/12/25.
//

import Foundation

struct Quote: Identifiable, Codable {
    let id: UUID
    let text: String
    let author: String
    let period: TimePeriod
    
    enum TimePeriod: String, Codable, CaseIterable {
        case morning
        case day
        case evening
        case night
    }
    
    init(id: UUID = UUID(), text: String, author: String, period: TimePeriod) {
        self.id = id
        self.text = text
        self.author = author
        self.period = period
    }
}
