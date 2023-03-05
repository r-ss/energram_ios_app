//
//  AppliedAppliancesView.swift
//  Energram
//
//  Created by Alex Antipov on 05.03.2023.
//

import SwiftUI

struct AppliedAppliancesView: View {
    
    @ObservedObject var dailyPlan: DailyPlan

    static let appliedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm")
        return formatter
    }()
    
    
    var body: some View {
        VStack {
//            Text("Hello, World!"
//            )
            ForEach(self.dailyPlan.appliedAppliances.items, id: \.self) { aa in
                HStack {
                    Text("\(aa.start, formatter: Self.appliedDateFormatter)")
                    Text("\(aa.duration)")
                    Text(aa.appliance.name)
                }

            }
        }
    }
}

struct AppliedAppliancesView_Previews: PreviewProvider {
//    var dailyPlan = DailyPlan()
//    dailyPlan.appliedAppliances.items = [AppliedAppliance.mocked.aa1]
    static var previews: some View {
        AppliedAppliancesView(dailyPlan: DailyPlan())
    }
}
