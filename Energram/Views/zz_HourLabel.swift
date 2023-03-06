//
//  HourLabel.swift
//  Energram
//
//  Created by Alex Antipov on 10.12.2022.
//

/*
import SwiftUI

struct HourLabel: View {
    
    var hour: Int = 0
    @ObservedObject var dailyPlan: DailyPlan
        
    var body: some View {
        
        
        VStack {
//            if let safe = accordingHour?.cheapIndex {
//                Text("\(hour):00, \(safe)").frame(maxWidth: 100, alignment: .leading).padding(7)
//            }
            Text("\(hour):00").frame(maxWidth: 100, alignment: .leading).padding(7)
                        
            ForEach(appliancesForHour) { appl in
                Text(appl.name)
                    .fontWeight(.bold)
                    .frame(width: 80, height: 20, alignment: .leading)
                    .padding(.bottom)
                    .foregroundColor(.white)
                    .draggable(appl) {
                        Text(appl.name).foregroundColor(Palette.brandGreen)
                    }
            }
        }
        .frame(maxWidth: 100, minHeight: 34, alignment: .leading)
        .contentShape(Rectangle())
        .border(.white, width: borderWidth)
        .dropDestination(for: Appliance.self) { items, location in
            draggedApplianceItem = items.first
            if let safeAppliance = draggedApplianceItem {
                dailyPlan.changeApplianceRunTime(appliance: safeAppliance, newStartTime: hour)
            }
            return true
        } isTargeted: { inDropArea in
            borderWidth = inDropArea ? 2.0 : 0.0
        }
        .background(cellBackground)
    }
    
    // MARK: Private
    
    private var accordingHour: Hour? {
        if let idx: Int = self.dailyPlan.hours.firstIndex(where: {$0.id == hour}) {
            return self.dailyPlan.hours[idx]
        }
        return nil
    }
    
    private var appliancesForHour: [Appliance] {
        if dailyPlan.hours.isEmpty {
            return []
        } else {
            return dailyPlan.hours[hour].appliancesAssigned
        }
    }
    
    private var cellBackground: Color {
        if let safe = accordingHour?.cheapIndex {
            let fl = CGFloat(safe)
            return Color(UIColor.blend(color1: UIColor(Palette.chartGreenTickColor), intensity1: 1-fl/24, color2: UIColor(Palette.chartRedTickColor), intensity2: fl/24))
        }
        return Palette.brandPurple
    }
    
    @State private var draggedApplianceItem: Appliance?
    @State private var borderWidth: CGFloat = 0.0
    
}

//struct HourLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        HourLabel(hour: 5)
//    }
//}

*/
