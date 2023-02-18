//
//  ApplianceLabel.swift
//  Energram
//
//  Created by Alex Antipov on 02.12.2022.
//


import SwiftUI

struct ApplianceLabel: View {
    
    var appliance: Appliance
    
//    @Binding var appliancesBadgeCount: Int?
    
//    @EnvironmentObject var priceService: PriceService
    
    
    
    @State var isSelected: Bool
    
    var service: ApplianceService
    
    var dailyPlan: DailyPlan
    
    var disableInteraction: Bool = false
    
//    func random_label_color() -> Color {
//        return Color(
//            red: .random(in: 0.15...0.85),
//            green: .random(in: 0.15...0.85),
//            blue: .random(in: 0.15...0.85)
//        )
//    }
    
    var body: some View {
        
        
        Button {
            if !disableInteraction {
                dailyPlan.toggleApplianceLabel(applianceLabel: self)
//                service.toggleApplianceLabel(applianceLabel: self, priceService: priceService)
            }
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 8).foregroundColor( isSelected ? Palette.brandGreen : Palette.brandPurple )
                HStack(spacing: 0){
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle").resizable().padding(10).foregroundColor(.white).scaledToFit()
                    Text(appliance.name).font(.headline).foregroundColor(.white).padding(8)
                }
            }.fixedSize()
        }
    }
    
    
    
}

//struct ApplianceLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        ApplianceLabel(appliance: Appliance(name: "Device", typical_duration: 20, power: 200), isSelected: false, service: ApplianceService())
//    }
//}
