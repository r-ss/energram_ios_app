//
//  LastDayChartView.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI
//import Charts



struct LastDayChartView: View {
    
    @ObservedObject var priceService = PriceService()
    
    
    
    
    let jsonFont = Font.system(size: 12).monospaced()
    
//    let y_labels = Array(0...23)
//
//    var ticks: [BarTick] {
//        var bin:[BarTick] = []
//        if let dp = priceService.dayPrice {
//
//            var hour = 0
//            for i in dp.data {
//                bin.append(BarTick(hour: hour, value: i))
//                hour+=1
//            }
//        }
//        return bin
//    }
    
//    init(country: String) {
//        _countryCode = State(initialValue: country)
//    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    if let dp = priceService.dayPrice {
                        Text("Electricity price in Spain for \(dp.dateFormatted) by hour:")
                        
                        MiniChart(forDay: dp)
                    }
                    

                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .onAppear {
                self.priceService.fetchData(for_country: "es")
            }
        }}
}

//struct LastDayChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        LastDayJsonView()
//    }
//}
