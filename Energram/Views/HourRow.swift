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
    @EnvironmentObject private var currency: Currency
    
    var rowWidth: CGFloat = 200
    var rowHeight: CGFloat = 30
        
    var body: some View {
        HStack {
            Text("\(hour):00").font(Font.system(size: slotFontSize)).padding(.leading, 7)
//
//            if let h = accordingHour {
//                Text("pw: \(h.usedPower)")
//            }
            
            
            Spacer()
            Text("\(accordingHourPrice * currency.rate, specifier: "%.2f") \(currency.powerUsageNotation)").font(Font.system(size: 12)).padding(.trailing, 7)
        }
        .frame(width: rowWidth, height: rowHeight, alignment: .leading)
        .background(cellBackground)
    }
    
    // MARK: Private
    
    private let slotFontSize: CGFloat = 16
    
//    private var accordingHour: Int? {
//        if let idx: Int = self.dailyPlan.hours.firstIndex(where: {$0.id == hour}) {
//            return self.dailyPlan.hours[idx]
//        }
//        return nil
//    }
    
    private var accordingHourPrice: Float {
//        if let idx: Int = self.dailyPlan.hours.firstIndex(where: {$0.id == hour}) {
//            return self.dailyPlan.hours[idx].price
//        }
        if let prices = self.dailyPlan.price?.data {
            return prices[self.hour]
        }
        return 0.0
    }
    
//    private var appliancesForHour: [Appliance] {
//        if dailyPlan.hours.isEmpty {
//            return []
//        } else {
//            return dailyPlan.hours[hour].appliancesAssigned
//        }
//    }
    
    private var cellBackground: Color {
        if let prices = dailyPlan.price?.data {
            let pmax: Float = prices.max()!
            let pmin: Float = prices.min()!
            let diff: Float = pmax - pmin
            let fl = CGFloat( (accordingHourPrice - pmin) / diff  )
            return Color(UIColor.blend(color1: UIColor(Palette.chartGreenTickColor), intensity1: 1-fl, color2: UIColor(Palette.chartRedTickColor), intensity2: fl))
        }
        return Palette.brandPurple
    }
    
    @State private var draggedApplianceItem: Appliance?
    @State private var borderWidth: CGFloat = 0.0
    
}

struct HourLabel_Previews: PreviewProvider {
    static var previews: some View {
        HourRow(hour: 5, dailyPlan: DailyPlan(type: .preview), rowWidth: 360)
    }
}
