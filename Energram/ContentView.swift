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
    
//    @StateObject var priceService = PriceService()
    @StateObject var applianceService = ApplianceService()
    
//    @State var appliancesCountBadge: Int = 5
    
    
    
    var body: some View {
        VStack {
            TabView {
                
                MultipleDaysChartView(country: "es")
                    .tabItem {
                        Label("Price ES", systemImage: "chart.xyaxis.line")
                    }
//                    .tag(uuidLasttDayChart)
                
                MultipleDaysChartView(country: "cz")
                    .tabItem {
                        Label("Price CZ", systemImage: "chart.xyaxis.line")
                    }
//                    .tag(uuidLasttDayChart)
                
//                LastDayJsonView()
//                    .tabItem {
//                        Label("Latest Price Raw", systemImage: "text.word.spacing")
//                    }
////                    .tag(uuidLasttDayJson)
                
                AppliancesListView()
                    .tabItem {
                        Label("Appliances", systemImage: "fan.desk.fill")
                    }
                
                DayPlanView()
                    .tabItem {
                        Label("Daily plan", systemImage: "list.bullet.clipboard")
                    }
                    .badge(applianceService.appliancesCountBadge)
                
                
                DebugView()
                    .tabItem {
                        Label("Debug screen", systemImage: "gearshape.2.fill")
                    }
//                    .tag(uuidDebug)
                    //.badge(6)
                
                
                
            }
        }
        .background(Palette.background)
        .onAppear {
            self.applianceService.fetchAppliancesData()
        }
        .environmentObject(applianceService)
//        .environmentObject(priceService)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var applianceService = ApplianceService()
    
    static var previews: some View {
        ContentView().environmentObject(applianceService).onAppear {
            self.applianceService.fetchAppliancesData()
        }
    }
}
