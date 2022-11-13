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
    
    @ObservedObject var priceService = PriceService()
    
    let jsonFont = Font.system(size: 12).monospaced()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    if let days = priceService.multipleDaysPrices {
                        Text("Electricity price").fontWeight(.bold)
                        
                        ForEach(days) { day in
                            Text(day.dateFormatted)
                            Text("Received: \( day.receivedFormatted )").font(jsonFont)
                            
                            MiniChart(forDay: day)
                        }
                    }
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .onAppear {
                self.priceService.fetchMultipleDaysData()
            }
        }}
}

struct MultipleDaysChartView_Previews: PreviewProvider {
    static var previews: some View {
        LastDayJsonView()
    }
}
