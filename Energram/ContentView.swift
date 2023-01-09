//
//  ContentView.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI



struct ContentView: View {
    
    //    @State private var uuidLasttDayChart = UUID()
    //    @State private var uuidLasttDayJson = UUID()
    //    @State private var uuidDebug = UUID()
    
    let settingsManager = SettingsManager()
    
    @State private var country_code: String = "es"
    
    @StateObject var priceService = PriceService()
    @StateObject var applianceService = ApplianceService()
    

    var body: some View {
        VStack {
            TabView {
                                                
                DayPlanView()
                    .tabItem {
                        Label("Daily plan", systemImage: "list.bullet.clipboard")
                    }
//                    .badge(applianceService.appliancesCountBadge)
                
                MultipleDaysChartView()
                    .tabItem {
                        Label("Price Chart", systemImage: "chart.xyaxis.line")
                    }
                
//                MultipleDaysChartView(country: "cz")
//                    .tabItem {
//                        Label("Price CZ", systemImage: "chart.xyaxis.line")
//                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.2.fill")
                    }
                
                
//                DebugView()
//                    .tabItem {
//                        Label("Debug screen", systemImage: "gearshape.2.fill")
//                    }
                
            }
        }
        .background(Palette.background)
        .onAppear {
            
            self.country_code = settingsManager.getStringValue(name: "CountryCode")
            
            // At launch, we send 2 requests to get initial data from API server to make our calculations possible
            self.applianceService.fetchAppliancesData()
            self.priceService.fetchData(for_country: country_code)
        }
        .environmentObject(applianceService)
        .environmentObject(priceService)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var priceService = PriceService()
    static var applianceService = ApplianceService()
    
    static var previews: some View {
        ContentView().environmentObject(applianceService).onAppear {
            self.applianceService.fetchAppliancesData()
        }.environmentObject(priceService).onAppear {
            self.priceService.fetchMultipleDaysData(for_country: "es")
        }
    }
}
