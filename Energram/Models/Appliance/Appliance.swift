//
//  Appliance.swift
//  Energram
//
//  Created by Alex Antipov on 01.12.2022.
//

import Foundation
import SwiftUI

import UniformTypeIdentifiers


struct Appliance: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var typical_duration: Int
    var power: Int
    var createdAt: Date = Date()
    var created_by: String?
    
    enum CodingKeys: String, CodingKey {
        case name // note that id is not listed here
        case typical_duration
        case power
        case created_by
        case createdAt = "created"
    }
    
        
//    init(name: String = "") {
//            self.id = UUID()
//            self.name = name
//            self.typical_duration = 1
//            self.power = 1
//            self.created_by = "Model"
//        }

    
}

// MARK: Mocked Data

extension Appliance {
    struct Mocked {

        let appliance1 = Appliance(name: "Kettel", typical_duration: 120, power: 2000, createdAt: Date())
        let appliance2 = Appliance(name: "Xbox", typical_duration: 60, power: 450, createdAt: Date())
    }

    static var mocked: Mocked {
        Mocked()
    }
}

// MARK: Initial Data

extension Appliance {
    struct Initial {
        let appliances = [
            Appliance(name: "Washing machine", typical_duration: 120, power: 425, createdAt: Date()),
            Appliance(name: "Dish wascher", typical_duration: 180, power: 1800, createdAt: Date()),
            Appliance(name: "Dryer", typical_duration: 60, power: 3500, createdAt: Date()),
            Appliance(name: "EV Charger", typical_duration: 180, power: 1200, createdAt: Date()),
            Appliance(name: "Iron", typical_duration: 360, power: 2500, createdAt: Date()),
            Appliance(name: "Boiler", typical_duration: 180, power: 1500, createdAt: Date()),
            Appliance(name: "Electric Sauna", typical_duration: 120, power: 5000, createdAt: Date())
        ]
    }

    static var initial: Initial {
        Initial()
    }
}


struct SelectedAppliance: Identifiable {
    
    /* Struct used in labels that selects which appliances will be used during the day */
    
    var id: UUID = UUID()
    var time_start: Int
    var time_end: Int
    var appliance: Appliance
}

//extension Appliance {
//
//    //    jsonEncoder.outputFormatting = .prettyPrinted
//
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


