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
        //formatter.dateFormat = "dd HH:mm"
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "Europe/London")
        return formatter
    }()
    
    private let rowHeight: CGFloat = 30.0
    private let rowPaddingHeight: CGFloat = 31.0
    
    
    func startTimeToVerticalPosition(time: Date, duration: Int) -> CGFloat {
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: time)
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        
        return rowPaddingHeight * CGFloat(hour) - CGFloat(duration) / 2
        
//        CGFloat(aa.duration) / 2
    }
    
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                VStack {
                    Text("Hello, World!")
                    
                    ZStack {
                        VStack(spacing: 1) {
                            ForEach(0 ..< 24, id:\.self) { hour in
                                //                            HourLabel(hour: hour, dailyPlan: dailyPlan)
                                
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(.tertiary)
                                        .frame(width: .infinity, height: rowHeight)
                                    HStack {
                                        Text("\(hour):00").padding(.leading, 7)
                                    }
                                }
                            }
                        }
                        
                        Group {
                            
                            ForEach(self.dailyPlan.appliedAppliances.items, id: \.self) { aa in
                                VStack {
                                    
                                    
                                    
                                    
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(.pink)
                                            .frame(width: geometry.size.width, height: CGFloat(aa.duration) / 2)
                                            .opacity(0.3)
                                            .border(.white, width: 1)
                                        HStack {
                                            Text("\(aa.start, formatter: Self.appliedDateFormatter)")
//                                            Text("\(aa.start)")
                                            Text("\(aa.duration) minutes")
                                            Text(aa.appliance.name)
                                        }
                                    }
                                    .position(x: geometry.size.width / 2 + 65, y: self.startTimeToVerticalPosition(time: aa.start, duration: aa.duration))
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
