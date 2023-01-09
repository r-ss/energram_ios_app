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
    
    
    
    let appliances: [Appliance] = []
    
    let tileHeight: CGFloat = 390
    
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
                    
                    
                    if let dateFmt = priceService.dayPrice?.dateFormatted {
                        Text("Choose Consumers for \(dateFmt)").font(.title)
                    } else {
                        Text("Consumers").font(.title)
                    }
                    
                    if let receivedAppliances = applianceService.appliances {
                        ForEach(receivedAppliances) { appliance in
                            ApplianceLabel(appliance: appliance, isSelected: false, service: applianceService)
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


                  
                    Text("Daily plan").font(.title).padding(.top, 20)
                    
                        
                        
                    
                    HStack(spacing: 1) {
                        
                        
                                              
                        
                        
                        ZStack {
                            Rectangle().fill(Palette.b).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Night").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.black)
                                
                                ForEach(0 ..< 6, id:\.self) { hour in
                                    HourLabel(hour: hour, selectedAppliances: applianceService.selectedAppliances)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.d).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Morning").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.black)
                                
                                ForEach(6 ..< 12, id:\.self) { hour in
                                    HourLabel(hour: hour, selectedAppliances: applianceService.selectedAppliances)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.e).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Day").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.black)
                                
                                
                                ForEach(12 ..< 18, id:\.self) { hour in
                                    HourLabel(hour: hour, selectedAppliances: applianceService.selectedAppliances)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        ZStack {
                            Rectangle().fill(Palette.c).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Evening").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.black)
                                
                                ForEach(18 ..< 24, id:\.self) { hour in
                                    HourLabel(hour: hour, selectedAppliances: applianceService.selectedAppliances)
//                                    ApplianceSlotInDailyPlan()
                                }
                                
                            }.frame(width: quarterWidth, height: tileHeight, alignment: .topTrailing)
                        }
                        
                        
                        
                        
                    }
                    
                    Text("Cost: €\(totalCost)").font(.title).padding(.top, 10)
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
//                .onAppear {
//                    self.applianceService.myLocalPriceService.fetchData(for_country: "es")
//                }
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

