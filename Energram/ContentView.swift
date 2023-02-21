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
    
    
    @State private var country_code: String = "es"
    
    //@StateObject var priceService = PriceService()
    @StateObject var dailyPlan = DailyPlan()
    

    var body: some View {
        VStack {
            TabView {
                
                UserProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                                                
                DayPlanView(dailyPlan: dailyPlan)
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
//        .onAppear {
            
            //self.country_code = SettingsManager.shared.getStringValue(name: "CountryCode")
            
            // At launch, we send 2 requests to get initial data from API server to make our calculations possible
            //self.applianceService.fetchAppliancesData()
            //self.priceService.fetchData(for_country: country_code)
//        }
        //.environmentObject(applianceService)
        .environmentObject(dailyPlan)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    //static var priceService = PriceService()
    //static var applianceService = ApplianceService()
    
    static var previews: some View {
        ContentView()//.environmentObject(priceService).onAppear {
            //self.priceService.fetchMultipleDaysData(for_country: "es")
        //}.environmentObject(applianceService).onAppear {
            //self.applianceService.fetchAppliancesData()
        //}
    }
}
