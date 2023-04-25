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
//        ftt.locale = Locale(identifier: "en_US")
        ftt.setLocalizedDateFormatFromTemplate("EEEE, dMMMM")
        return ftt.string(from: self.date)
    }
    
    var receivedFormatted: String {
        let ftt = DateFormatter()
//        ftt.locale = Locale(identifier: "en_US")
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


// MARK: Mocked Data

extension DayPrice {
    struct Mocked {
        
        var day1: DayPrice
        var day2: DayPrice
        
        init() {
            self.day1 = DayPrice(country: "es", date: dateFromISOString("2023-03-05T00:00:00+03:00")!, received: dateFromISOString("2023-03-04T21:00:00+03:00")!, measure: "€/kWh", data: [
                0.20349,
                0.20756,
                0.20229,
                0.19304,
                0.19045,
                0.19328,
                0.1843,
                0.18688,
                0.22227,
                0.21772,
                0.26296,
                0.26524,
                0.26225,
                0.25623,
                0.20929,
                0.21233,
                0.21599,
                0.21946,
                0.26698,
                0.28413,
                0.29319,
                0.27491,
                0.22146,
                0.21404
            ])
            self.day2 = DayPrice(country: "cz", date: dateFromISOString("2023-03-05T00:00:00+03:00")!, received: dateFromISOString("2023-03-04T21:00:00+03:00")!, measure: "€/kWh", data: [
                0.13782,
                0.12538,
                0.12551,
                0.12455,
                0.12428,
                0.13788,
                0.1598,
                0.185,
                0.21709,
                0.18835,
                0.17026,
                0.16084,
                0.15058,
                0.14544,
                0.14452,
                0.14699,
                0.15263,
                0.16187,
                0.18473,
                0.17799,
                0.15108,
                0.13364,
                0.11728,
                0.10206
            ])
        }
    }
    
    static var mocked: Mocked {
        Mocked()
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
