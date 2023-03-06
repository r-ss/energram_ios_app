//
//  AppliedAppliancesView.swift
//  Energram
//
//  Created by Alex Antipov on 05.03.2023.
//

import SwiftUI


//struct BoundsPreferenceKey: PreferenceKey {
//    typealias Value = Anchor<CGRect>?
//
//    static var defaultValue: Value = nil
//
//    static func reduce(
//        value: inout Value,
//        nextValue: () -> Value
//    ) {
//        value = nextValue()
//    }
//}



struct AppliedAppliancesView: View {
    
    @ObservedObject var dailyPlan: DailyPlan
    
    static let appliedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private let rowSpacing: CGFloat = 1.0
    private let rowHeight: CGFloat = 28.0
    private var rowPaddingHeight: CGFloat {
        rowHeight + rowSpacing
    }
    
    
    func startTimeToVerticalPosition(time: Date, duration: Int) -> CGFloat {
        //let d = CGFloat(duration)
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: time)
        //        let day = components.day ?? 0
        let hour = components.hour ?? 0
        //        let minute = components.minute ?? 0
        let y: CGFloat = CGFloat(hour) * rowPaddingHeight + slotHeight(duration: duration) / 2
        return y + 1
    }
    
    func slotHeight(duration: Int) -> CGFloat {
        let d = CGFloat(duration)
        var height = rowHeight * (d / 60)
        height = height + rowSpacing * (d / 60)
        return CGFloat( height - 3)
    }
    
    let slotFontSize: CGFloat = 14
    
    
    func durationToHumanReadable(_ durationInMinutes: Int) -> String {
        
        func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
            return (minutes / 60, (minutes % 60))
        }
        let tuple = minutesToHoursAndMinutes(durationInMinutes)
        return "\(tuple.hours):\( String(format: "%02d", tuple.leftMinutes) )"
    }
    
    
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        VStack(spacing: rowSpacing) {
                            ForEach(self.dailyPlan.hours, id:\.self) { hour in
                                //                            HourLabel(hour: hour, dailyPlan: dailyPlan)
                                
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(.tertiary)
                                        .frame(width: geometry.size.width, height: rowHeight)
                                    HStack {
                                        HourRow(hour: hour.id, dailyPlan: dailyPlan, rowWidth: geometry.size.width, rowHeight: rowHeight)
                                        //Text("\(hour.id):00").padding(.leading, 7)
                                    }
                                }
                            }
                        }
                        
                        Group {
                            
                            ForEach(self.dailyPlan.appliedAppliances.items, id: \.self) { aa in
                                VStack {
                                    
                                    
                                    
                                    
                                    ZStack(alignment: .leading) {
                                        //GeometryReader { rectG in
                                        Rectangle()
                                            .fill(Palette.brandPurple)
                                            .frame(width: geometry.size.width - 136, height: slotHeight(duration: aa.duration))
                                            .opacity(0.65)
                                            .border(Palette.brandPurpleLight, width: 1)
                                        HStack {
                                            //                                                Text("\(aa.duration) minutes").font(Font.system(size: slotFontSize))
                                            Text("\(aa.appliance.name) for \( durationToHumanReadable(aa.duration) ) hrs, \(aa.cost, specifier: "%.2f") €")
                                                .font(Font.system(size: slotFontSize))
                                                .frame(
                                                    
                                                    maxWidth: geometry.size.width - 100,
                                                    maxHeight: slotHeight(duration: aa.duration) - 8,
                                                    alignment: .topLeading)
                                            //                                                                    .background(.red)
                                            //                                                                    .opacity(0.65)
                                        }
                                        .padding(.leading, 7)
                                        //.position(x: geometry.size.width / 2 - 130, y: self.startTimeToVerticalPosition(time: aa.start, duration: aa.duration) - 150)
                                        //}
                                    }
                                    .position(x: geometry.size.width / 2 + 10, y: self.startTimeToVerticalPosition(time: aa.start, duration: aa.duration))
                                    //                                    .anchorPreference(
                                    //                                        key: BoundsPreferenceKey.self,
                                    //                                        value: .bounds
                                    //                                    ) { $0 }
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
            }
        }
    }
}

struct AppliedAppliancesView_Previews: PreviewProvider {
    static var previews: some View {
        AppliedAppliancesView(dailyPlan: DailyPlan(type: .preview))
    }
}
