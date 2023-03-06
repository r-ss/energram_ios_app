//
//  AppliedAppliance.swift
//  Energram
//
//  Created by Alex Antipov on 05.03.2023.
//

import Foundation

struct AppliedAppliance: Identifiable, Hashable {
    var id: UUID = UUID()
    var start: Date
    var duration: Int
    var appliance: Appliance
    var cost: Float = 0.0
}

// MARK: Mocked Data

extension AppliedAppliance {
    struct Mocked {
        var aa1: AppliedAppliance
        var aa2: AppliedAppliance
        var aa3: AppliedAppliance
        var aa4: AppliedAppliance
        var aa5: AppliedAppliance
        init() {
            func dateFromISOString(_ isoString: String) -> Date? {
                let formatter = DateFormatter()
                formatter.timeZone = .gmt
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                return formatter.date(from: isoString)
            }
            
            
            
            
            
            
            

            self.aa1 = AppliedAppliance(start: dateFromISOString("2023-03-05T10:00:00+03:00")!, duration: 120, appliance: Appliance.mocked.appliance1)
            self.aa2 = AppliedAppliance(start: dateFromISOString("2023-03-05T12:00:00+03:00")!, duration: 60, appliance: Appliance.mocked.appliance2)
            self.aa3 = AppliedAppliance(start: dateFromISOString("2023-03-05T14:00:00+03:00")!, duration: 30, appliance: Appliance.mocked.appliance1)
            self.aa4 = AppliedAppliance(start: dateFromISOString("2023-03-01T01:00:00+03:00")!, duration: 60*6, appliance: Appliance.mocked.appliance1)
            self.aa5 = AppliedAppliance(start: dateFromISOString("2023-03-01T15:00:00+03:00")!, duration: 60*6, appliance: Appliance.mocked.appliance1)
        }
    }
    
    static var mocked: Mocked {
        Mocked()
    }
}

class AppliedAppliances: ObservableObject {
    
    @Published var items: [AppliedAppliance] = []
    
    func add(appliance: Appliance, hour: Int, cost: Float) {
        
        let date = Date()
        let midnight = Calendar.current.date(bySettingHour: 00, minute: 0, second: 0, of: date)!
        let adjusted = Calendar.current.date(byAdding: .hour, value: hour, to: midnight)!
        
        
                
        let aa = AppliedAppliance(start: adjusted, duration: appliance.typical_duration, appliance: appliance, cost: cost)
        self.items.append(aa)
    }
    
    func remove(appliance: Appliance) {
        items = items.filter(){$0.appliance.id != appliance.id}
    }
}
