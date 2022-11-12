//
//  LastDayJsonView.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI

struct LastDayJsonView: View {
    
    @ObservedObject var priceService = PriceService()
    
    let jsonFont = Font.system(size: 12).monospaced()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("RAW JSON:")
                    if let dp = priceService.dayPrice {
                        Text(dp.as_json_string).font(jsonFont)
                    }
                    
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .onAppear {
                self.priceService.fetchData()
            }
        }}
}

struct LastDayJsonView_Previews: PreviewProvider {
    static var previews: some View {
        LastDayJsonView()
    }
}
