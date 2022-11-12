//
//  LastDayJsonView.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import SwiftUI

struct LastDayJsonView: View {
    
    @ObservedObject var networkManager = NetworkManager()
    
//    let day = DayPrice(
//        id: UUID(), benchmark: 0.0001, datasource: "sex", measure: "Inch", data:[0.1,0.2,0.3]
//    )
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("RAW JSON:")
                    if let pr = networkManager.dayPrice {
                        Text(pr.as_json_string)
                    }
                    
                    
                }
                .padding()
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .onAppear {
                self.networkManager.fetchData()
            }
        }}
}

struct LastDayJsonView_Previews: PreviewProvider {
    static var previews: some View {
        LastDayJsonView()
    }
}
