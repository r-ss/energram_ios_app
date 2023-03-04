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
                        
                        TagCloudView(appliances: receivedAppliances, passedDailyPlan: dailyPlan)
                        
                        //                        HStack {
                        //                            ForEach(receivedAppliances) { appliance in
                        //                                ApplianceLabel(appliance: appliance, isSelected: false, dailyPlan: dailyPlan)
                        //                            }
                        //                        }
                        
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
                    
                    NotificationCenter.listen(name: .applianceLabelLongTapEvent, completion: { name in
                        print("Requested appliance customization for: \(name)")
                        
                        if let a = dailyPlan.appliances?.first {
                            self.selectedAppliance = a
                            //                            print(a)
                            //                            showingApplianceDetailsView = true
                        }
                        
                        
                        
                    })
                    
                    
                }
                .sheet(item: $selectedAppliance) { a in
                    VStack(alignment: .leading) {
                        Text("Appliance Detail View").font(Font.system(size: 22)).padding(.bottom, 15)
                        
                        Text("Name: \(a.name)")
                        Text("Id: \(a.id)").font(Font.system(size: 14).monospaced())
                        Text("Power: \(a.power)")
                    }
                    .presentationDetents([.medium, .fraction(0.75)])
                    
                }
            }
        }
        
    }
    
    // MARK: Private
    //    @State private var showingApplianceDetailsView = false
    @State private var selectedAppliance: Appliance?
    
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
        self.countryCode = SettingsManager.shared.getStringValue(name: SettingsNames.countryCode)
        self.selectedCurrency = SettingsManager.shared.getStringValue(name: SettingsNames.selectedCurrency)
        self.currencyLatestCZK = SettingsManager.shared.getDoubleValue(name: SettingsNames.currencyLatestCZK)
        self.userReservedPower = SettingsManager.shared.getIntegerValue(name: SettingsNames.reservedPower)
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

struct DayPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DayPlanView(dailyPlan: DailyPlan())
    }
}


struct TagCloudView: View {
    var appliances: [Appliance]
    var passedDailyPlan: DailyPlan
    
    @State private var totalHeight
    = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.appliances, id: \.self) { appliance in
                self.item(for: appliance)
                    .padding([.horizontal, .vertical], 2)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if appliance == self.appliances.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if appliance == self.appliances.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    private func item(for appliance: Appliance) -> some View {
        ApplianceLabel(appliance: appliance, isSelected: false, dailyPlan: passedDailyPlan)
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
