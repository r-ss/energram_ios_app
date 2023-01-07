//
//  ApplianceSlotInDailyPlan.swift
//  Energram
//
//  Created by Alex Antipov on 02.01.2023.
//

import SwiftUI

struct ApplianceSlotInDailyPlan: View {
    
    
    var text: String = "kek"
    
    var selectedAppliances: [SelectedAppliance] = []
    
    @State private var draggedApplianceItem: Appliance?
    
    @State private var borderColor: Color = .black
    @State private var borderWidth: CGFloat = 1.0
    
//    var appliancesForHour: [SelectedAppliance] {
//        return self.selectedAppliances.filter { $0.time_start == self.hour }
//    }
//

    
    var body: some View {
        
        
        
        VStack {
            if draggedApplianceItem != nil {
                Text(draggedApplianceItem!.name)
            } else {
                Text("Drag here!")
                    .foregroundColor(.secondary)
            }
        }
            .frame(maxWidth: 100, alignment: .leading)
            .border(borderColor, width: borderWidth)
            .background(Color.gray.opacity(0.25))
            .dropDestination(for: Appliance.self) { items, location in
                draggedApplianceItem = items.first
                print(location)
                return true
            } isTargeted: { inDropArea in
                print("In drop area", inDropArea)
                borderColor = inDropArea ? .accentColor : .black
                borderWidth = inDropArea ? 10.0 : 1.0
            }
        
        
        
//            .frame(width: 80, height: 20)
//            .contentShape(Rectangle())
//            .padding(0)
//            .foregroundColor(.black)
//            .onDrag({
//                NSItemProvider(object: self.text as NSString)
//            })
//            .draggable(text)
            //                     Text("Drop me")
            //                 }
        

       
    }
    
    
    
}

struct ApplianceSlotInDailyPlan_Previews: PreviewProvider {
    static var previews: some View {
        ApplianceSlotInDailyPlan()
    }
}
