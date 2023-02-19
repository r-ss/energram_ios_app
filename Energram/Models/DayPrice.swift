//
//  DayPrice.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI

let jsonEncoder = JSONEncoder()


extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

struct DayPrice: Codable, Identifiable {
    var id: UUID = UUID()
    var country: String
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
        let ftt = DateFormatter()
        ftt.locale = Locale(identifier: "en_US")
        ftt.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
        return ftt.string(from: self.received)
    }
    
    enum CodingKeys: CodingKey {
        case date // note that id is not listed here
        case received
        case country
        case measure
        case data
    }
    
}

//extension DayPrice {
//    var as_json_string: String {
//        do {
//            let encodePerson = try jsonEncoder.encode(self)
//            let endcodeStringPerson = String(data: encodePerson, encoding: .utf8)!
//            return(endcodeStringPerson)
//        } catch {
//            return(error.localizedDescription)
//        }
//    }
//}
