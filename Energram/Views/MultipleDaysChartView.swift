//
//  MultipleDaysChartView.swift
//  Energram
//
//  Created by Alex Antipov on 13.11.2022.
//

import SwiftUI
import Charts

struct BarTick2: Identifiable {
    var hour: Int
    var value: Float
    var id = UUID()
}

struct MultipleDaysChartView: View {
    
    
    @State private var countryCode: String = "es" // es, cz
    
    @StateObject var priceService = PriceService()
    
    let jsonFont = Font.system(size: 12).monospaced()
    
//    init(country: String) {
//        _countryCode = State(initialValue: country)
//    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    if let days = priceService.multipleDaysPrices {
                        
                        if countryCode == "es" {
                            Text("Electricity price 🇪🇸").font(.headlineCustom)
                        }
                        if countryCode == "cz" {
                            Text("Electricity price 🇨🇿").font(.headlineCustom)
                        }
                        
                        
                        ForEach(days) { day in
                            Text(day.dateFormatted).fontWeight(.bold)
                            MiniChart(forDay: day)
                        }
                    }
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .onAppear {
                
                countryCode = SettingsManager.shared.getStringValue(name: "CountryCode")
                
                self.priceService.fetchMultipleDaysData(for_country: countryCode)
            }
        }}
}

struct MultipleDaysChartView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleDaysChartView()
    }
}
