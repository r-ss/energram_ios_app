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
                    
                    if selectedCurrency == "EUR" {
                        Text("Cost: €\( String(format: "%.2f", totalCost) )").font(.headlineCustom).padding(.top, 10)
                    }
                    if selectedCurrency == "CZK" {
                        Text("Cost: \( String(format: "%.1f", totalCost * Float(currencyLatestCZK)) ) CZK").font(.headlineCustom).padding(.top, 10)
                    }
                    
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
                    
                    self.readSettings()
                    //self.applianceService.myLocalPriceService.fetchData(for_country: "es")
                    
                    
                    if dailyPlan.price == nil || dailyPlan.price?.country != countryCode {
                        Task { await self.fetchLatestPrice(forCountry: countryCode) }
                    }
                    
                    if dailyPlan.appliances == nil {
                        Task { await self.fetchAppliances()}
                    }
                    
                    if let lastFetch = dailyPlan.lastFetch {
                        let difference = Date().timeIntervalSince(lastFetch)
                        if difference > 60*30 {
                            log("Updating prices because 20 minutes has passed")
                            Task { await self.fetchLatestPrice(forCountry: countryCode) }
                        }
                    }
                    
                    if currencyRates == nil {
                        Task { await self.fetchCurrencyRates()}
                    }
                    
                    
                }
            }
        }
        
    }
    
    // MARK: Private
    @State private var info: String = "not yet"
    @State private var appliancesLoading: Bool = false
    @State private var pricesLoading: Bool = false
    
    @State private var currencyRatesLoading: Bool = false
    
    
    
    @State private var currencyRates: CurrencyRateResponse?
    
    /// SETTINGS
    @State private var countryCode: String = "es"
    @State private var selectedCurrency: String = "EUR"
    @State private var currencyLatestCZK: Double = 23.0
    @State private var userReservedPower: Int = 4600
    
    
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
    
    private func readSettings() {
        self.countryCode = SettingsManager.shared.getStringValue(name: "CountryCode")
        self.selectedCurrency = SettingsManager.shared.getStringValue(name: "SelectedCurrency")
        self.currencyLatestCZK = SettingsManager.shared.getDoubleValue(name: "CurrencyLatestCZK")
        self.userReservedPower = SettingsManager.shared.getIntegerValue(name: "ReservedPower")
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
    
    
    private func fetchCurrencyRates() async {
        currencyRatesLoading = true
        Task(priority: .background) {
            if let rateCZK = await CurrencyRateService().fetchLatestRateCZK() {
                currencyLatestCZK = rateCZK
                Notification.fire(name: .latestCurrencyRatesRecieved)
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
