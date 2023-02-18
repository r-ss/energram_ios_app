//
//  DayTileView.swift
//  Energram
//
//  Created by Alex Antipov on 27.11.2022.
//

import SwiftUI

struct DayPlanView: View {
    
    
    @EnvironmentObject var applianceService: ApplianceService
    @EnvironmentObject var priceService: PriceService
    
    
    @State private var userReservedPower: Int = 0
    
    @ObservedObject var dailyPlan = DailyPlan()
    
    
    
//    let appliances: [Appliance] = []
    
    let tileHeight: CGFloat = 400
    
    var quarterWidth: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return (screenWidth - 40 - 3) / 4
    }
    
    var totalCost: Float {
        var total: Float = 0.0
        if let dp: DayPrice = priceService.dayPrice {
            for selAppliance in applianceService.selectedAppliances {
                let price = ( dp.data[selAppliance.time_start] * Float(selAppliance.appliance.power) ) / 1000
                total += price
            }
        }
        return total
    }
     
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    
                        Text("\(dailyPlan.publishedvar)")

                    
                    
                    if let dateFmt = priceService.dayPrice?.dateFormatted {
                        Text("Choose Consumers for \(dateFmt)").font(.headlineCustom)
                    } else {
                        Text("Consumers").font(.headlineCustom)
                    }
                    
                    if let receivedAppliances = applianceService.appliances {
                        ForEach(receivedAppliances) { appliance in
                            ApplianceLabel(appliance: appliance, isSelected: false, service: applianceService, dailyPlan: dailyPlan)
                        }
                    }
                    
                    
                    /*if let selectedAppliances = applianceService.selectedAppliances {
                        ForEach(selectedAppliances) { selected in
                            HStack {
                                Text(selected.appliance.name).fontWeight(.bold)
                                Text("start_hour: \(selected.time_start), power: \(selected.appliance.power)")
                            }
                        }
                    }*/


                  
                    Text("Daily plan").font(.headlineCustom).padding(.top, 20)
                    
                        
                        
                    
                    HStack(spacing: 1) {
                        
                        
                                              
                        
                        
                        ZStack {
                            Rectangle().fill(Palette.dayPlanNight).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Night").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                ForEach(0 ..< 6, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.dayPlanMorning).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Morning").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                ForEach(6 ..< 12, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.dayPlanDay).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Day").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                
                                ForEach(12 ..< 18, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.dayPlanEvening).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Evening").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                ForEach(18 ..< 24, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        
                        
                        
                    }
                    
                    Text("Reserved Power: \(self.userReservedPower) Watts")
                    
                    Text("Cost: €\(totalCost)").font(.headlineCustom).padding(.top, 10)
                    
                    if let dp = priceService.dayPrice {
                        MiniChart(forDay: dp)
                    }
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
                .onAppear {
                    //self.applianceService.myLocalPriceService.fetchData(for_country: "es")
                    self.userReservedPower = SettingsManager.shared.getIntegerValue(name: "ReservedPower")
                    
                    self.dailyPlan.priceService = priceService
                    
//                    if let data = priceService.dayPrice {
//                        self.dailyPlan.fillPrices(dayPrice: data)
//                    } else {
//                        print("no prices data")
//                    }
                }
            }
        }}
}

struct DayPlanView_Previews: PreviewProvider {
    
    @State static var applianceService = ApplianceService()
    
    
    static var previews: some View {
        DayPlanView().environmentObject(applianceService)
            .onAppear {
                self.applianceService.fetchAppliancesData()
            }
    }
}

