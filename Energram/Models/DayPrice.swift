//
//  DayPrice.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI

let jsonEncoder = JSONEncoder()

struct DayPriceResponse: Codable {
    var resource: String
    var content: DayPrice
    
}

struct DayPrice: Codable {
    var benchmark: Float
    var datasource: String
    var date: String
    var received: String
    var measure: String
    var data: [Float]
    
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

