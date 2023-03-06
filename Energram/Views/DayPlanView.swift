//
//  DayTileView.swift
//  Energram
//
//  Created by Alex Antipov on 27.11.2022.
//

import SwiftUI

struct DayPlanView: View {
    @ObservedObject var dailyPlan: DailyPlan
    
    //    @StateObject var appliancesListViewModel = AppliancesListViewModel()
    
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    if let dateFmt = dailyPlan.price?.dateFormatted {
                        Text("Choose Consumers for \(dateFmt)").font(.headlineCustom)
                    } else {
                        Text("Consumers").font(.headlineCustom)
                    }
                    
                    if let dpAppliances = dailyPlan.appliancesListViewModel.appliances {
                        
                        Group {
                            TagCloudView(appliances: dpAppliances, passedDailyPlan: dailyPlan)
                            
                            HStack {
                                
                                if dpAppliances.count > 0 && !areAppliancesLabelsTouchLearned{
                                    Image(systemName: "arrow.up.forward").font(.system(size: 20)).padding(.trailing, 2)
                                    Text("Tap and hold to customize").font(.system(size: 16)).padding(.trailing, 10)
                                }
                                
                                Button(){
                                    showingApplianceCreateView = true
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.app").font(.system(size: 20)).padding(0)
                                        Text("Add").font(.system(size: 16))
                                    }
                                }
                                
                            }
                        }
                        
                        
                    } else {
                        Text("Error in receiving appliances list")
                    }
                    
                    Text("Daily plan").font(.headlineCustom)//.padding(.top, 20)
                    
                    if let _ = dailyPlan.price {
                        AppliedAppliancesView(dailyPlan: dailyPlan).frame(width: geometry.size.width - 20, height: 29*24-1)
                    } else {
                        LoaderSpinner()
                    }
                    
                    
                    Group {
                        Text("Reserved Power: \(self.userReservedPower) Watts")
                        
                        if selectedCurrency == "EUR" {
                            Text("Cost: €\( String(format: "%.2f", dailyPlan.appliedAppliances.totalCost) )").font(.headlineCustom).padding(.top, 10)
                        }
                        if selectedCurrency == "CZK" {
                            Text("Cost: \( String(format: "%.1f", dailyPlan.appliedAppliances.totalCost * Float(currencyLatestCZK)) ) CZK").font(.headlineCustom).padding(.top, 10)
                        }
                        
                        if let dp = dailyPlan.price {
                            if let dateFmt = dailyPlan.price?.dateFormatted {
                                Text("Electricity price graph for \(dateFmt):").padding(.top, 20)
                            }
                            MiniChart(forDay: dp)
                        } else {
                            if pricesLoading {
                                LoaderSpinner()
                            } else {
                                Text("Error in receiving chart data")
                            }
                        }
                        
                    }.padding(0)
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
                .onAppear {
                    self.readSettings()
                    
                    if dailyPlan.price == nil || dailyPlan.price?.country != countryCode {
                        
                        dailyPlan.appliedAppliances.items = []
                        
                        Task { await self.fetchLatestPrice(forCountry: countryCode) }
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
                    
                    
                    // Subscribing to appliance-related notifications
                    NotificationCenter.simple(name: .someApplianceLabelLongTapEvent){
                        if !areAppliancesLabelsTouchLearned {
                            print("Setting .areAppliancesLabelsTouchLearned to true...")
                            SettingsManager.shared.setValue(name: .areAppliancesLabelsTouchLearned, value: true)
                            withAnimation {
                                areAppliancesLabelsTouchLearned = true
                            }
                        }
                    }
                    
                    NotificationCenter.listen(name: .applianceModified, completion: { payload in
                        
                        let uuidString = payload as! String
                        
                        if let modifiedAppliance = dailyPlan.getAppliancebyId(uuidString) {
                            withAnimation {
                                dailyPlan.applianceModified(appliance: modifiedAppliance)
                            }
                        }
                    })
                    
                    NotificationCenter.listen(name: .applianceWillBeRemoved, completion: { payload in
                        
                        print("applianceRemoved event listener tick")
                        
                        let uuidString = payload as! String
                        
                        if let applianceToRemove = dailyPlan.getAppliancebyId(uuidString) {
                            
                            
                            print(applianceToRemove)
                            dailyPlan.appliedAppliances.remove(appliance: applianceToRemove)
                        }
                        
                        
                        
                    })
                    
                    
                    
                }
                .sheet(isPresented: $showingApplianceCreateView) {
                    CoreApplianceEditorView(appliance: nil, createMode: true)
                        .presentationDetents([.fraction(0.50)])
                }
                .sheet(item: $dailyPlan.selectedApplianceToEdit) { selected in
                    CoreApplianceEditorView(appliance: selected)
                        .presentationDetents([.medium, .fraction(0.75)])
                }
            }
        }
        
    }
    
    // MARK: Private
    @State private var showingApplianceCreateView = false
    //    @State private var selectedApplianceToEdit: Appliance?
    
    @State private var info: String = "not yet"
    //    @State private var appliancesLoading: Bool = false
    @State private var pricesLoading: Bool = false
    
    @State private var currencyRatesLoading: Bool = false
    
    @State private var areAppliancesLabelsTouchLearned: Bool = false
    
    
    
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
        self.areAppliancesLabelsTouchLearned = SettingsManager.shared.getBoolValue(name: SettingsNames.areAppliancesLabelsTouchLearned)
    }
    
    //    private func fetchAppliances() async {
    //        appliancesLoading = true
    //        Task(priority: .background) {
    //            let response = await EnergramService().fetchAppliances()
    //            switch response {
    //            case .success(let result):
    //                dailyPlan.appliancesReceived(appliances: result)
    //                appliancesLoading = false
    //            case .failure(let error):
    //                print("Request failed with error: \(error.customMessage)")
    //                appliancesLoading = false
    //            }
    //        }
    //    }
    
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
        DayPlanView(dailyPlan: DailyPlan(type: .preview))
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
