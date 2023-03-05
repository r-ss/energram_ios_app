//
//  HourRow.swift
//  Energram
//
//  Created by Alex Antipov on 05.03.2023.
//

import SwiftUI

struct HourRow: View {
    
    var hour: Int = 0
    @ObservedObject var dailyPlan: DailyPlan
    
    var rowWidth: CGFloat
    var rowHeight: CGFloat
        
    var body: some View {
        Text("\(hour):00").frame(width: rowWidth, height: rowHeight, alignment: .leading).padding(.leading, 7)
        .contentShape(Rectangle())
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
