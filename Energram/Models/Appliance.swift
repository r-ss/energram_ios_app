//
//  Appliance.swift
//  Energram
//
//  Created by Alex Antipov on 01.12.2022.
//

import Foundation
import SwiftUI

import UniformTypeIdentifiers

//let jsonEncoder = JSONEncoder()

//let date = Date()
//let format = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss") // Set output format


struct Appliance: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var typical_duration: Int
    var power: Int
    
    
    

    enum CodingKeys: CodingKey {
        case name // note that id is not listed here
        case typical_duration
        case power
    }
    
}

extension Appliance {
    
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

// DRAGGING
// https://serialcoder.dev/text-tutorials/swiftui/first-experience-with-transferable-implementing-drag-and-drop-in-swiftui/

extension UTType {
    static var applianceUItype = UTType(exportedAs: "com.ress.energram.TransferableType.appliance")
}

extension Appliance: Transferable {
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Appliance.self, contentType: .applianceUItype)
    }
    

}


struct SelectedAppliance: Identifiable {
    var id: UUID = UUID()
    var time_start: Int
    var time_end: Int
    var appliance: Appliance
    

//    enum CodingKeys: CodingKey {
//        case name // note that id is not listed here
//        case time_start
//        case time_end
//        case appliance
//    }
    
}
