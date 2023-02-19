//
//  DayTileView.swift
//  Energram
//
//  Created by Alex Antipov on 27.11.2022.
//

import SwiftUI

struct DayPlanView: View {
    @ObservedObject var dailyPlan: DailyPlan
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    if let dateFmt = dailyPlan.price?.dateFormatted {
                        Text("Choose Consumers for \(dateFmt)").font(.headlineCustom)
                    } else {
                        Text("Consumers").font(.headlineCustom)
                    }
                    
                    if let receivedAppliances = dailyPlan.appliances {
                        ForEach(receivedAppliances) { appliance in
                            ApplianceLabel(appliance: appliance, isSelected: false, dailyPlan: dailyPlan)
                        }
                    } else {
                        if appliancesLoading {
                            LoaderSpinner()
                        } else {
                            Text("Error in receiving appliances list")
                        }
                    }
                    
                    Text("Daily plan").font(.headlineCustom).padding(.top, 20)
                    
                    HStack(spacing: 1) {
                        ZStack {
                            //                            Rectangle().fill(Palette.dayPlanNight).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Night").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                ForEach(0 ..< 6, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
                                }
                                
                            }.frame(maxHeight: .infinity, alignment: .top)
                        }
                        ZStack {
                            //                            Rectangle().fill(Palette.dayPlanMorning).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Morning").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                ForEach(6 ..< 12, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
                                }
                                
                                
                            }.frame(maxHeight: .infinity, alignment: .top)
                        }
                        ZStack {
                            //                            Rectangle().fill(Palette.dayPlanDay).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Day").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                
                                ForEach(12 ..< 18, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
                                }
                                
                            }.frame(maxHeight: .infinity, alignment: .top)
                        }
                        ZStack {
                            //                            Rectangle().fill(Palette.dayPlanEvening).frame(width: quarterWidth, height: tileHeight)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Evening").frame(maxWidth: quarterWidth, alignment: .leading).padding(7).fontWeight(.bold).foregroundColor(.white)
                                
                                ForEach(18 ..< 24, id:\.self) { hour in
                                    HourLabel(hour: hour, dailyPlan: dailyPlan)
                                }
                                
                            }.frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    
                    Text("Reserved Power: \(self.userReservedPower) Watts")
                    Text("Cost: €\(totalCost)").font(.headlineCustom).padding(.top, 10)
                    
                    if let dp = dailyPlan.price {
                        MiniChart(forDay: dp)
                    } else {
                        if pricesLoading {
                            LoaderSpinner()
                        } else {
                            Text("Error in receiving chart data")
                        }
                    }
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
                .onAppear {
                    //self.applianceService.myLocalPriceService.fetchData(for_country: "es")
                    self.userReservedPower = SettingsManager.shared.getIntegerValue(name: "ReservedPower")
                    
                    let countryCode = SettingsManager.shared.getStringValue(name: "CountryCode")
                    
                    
                    if dailyPlan.price == nil || dailyPlan.price?.country != countryCode {
                        
                        Task { await self.fetchLatestPrice(forCountry: countryCode) }
//                        dailyPlan.appliances = nil // loading them again to reset switched-on state for all
                    }
                    
                    if dailyPlan.appliances == nil {
                        Task { await self.fetchAppliances()}
                    }
                    
                }
            }
        }
        
    }
    
    // MARK: Private
    @State private var info: String = "not yet"
    @State private var appliancesLoading: Bool = false
    @State private var pricesLoading: Bool = false
    
    @State private var userReservedPower: Int = 0
    
    private let tileHeight: CGFloat = 200
    private var quarterWidth: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return (screenWidth - 40 - 3) / 4
    }
    
    private var totalCost: Float {
        var total: Float = 0.0
        if let pd = dailyPlan.price {
            for (index, hour) in dailyPlan.hours.enumerated() {
                for appliance in hour.appliancesAssigned {
                    let cost = ( pd.data[index] * Float(appliance.power) ) / 1000
                    total += cost
                }
            }
        }
        return total
    }
    
    private func fetchAppliances() async {
        appliancesLoading = true
        Task(priority: .background) {
            let response = await EnergramService().fetchAppliances()
            switch response {
            case .success(let result):
                dailyPlan.appliancesReceived(appliances: result)
                appliancesLoading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                appliancesLoading = false
            }
        }
    }
    
    private func fetchLatestPrice(forCountry code: String) async {
        pricesLoading = true
        Task(priority: .background) {
            let response = await EnergramService().fetchLatestPrice(forCountry: code)
            switch response {
            case .success(let result):
                dailyPlan.priceReceived(price: result)
                pricesLoading = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                pricesLoading = false
            }
        }
    }
    
}

//struct DayPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayPlanView()
//    }
//}
//
