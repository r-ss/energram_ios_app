//
//  DayPrice.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI

let jsonEncoder = JSONEncoder()

//let date = Date()
//let format = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss") // Set output format

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

struct MultipleDaysPriceResponse1: Codable {
    // price/latest
    var resource: String
    var content: MultipleDaysPriceResponse2
}

struct MultipleDaysPriceResponse2: Codable {
    var items: [DayPrice]
}

struct DayPriceResponse: Codable {
    // price/latest
    var resource: String
    var content: DayPrice
}

struct DayPrice: Codable, Identifiable {
    var id: UUID = UUID()
    var benchmark: Float
    var datasource: String
    var date: Date
    var received: Date
    var measure: String
    var data: [Float]
    
    var dateFormatted: String {
        let ftt = DateFormatter()
        ftt.locale = Locale(identifier: "en_US")
        ftt.setLocalizedDateFormatFromTemplate("EEEE, dMMMM")
        return ftt.string(from: self.date)
    }
    
    var receivedFormatted: String {
//        return Date.getFormattedDate(self.received)
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.dateFormat = self.received.getFormattedDate(format: "yyyy-MM-dd HH:mm")
//        return dateFormatter.string(from: self.received)
//
        let ftt = DateFormatter()
        ftt.locale = Locale(identifier: "en_US")
        ftt.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
        return ftt.string(from: self.received)
    }
    
    enum CodingKeys: CodingKey {
        case benchmark // note that id is not listed here
        case datasource
        case date
        case received
        case measure
        case data
    }
    
}

extension DayPrice {
    
//    jsonEncoder.outputFormatting = .prettyPrinted
    
    var as_json_string: String {
        do {
            let encodePerson = try jsonEncoder.encode(self)
            let endcodeStringPerson = String(data: encodePerson, encoding: .utf8)!
            return(endcodeStringPerson)
        } catch {
            return(error.localizedDescription)
        }
    }
}


//extension DayPrice {
//
//    var printUUID: String {
//        "UUID: \(self.id)"
//    }
//
//    var addedFormatted: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = self.added {
//            return "Added: \(dateFormatter.string(from: date))"
//        } else {
//            return "Added: - no record -"
//        }
//    }
//
//}

