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
        
//        print(y)
        return y + 1
    }
    
    func slotHeight(duration: Int) -> CGFloat {
        let d = CGFloat(duration)
        var height = rowHeight * (d / 60)
        height = height + rowSpacing * (d / 60)
        return CGFloat( height - 3)
    }
    
    func offsetToTimeDiff(_ offset: CGFloat?) -> Int? {
        
        guard let diff = offset else {
            return nil
        }
        
        let timeDiff = diff * (60 / rowPaddingHeight)
        
        return Int(timeDiff)
        
    }
    
    let slotFontSize: CGFloat = 14
    
    
    func durationToHumanReadable(_ durationInMinutes: Int) -> String {
        
        func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
            return (minutes / 60, (minutes % 60))
        }
        let tuple = minutesToHoursAndMinutes(durationInMinutes)
        return "\(tuple.hours):\( String(format: "%02d", tuple.leftMinutes) )"
    }
    
    
    //    @State private var location: CGPoint = CGPoint(x: 0, y: 0) // 1
    //
    //    @GestureState private var fingerLocation: CGPoint? = nil
    
    @State private var offsets: Dictionary<UUID, CGFloat> = [:]
    @State private var lastOffsets: Dictionary<UUID, CGFloat> = [:]
    
    //        @State private var offsetY: CGFloat = 0
    //        @State private var lastOffsetY: CGFloat = 0
    
    //    var fingerDrag(initialY: CGFloat): some Gesture {
    //        DragGesture()
    //            .updating($fingerLocation) { (value, fingerLocation, transaction) in // 1, 2
    //                fingerLocation = value.location // 3
    //            }
    //    }
    
    var body: some View {
        //        ScrollView {
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
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Palette.brandPurple)
                                        .frame(width: geometry.size.width - 130, height: slotHeight(duration: aa.duration))
                                        .opacity(0.65)
                                        .addBorder(Palette.brandPurpleLight, width: 1, cornerRadius: 4)
                                    //                                            .stroke(Color.black, lineWidth: 1)
                                    //                                            .border(Palette.brandPurpleLight, width: 1, cornerRadius: 10)
                                    HStack {
                                        //                                                Text("\(aa.duration) minutes").font(Font.system(size: slotFontSize))
                                        Text("\(aa.appliance.name) \(aa.start) for \( durationToHumanReadable(aa.duration) ) hrs, \(aa.cost, specifier: "%.2f") €")
                                            .font(Font.system(size: slotFontSize))
                                            .frame(
                                                maxWidth: geometry.size.width - 140,
                                                maxHeight: slotHeight(duration: aa.duration) - 8,
                                                alignment: .topLeading)
                                                                                                            .background(.red)
                                                                                                            .opacity(0.65)
                                    }
                                    .padding(.leading, 5)
                                    //.position(x: geometry.size.width / 2 - 130, y: self.startTimeToVerticalPosition(time: aa.start, duration: aa.duration) - 150)
                                    //}
                                }
                                .offset(y: offsets[aa.appliance.id] ?? 0)
                                .position(x: geometry.size.width / 2 - 13, y: self.startTimeToVerticalPosition(time: aa.start, duration: aa.duration))
                                
                                .gesture(
                                    DragGesture(minimumDistance: 1, coordinateSpace: .global)
                                        .onChanged { gesture in
                                            //withAnimation(.spring()) {
                                            
//                                            print(geometry.size.width)

                                            //                                                            let uuid: UUID = aa.appliance.id
                                            //print(uuid)
                                            //offsetY = lastOffsetY + gesture.translation.height

                                            offsets[aa.appliance.id] = (lastOffsets[aa.appliance.id] ?? 0) + gesture.translation.height

                                            //}
                                        }
                                        .onEnded { _ in
                                            //lastOffsetY = offsetY
                                            lastOffsets[aa.appliance.id] = offsets[aa.appliance.id]
                                            
//                                            print( offsetToTimeDiff(lastOffsets[aa.appliance.id]))
                                            
                                            if let diff = offsetToTimeDiff(lastOffsets[aa.appliance.id]) {
                                                lastOffsets[aa.appliance.id] = 0
                                                offsets[aa.appliance.id] = 0
                                                
                                                dailyPlan.applyTimeDiffAfterDrag(aa: aa, diffRecieved: diff)
                                            }
                                        }
                                )
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
                //                }
            }
        }
    }
}

struct AppliedAppliancesView_Previews: PreviewProvider {
    static var previews: some View {
        AppliedAppliancesView(dailyPlan: DailyPlan(type: .preview))
    }
}

fileprivate extension View {
    func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        // https://stackoverflow.com/questions/57753997/rounded-borders-in-swiftui
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
