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
    var created_by: String
    
    enum CodingKeys: CodingKey {
        case name // note that id is not listed here
        case typical_duration
        case power
        case created_by
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

        let appliance1 = Appliance(name: "Kettel", typical_duration: 120, power: 2000, created_by: "alex")
        let appliance2 = Appliance(name: "Xbox", typical_duration: 60, power: 450, created_by: "Vanya")
    }

    static var mocked: Mocked {
        Mocked()
    }
}

// MARK: Initial Data

extension Appliance {
    struct Initial {
        let appliances = [
            Appliance(name: "EV Charger", typical_duration: 180, power: 1200, created_by: "alex"),
            Appliance(name: "Kettel", typical_duration: 30, power: 170, created_by: "Vanya")
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


