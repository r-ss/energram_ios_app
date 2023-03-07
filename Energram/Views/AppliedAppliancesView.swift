//
//  AppliedAppliancesView.swift
//  Energram
//
//  Created by Alex Antipov on 05.03.2023.
//

import SwiftUI


struct AppliedAppliancesView: View {
    
    @ObservedObject var dailyPlan: DailyPlan
    @EnvironmentObject var currency: Currency
    
    @ObservedObject var aaaa: AppliedAppliances
    
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
    
    @State private var selectedCurrency: String = "EUR"
    @State private var currencyLatestCZK: Double = 23.0
    
    private func readSettings() {
        self.selectedCurrency = SettingsManager.shared.getStringValue(name: SettingsNames.selectedCurrency)
        self.currencyLatestCZK = SettingsManager.shared.getDoubleValue(name: SettingsNames.currencyLatestCZK)
    }
    
    func startTimeToVerticalPosition(time: Date, duration: Int) -> CGFloat {
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
    
    func offsetToTimeDiff(_ offset: CGFloat?) -> Int? {
        guard let diff = offset else {
            return nil
        }
        let timeDiff = diff * (60 / rowPaddingHeight)
        return Int(timeDiff)
    }
    
    func durationToHumanReadable(_ durationInMinutes: Int) -> String {
        
        func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
            return (minutes / 60, (minutes % 60))
        }
        let tuple = minutesToHoursAndMinutes(durationInMinutes)
        return "\(tuple.hours):\( String(format: "%02d", tuple.leftMinutes) )"
    }
    
    func calcDragLimit(initial: CGFloat, translate: CGFloat, duration: CGFloat) -> CGFloat {
        let bounds: (top: CGFloat, bottom: CGFloat) = (top: 0.0 + duration/4, bottom: 700.0 - duration/4)
        let intention = initial + translate
        
        let result = max( min(intention, bounds.bottom), bounds.top )
        
        //print("initial: \(initial), translate: \(translate), intention: \(intention), result: \(result), bounds: \(bounds.top)x\(bounds.bottom)")
        return result
    }
    
    func calculatePositionFor(aa: AppliedAppliance) -> Void {
        positions[aa.appliance.id] = startTimeToVerticalPosition(time: aa.start, duration: aa.duration)
    }
    
    @State private var positions: Dictionary<UUID, CGFloat> = [:]
//    @State private var lastPositions: Dictionary<UUID, CGFloat> = [:]
    
    @State private var offsets: Dictionary<UUID, CGFloat> = [:]
    @State private var lastOffsets: Dictionary<UUID, CGFloat> = [:]
    
    var momentLineShow: Bool {
        let todayComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        let today = todayComponents.day ?? 0
        
        guard let operatingWithDate = dailyPlan.price?.date else {
            return false
        }
        
        let operatingComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: operatingWithDate)
        let operatingDay = operatingComponents.day ?? 0
        
        if today == operatingDay {
            return true
        }
        return false
    }
    
    var momentLineY: CGFloat {
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date())
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        return CGFloat(hour) * rowPaddingHeight + ( (CGFloat(minute) / 60) * rowPaddingHeight )
        
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    VStack(spacing: rowSpacing) {
                        ForEach(0...23, id:\.self) { hour in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.tertiary)
                                    .frame(width: geometry.size.width, height: rowHeight)
                                HStack {
                                    HourRow(hour: hour, dailyPlan: dailyPlan, rowWidth: geometry.size.width, rowHeight: rowHeight)
                                    //Text("\(hour.id):00").padding(.leading, 7)
                                }
                            }
                        }
                    }
                    
                    Group {
                        ForEach(aaaa.items, id: \.self) { aa in
                            
                            //                            Text(aa.appliance.name)
                            VStack {
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Palette.brandPurple)
                                        .frame(width: geometry.size.width - 140, height: slotHeight(duration: aa.duration))
                                        .opacity(0.65)
                                        .addBorder(Palette.brandPurpleLight, width: 1, cornerRadius: 4)
                                    HStack {
                                        Text("\(aa.appliance.name) for \( durationToHumanReadable(aa.duration) ) hrs, \(aa.cost * currency.rate, specifier: "%.2f") \(currency.symbol)")
                                            .font(Font.system(size: 14))
                                            .frame(
                                                maxWidth: geometry.size.width - 150,
                                                maxHeight: max(slotHeight(duration: aa.duration) - 8, 3), // to avoid "Invalid frame dimension (negative or non-finite)"
                                                alignment: .topLeading)
                                        
                                    }
                                    .padding(.leading, 5)
                                }
                                .offset(y: offsets[aa.appliance.id] ?? 0)
                                .position(x: geometry.size.width / 2 - 16, y: positions[aa.appliance.id] ?? 0)
                                .onAppear {
//                                    withAnimation (Animation.easeInOut(duration: 1.25)) {
                                        calculatePositionFor(aa: aa)
//                                    }
                                }
                                
                                .gesture(
                                    DragGesture(minimumDistance: 1, coordinateSpace: .global)
                                        .onChanged { gesture in
                                            let initial: CGFloat = self.startTimeToVerticalPosition(time: aa.start, duration: aa.duration)
                                            let limitedY = calcDragLimit(initial: initial, translate: gesture.translation.height, duration: CGFloat(aa.duration))
                                            withAnimation (Animation.easeOut(duration: 0.35)) {
                                                offsets[aa.appliance.id] = (lastOffsets[aa.appliance.id] ?? 0) + limitedY - initial
                                            }
                                        }
                                        .onEnded { _ in
                                            
//                                            withAnimation (Animation.easeInOut(duration: 1.25)) {
//                                                calculatePositionFor(aa: aa)
//                                            }
                                            
                                            lastOffsets[aa.appliance.id] = offsets[aa.appliance.id]
                                            //}
                                            
                                            
                                            if let diff = offsetToTimeDiff(lastOffsets[aa.appliance.id]) {
//                                                print(diff)
                                                
//                                                withAnimation (Animation.easeInOut(duration: 1.25)) {
                                                dailyPlan.applyTimeDiffAfterDrag(aa: aa, diffRecieved: diff)

                                                
                                                
                                                lastOffsets[aa.appliance.id] = 0
                                                
                                                offsets[aa.appliance.id] = 0
                                                
                                                
                                                //                                                }
                                                
                                                
                                                
                                            }
                                        }
                                )
                                
                            }
                        }
                    }
                    
                    if momentLineShow {
                        ZStack {
                            Rectangle().fill(.black)
                                .frame(width: geometry.size.width, height: 4)
                                .opacity(0.65)
                            Rectangle().fill(.white)
                                .frame(width: geometry.size.width, height: 2)
                        }
                        .position(x: geometry.size.width / 2, y: momentLineY)
                        
                    }
                }
            }
            .onAppear {
                self.readSettings()
                
            }
        }
    }
}

struct AppliedAppliancesView_Previews: PreviewProvider {
    static var previews: some View {
        AppliedAppliancesView(dailyPlan: DailyPlan(type: .preview), aaaa: AppliedAppliances())
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
