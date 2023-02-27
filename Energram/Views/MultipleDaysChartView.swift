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
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    if let days = self.prices {
                        
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
                    } else {
                        LoaderSpinner()
                    }
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .onAppear {
                countryCode = SettingsManager.shared.getStringValue(name: SettingsNames.countryCode)
                Task { await self.fetchPrices(forCountry: countryCode) }
            }
        }
    }
    
    // MARK: Private
    @State private var countryCode: String = "es" // es, cz
    
    @State private var prices: [DayPrice]?
    @State private var loadInProgress: Bool = false
    
    func fetchPrices(forCountry code: String) async {
        loadInProgress = true
        Task(priority: .background) {
            let response = await EnergramService().fetchPrices(forCountry: code)
            switch response {
            case .success(let result):
                prices = result
                loadInProgress = false
            case .failure(let error):
                print("Request failed with error: \(error.customMessage)")
                loadInProgress = false
            }
        }
    }
}

struct MultipleDaysChartView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleDaysChartView()
    }
}
